import json
import logging
import time
import random
import functions_framework
from flask import Flask, request, jsonify
from datetime import datetime
from flask_cors import CORS
from flask_mail import Mail, Message
from firebase_admin import firestore, auth, storage
from auth import signup_user, register_restaurant
from firebase_admin.firestore import GeoPoint
from config import Config
import urllib.parse
import requests
from google.cloud import firestore as gcf

# Firestore database instance
db = firestore.client()

# Initialize Flask app
quicklyapp = Flask(__name__)
# quicklyapp.config.from_object(Config)

CORS(quicklyapp)

# Paystack test secret key


quicklyapp.config['MAIL_SERVER'] = 'smtp.gmail.com'
quicklyapp.config['MAIL_PORT'] = 465
quicklyapp.config['MAIL_USERNAME'] = 'quicklyfoodapp@gmail.com'
quicklyapp.config['MAIL_PASSWORD'] = 'kuxbpkljubpnxncz'
quicklyapp.config['MAIL_USE_SSL'] = True

# Initialize Flask-Mail
mail = Mail(quicklyapp)


# Helper functions for checkout
PAYSTACK_SECRET_KEY = 'sk_test_1b5e7b55b0529bea234b2dae4e22a819c41e1849'

def remove_meal_from_cart(user_id, meal_id, restaurant_id):
    try:
        # Access the user's cart collection
        cart_ref = db.collection('users').document(user_id).collection('cart')
        cart_items = cart_ref.stream()

        for item in cart_items:
            # Check if both meal_id and restaurant_id match
            if (item.get('meal_id') == meal_id) and (item.get('restaurant_id') == restaurant_id):
                # Remove the meal from the cart
                cart_ref.document(item.id).delete()
                break

    except Exception as e:
        logging.error(f"Error removing meal from cart: {str(e)}")
        raise Exception(f"Error removing meal from cart: {str(e)}")

def verify_payment(paystack_payment_reference):
    headers = {
        'Authorization': f'Bearer {PAYSTACK_SECRET_KEY}',
        'Content-Type': 'application/json'
    }
    response = requests.get(f'https://api.paystack.co/transaction/verify/{paystack_payment_reference}', headers=headers)
    payment_data = response.json()
    
    logging.info(f"Paystack verification response: {payment_data}")
    
    if response.status_code != 200 or payment_data['data']['status'] != 'success':
        logging.error(f"Payment verification failed: {payment_data.get('message', 'No message')}")
        return {'success': False, 'error': 'Payment verification failed'}
    
    return {'success': True, 'payment_data': payment_data}

def update_order(restaurant_id, order_id, new_quantity):
    try:
        logging.info(f"Updating order for restaurant_id: {restaurant_id}, order_id: {order_id}, new_quantity: {new_quantity}")
        
        # Access the order document in the restaurant's orders collection
        order_ref = db.collection('restaurants').document(restaurant_id).collection('orders').document(order_id)
        order_doc = order_ref.get()

        if not order_doc.exists:
            logging.error("Order not found in restaurant's collection")
            return {'success': False, 'error': 'Order not found'}

        order_data = order_doc.to_dict()
        logging.info(f"Order data: {order_data}")

        # Calculate the new total price
        meal_price = order_data.get('price')
        new_total = meal_price * new_quantity

        # Update the restaurant's order document
        order_ref.update({
            'quantity': new_quantity,
            'total': new_total,
            'payment_status': 'paid'
        })

        # Access the order document in the user's orders collection
        user_id = order_data.get('user_id')
        user_order_ref = db.collection('users').document(user_id).collection('orders').document(order_id)
        user_order_doc = user_order_ref.get()

        if not user_order_doc.exists:
            logging.error("Order not found in user's collection")
            return {'success': False, 'error': 'User order not found'}

        # Update the user's order document
        user_order_ref.update({
            'quantity': new_quantity,
            'total': new_total,
            'payment_status': 'paid'
        })

        return {'success': True, 'message': 'Order updated successfully'}
    
    except Exception as e:
        logging.error(f"Error updating order: {str(e)}")
        return {'success': False, 'error': str(e)}



def checkout(user_id, restaurant_id, order_id, new_quantity, paystack_payment_reference):
    try:
        logging.info(f"Initiating checkout for user_id: {user_id}, restaurant_id: {restaurant_id}, order_id: {order_id}, new_quantity: {new_quantity}, paystack_payment_reference: {paystack_payment_reference}")

        # Verify payment with Paystack
        payment_verification_result = verify_payment(paystack_payment_reference)
        if not payment_verification_result['success']:
            logging.error(f"Payment verification failed: {payment_verification_result['error']}")
            return jsonify(payment_verification_result), 400

        logging.info(f"Payment verification result: {payment_verification_result}")

        # Update the order quantity and payment status
        order_update_result = update_order(restaurant_id, order_id, new_quantity)
        if not order_update_result['success']:
            logging.error(f"Order update failed: {order_update_result['error']}")
            return jsonify(order_update_result), 500

        logging.info(f"Order update result: {order_update_result}")

        # Remove the meal from the cart
        order_doc = db.collection('users').document(user_id).collection('orders').document(order_id).get()
        if not order_doc.exists:
            return jsonify({'error': 'Order not found'}), 404

        order_data = order_doc.to_dict()
        meal_id = order_data.get('meal_id')

        if meal_id:
            remove_meal_from_cart(user_id, meal_id, restaurant_id)

        return jsonify({'message': 'Checkout successful and payment verified, meal removed from cart', 'order_id': order_id}), 200

    except Exception as e:
        logging.error(f"Error during checkout: {str(e)}")
        return jsonify({'error': str(e)}), 500




# Sending email verification link
def send_verification_email(user):
    link = auth.generate_email_verification_link(user.email)
    msg = Message('Verify your email',
                  sender='quicklyfoodapp@gmail.com',
                  recipients=[user.email])
    msg.html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            body {{
                font-family: Arial, sans-serif;
            }}
            .email-content {{
                max-width: 600px;
                margin: 0 auto;
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 10px;
            }}
            .email-content p {{
                line-height: 1.5;
            }}
            .email-content a {{
                color: #1a73e8;
                text-decoration: none;
            }}
            .email-content a:hover {{
                text-decoration: underline;
            }}
            .email-signature {{
                margin-top: 20px;
            }}
        </style>
    </head>
    <body>
        <div class="email-content">
            <p>Hi {user.display_name},</p>
            <br>
            <p>Thanks for signing up to Quickly! Please verify your email by clicking on the link below:</p>
            <p><a href="{link}">Verify Email</a></p>
            <p>Welcome aboard!</p>
            <br>
            <div class="email-signature">
                <b>Regards,</b>
                <p>Quickly Team</p>
            </div>
        </div>
    </body>
    </html>
    """
    mail.send(msg)

# Sending welcome email
def send_welcome_email(user):
    msg = Message('Welcome to Quickly Food Ordering App',
                  sender='quicklyfoodapp@gmail.com',
                  recipients=[user.email])
    msg.html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            body {{
                font-family: Arial, sans-serif;
            }}
            .email-content {{
                max-width: 600px;
                margin: 0 auto;
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 10px;
            }}
            .email-content p {{
                line-height: 1.5;
            }}
            .email-signature {{
                margin-top: 20px;
            }}
            .logo {{
                display: block;
                margin: 0 auto 20px;
                max-width: 100%;
            }}
        </style>
    </head>
    <body>
        <div class="email-content">
            <img src="./images/quickly-logo.png" alt="Quickly Logo" class="logo"/>
            <p>Hi {user.display_name},</p>
            <p>Thanks for signing up to Quickly! Your journey to gaining weight and staying healthy has just commenced!</p>
            <p>Welcome aboard!</p>
            <br>
            <div class="email-signature">
                <b>Regards,</b>
                <p>Quickly Team</p>
            </div>
        </div>
    </body>
    </html>
    """
    
    mail.send(msg)



# Delaying the welcome email after sending the verification email
def delayed_welcome_email(user):
    time.sleep(20)
    send_welcome_email(user)

# Helper function to convert geo_pointss to strings
def convert_geo_point(geo_point):
    """Convert Firestore GeoPoint to a serializable format."""
    if geo_point:
        return {'latitude': geo_point.latitude, 'longitude': geo_point.longitude}
    return None

logging.basicConfig(level=logging.INFO)  # Set the desired log level

@functions_framework.http
def server(request):
    path = request.path

    # Log the request path
    logging.info(f"Received request path: {path}")

    if request.method == 'POST':
        if path == '/signup':
            return signup()
        elif path == '/login':
            return login()
        elif path == '/register_restaurant':
            return register_eatery()
        elif path.startswith('/restaurants/') and path.endswith('/create_meal'):
            # Extract restaurantid from the path
            parts = path.strip('/').split('/')
            # logging.info(f"Path parts: {parts}")  # Log the path parts
            
            if len(parts) == 3:  # e.g., /restaurants/{restaurantid}/create_meal
                restaurantid = parts[1]
                return create_meal(restaurantid)
            else:
                return jsonify({'error': 'Invalid request path'}), 404
        
        elif path.startswith('/users/') and '/restaurants/' in path and '/meals/' in path and path.endswith('/place_order'):
            parts = path.strip('/').split('/')
            logging.info(f"Path parts: {parts}")
            if len(parts) == 7:
                user_id = parts[1]
                restaurant_id = parts[3]
                meal_id = parts[5]
                data = request.get_json()
                quantity = data.get('quantity', 1)
                return place_order(user_id, restaurant_id, meal_id, quantity)
            else:
                return jsonify({'error': 'Invalid request path'}), 404

        elif path.startswith('/users/') and '/restaurants/' in path and '/meals/' in path and path.endswith('/add_to_cart'):
            parts = path.strip('/').split('/')
            logging.info(f"Path parts: {parts}")
            if len(parts) == 7:
                user_id = parts[1]
                restaurant_id = parts[3]
                meal_id = parts[5]
                data = request.get_json()
                quantity = data.get('quantity', 1)
                return add_to_cart(user_id, restaurant_id, meal_id, quantity)
            else:
                return jsonify({'error': 'Invalid request path'}), 404

        elif path == '/checkout':
            return checkout_endpoint()

        elif path == '/orders/deliver':
            if request.method == 'POST':
                data = request.get_json()
                restaurant_id = data.get('restaurant_id')
                order_id = data.get('order_id')
                if restaurant_id and order_id:
                    return deliver_order()
                else:
                    return jsonify({'error': 'Restaurant ID and Order ID are required'}), 400
            else:
                return jsonify({'error': 'Invalid request method'}), 405


    elif request.method == 'GET' and path == '/profile':
        return show_profile()

    elif request.method == 'GET' and path == '/restaurants':
        return get_all_restaurants()
        
    elif request.method == 'PATCH' and path.startswith('/restaurants/') and path.endswith('/edit_meal'):
        parts = path.strip('/').split('/')
        # logging.info(f"Path parts: {parts}")  # Log the path parts
        
        if len(parts) == 5:  # e.g., /restaurants/{restaurantid}/meals/{meal_id}/edit_meal
            restaurantid = parts[1]
            meal_id = parts[3]
            return edit_meal(restaurantid, meal_id)

    elif request.method == 'DELETE' and path.startswith('/restaurants/') and path.endswith('/delete_meal'):
        parts = path.strip('/').split('/')
        # logging.info(f"Path parts: {parts}")
        
        if len(parts) == 5:  # e.g., /restaurants/{restaurantid}/meals/{meal_id}/delete_meal
            restaurantid = parts[1]
            meal_id = parts[3]
            return delete_meal(restaurantid, meal_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404
    
    elif request.method == 'PATCH' and path.startswith('/restaurants/') and path.endswith('/edit_restaurant'):
        # Extract restaurant_id from the path
        parts = path.strip('/').split('/')
        # logging.info(f"Path parts: {parts}")  # Log the path parts
        
        if len(parts) == 3:  # e.g., /restaurants/{restaurant_id}/edit_restaurant
            restaurant_id = parts[1]
            logging.info(f"Extracted restaurant_id: {restaurant_id}")
            return edit_restaurant(restaurant_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404
            
    elif request.method == 'PATCH' and path == '/edit_profile':
        return edit_profile()

    elif request.method == 'GET' and path.startswith('/restaurants/') and path.endswith('/orders'):
        # Extract restaurant_id from the path
        parts = path.strip('/').split('/')
        logging.info(f"Path parts: {parts}")

        if len(parts) == 3: 
            restaurant_id = parts[1]
            logging.info(f"Extracted restaurant_id: {restaurant_id}")
            return get_orders_for_restaurant(restaurant_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404


    elif request.method == 'GET' and path.startswith('/restaurants/') and path.count('/') == 4:
        # Extract restaurant_id from the path
        parts = path.strip('/').split('/')
        # logging.info(f"Path parts: {parts}")  
        if len(parts) == 4:
            restaurant_id = parts[1]
            meal_id = parts[3]
            # logging.info(f"Extracted restaurant_id: {restaurant_id}")
            return get_meal_details(restaurant_id, meal_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404

    elif request.method == 'GET' and path.startswith('/restaurants/') and path.endswith('/featured_meals'):
        # Extract restaurant_id from the path
        parts = path.strip('/').split('/')
        # logging.info(f"Path parts: {parts}")
        
        if len(parts) == 3: 
            restaurant_id = parts[1]
            # logging.info(f"Extracted restaurant_id: {restaurant_id}")
            return get_featured_meals(restaurant_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404

    elif request.method == 'GET' and path == '/popular_meals':
        return get_popular_meals()

    elif request.method == 'GET' and path.startswith('/restaurants/') and path.endswith('/details'):
        # Extract restaurant_id from the path
        parts = path.strip('/').split('/')
        # logging.info(f"Path parts: {parts}")  
        if len(parts) == 3:
            restaurant_id = parts[1]
            # logging.info(f"Extracted restaurant_id: {restaurant_id}")
            return get_restaurant_details(restaurant_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404

    elif request.method == 'GET' and path.startswith('/restaurants/') and path.endswith('/meals'):
        # Extract restaurant_id from the path
        parts = path.strip('/').split('/')
        if len(parts) == 3:
            restaurant_id = parts[1]
            return get_meals(restaurant_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404

    elif request.method == 'GET' and path.startswith('/search'):
            meal_name = request.args.get('meal_name')
            if meal_name:
                return search_meals_by_name(meal_name)
            else:
                return jsonify({'error': 'Meal name query parameter is required'}), 400

    elif request.method == 'GET' and path.startswith('/users/') and path.endswith('/waiting_time'):
        parts = path.strip('/').split('/')
        # Logging the path parts for debugging
        logging.info(f"Path parts: {parts}")

        if len(parts) == 5:
            user_id = parts[1]
            order_id = parts[3]
            return get_waiting_time(user_id, order_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404


    elif request.method == 'DELETE' and path.startswith('/users/') and '/cart/' in path:
        parts = path.strip('/').split('/')
        if len(parts) == 4:  
            user_id = parts[1]
            cart_id = parts[3]
            return delete_cart(user_id, cart_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404
    
    elif request.method == 'GET' and path.startswith('/users/') and '/cart' in path:
        parts = path.strip('/').split('/')
        if len(parts) == 3:
            user_id = parts[1]
            return view_cart(user_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404

    elif request.method == 'GET' and path.startswith('/users/') and '/orders' in path:
        parts = path.strip('/').split('/')
        logging.info(f"Path split into parts: {parts}")
        if len(parts) == 3:  
            user_id = parts[1]
            logging.info(f"Extracted user_id: {user_id}")
            return get_user_orders(user_id)
        else:
            return jsonify({'error': 'Invalid request path'}), 404

    return jsonify({'error': 'Invalid request'}), 404


def signup():
    data = json.loads(request.data)

    # Check if any required field is missing or empty
    required_fields = ['email', 'password', 'name', 'dob', 'contact']
    for field in required_fields:
        if field not in data or not data.get(field):
            return jsonify({'error': f'Missing or empty required field: {field}'}), 400

    # Extract specific fields
    email = data['email']
    password = data['password']
    contact = data['contact']
    name = data['name']
    dob_str = data['dob']
    profile_image = ''

    # Validate contact to ensure that it starts with 0 and its length is 10
    if not contact.startswith('0') or len(contact) != 10 or not contact.isdigit():
        return jsonify({'error': 'Contact must start with 0 and be 10 digits long'}), 400

    # Validate email format
    if not (email.endswith('@ashesi.edu.gh') or email.endswith('@gmail.com')):
        return jsonify({'error': 'Email must end with @ashesi.edu.gh or @gmail.com'}), 400

    # Validate password complexity
    if len(password) < 8 or not any(char in '!@#$%^&*()_+-={}[]|\\:;"\'<>,.?/~`' for char in password):
        return jsonify({'error': 'Password must be at least 8 characters long and contain at least one special character'}), 400

    # Validate date of birth format and validity
    try:
        dob = datetime.strptime(dob_str, '%Y-%m-%d').date()
        if dob >= datetime.now().date():
            return jsonify({'error': 'Date of birth cannot be today or in the future!'}), 400
    except ValueError:
        return jsonify({'error': 'Invalid date of birth format. Please use YYYY-MM-DD.'}), 400

    try:
        # Check if profile already exists in database
        query = db.collection('users').where('email', '==', email)
        existing_records = query.stream()

        if len(list(existing_records)) > 0:
            return jsonify({'error': 'User with this email already exists.'}), 400

        # Sign up user
        user = signup_user(email, password, name, dob_str, contact, profile_image)

        # Send verification email
        send_verification_email(user)

        # Verify if email is verified immediately after signup (it will be False)
        user_record = auth.get_user(user.uid)
        email_verified = user_record.email_verified

        # Delayed sending of welcome email
        # Thread(target=delayed_welcome_email, args=(user,)).start()
        delayed_welcome_email(user)

        return jsonify({
            'message': f'User created successfully. Please check your email {email} to verify your account.',
            'email_verified': email_verified
        }), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 400

def login():
    data = json.loads(request.data)
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Email and password are required'}), 400

    try:
        # Firebase Auth REST API endpoint for signing in with email and password
        firebase_auth_url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword"
        api_key = "AIzaSyDn9yhKnKVYdtzrEAAUZTlYzJowmxUJUos"  

        payload = {
            "email": email,
            "password": password,
            "returnSecureToken": True
        }

        # Make a request to Firebase Auth REST API
        response = requests.post(firebase_auth_url, params={"key": api_key}, json=payload)
        response_data = response.json()

        if response.status_code != 200:
            return jsonify({'error': response_data.get('error', {}).get('message', 'An error occurred')}), 400

        id_token = response_data['idToken']

        # Verify the ID token using Firebase Admin SDK
        decoded_token = auth.verify_id_token(id_token)

        return jsonify({'message': 'Login successful', 'user': decoded_token}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400

        

def show_profile():
    email = request.args.get('email')

    if not email:
        return jsonify({'error': 'Email is required'}), 400

    try:
        user_ref = db.collection('users').document(email)
        user = user_ref.get()

        if not user.exists:
            return jsonify({'error': 'User not found'}), 404

        user_data = user.to_dict()

        return jsonify({'user': user_data}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400

def edit_profile():
    try:
        # Parse user ID from request
        user_id = request.form.get('email')
        if not user_id:
            return jsonify({'error': 'User ID is required'}), 400

        # Retrieve user document
        user_ref = db.collection('users').document(user_id)
        user = user_ref.get()

        if not user.exists:
            return jsonify({'error': 'User not found'}), 404

        # Extract existing profile data
        profile_data = user.to_dict()

        # Update fields if provided in the request
        name = request.form.get('name')
        dob = request.form.get('dob')
        contact = request.form.get('contact')

        if name:
            profile_data['name'] = name
        if dob:
            try:
                dob_date = datetime.strptime(dob, '%Y-%m-%d').date()
                if dob_date >= datetime.now().date():
                    return jsonify({'error': 'Date of birth cannot be today or in the future!'}), 400
                profile_data['dob'] = dob
            except ValueError:
                return jsonify({'error': 'Invalid date of birth format. Please use YYYY-MM-DD.'}), 400
        if contact:
            if not contact.startswith('0') or len(contact) != 10 or not contact.isdigit():
                return jsonify({'error': 'Contact must start with 0 and be 10 digits long'}), 400
            profile_data['contact'] = contact


        # Handle profile image upload
        if 'profile_image' in request.files:
            profile_image = request.files['profile_image']
            if profile_image.filename != '':
                # Upload to Firebase Storage
                bucket = storage.bucket()
                filename = f"user_{user_id}_{profile_image.filename}"  # Example: Use unique filename
                blob = bucket.blob(f'PROFILE_IMAGES/{filename}')
                # uploads the image
                blob.upload_from_string(profile_image.read(), content_type=profile_image.content_type)

                # Get downloadable URL
                profile_image_url = blob.public_url 

                # Get the URL with proper encoding
                encoded_path = urllib.parse.quote(blob.name, safe='')
                profile_image_url = f"https://firebasestorage.googleapis.com/v0/b/{bucket.name}/o/{encoded_path}?alt=media"


                # Update profile image URL in Firestore document
                profile_data['profile_image'] = profile_image_url

        # Update Firestore document
        user_ref.update(profile_data)

        return jsonify({'message': 'Profile edited successfully', 'updated_profile': profile_data}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500




def edit_restaurant(restaurant_id):
    try:
        # Retrieve restaurant document
        restaurant_ref = db.collection('restaurants').document(restaurant_id)
        restaurant = restaurant_ref.get()
        if not restaurant.exists:
            return jsonify({'error': 'Restaurant not found'}), 404

        # Extract existing restaurant data
        restaurant_data = restaurant.to_dict()

        # Convert GeoPoint fields to JSON serializable format
        for key, value in restaurant_data.items():
            if isinstance(value, GeoPoint):
                restaurant_data[key] = {
                    'latitude': value.latitude,
                    'longitude': value.longitude
                }

        # Extract fields from the request form
        name = request.form.get('name')
        contact = request.form.get('contact')
        # Validate contact if provided
        if contact and (not contact.startswith('0') or len(contact) != 10 or not contact.isdigit()):
            return jsonify({'error': 'Contact must start with 0 and be 10 digits long'}), 400

        # Update fields if provided in the request
        if name:
            restaurant_data['name'] = name
        if contact:
            restaurant_data['contact'] = contact
        
        # Handle logo image upload
        if 'logo' in request.files:
            logo = request.files['logo']
            if logo.filename != '':
                # Upload to Firebase Storage
                bucket = storage.bucket()
                filename = f"restaurant_{restaurant_id}_{logo.filename}"  # Example: Use unique filename
                blob = bucket.blob(f'RESTAURANT_IMAGES/{filename}')
                # uploads the image
                blob.upload_from_string(logo.read(), content_type=logo.content_type)

                # Get downloadable URL
                logo_url = blob.public_url 

                # Get the URL with proper encoding
                encoded_path = urllib.parse.quote(blob.name, safe='')
                logo_url = f"https://firebasestorage.googleapis.com/v0/b/{bucket.name}/o/{encoded_path}?alt=media"

                # Update profile image URL in Firestore document
                restaurant_data['logo'] = logo_url

        # Handle banner image upload
        if 'banner' in request.files:
            banner = request.files['banner']
            if banner.filename != '':
                # Upload to Firebase Storage
                bucket = storage.bucket()
                filename = f"restaurant_{restaurant_id}_{banner.filename}"  # Example: Use unique filename
                blob = bucket.blob(f'RESTAURANT_IMAGES/{filename}')
                # uploads the image
                blob.upload_from_string(banner.read(), content_type=banner.content_type)

                # Get downloadable URL
                banner_url = blob.public_url 

                # Get the URL with proper encoding
                encoded_path = urllib.parse.quote(blob.name, safe='')
                banner_url = f"https://firebasestorage.googleapis.com/v0/b/{bucket.name}/o/{encoded_path}?alt=media"

                # Update profile image URL in Firestore document
                restaurant_data['banner'] = banner_url

        # Update Firestore document
        restaurant_ref.update(restaurant_data)

        return jsonify({'message': 'Restaurant edited successfully', 'updated_restaurant': restaurant_data}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

        

def register_eatery():
    data = json.loads(request.data)

    # Check if any required field is missing or empty
    required_fields = ['email', 'password', 'name', 'location', 'contact']
    for field in required_fields:
        if field not in data or not data.get(field):
            return jsonify({'error': f'Missing or empty required field: {field}'}), 400
    
    name = data.get('name')
    email = data.get('email')
    address = data.get('address')
    location = data.get('location')
    password = data.get('password')
    contact = data.get('contact')
    logo = ''
    banner = ''


    # Validate contact to ensure that it starts with 0 and its length is 10
    if not contact.startswith('0') or len(contact) != 10 or not contact.isdigit():
        return jsonify({'error': 'Contact must start with 0 and be 10 digits long'}), 400

    # Validate email format
    if not (email.endswith('@ashesi.edu.gh') or email.endswith('@gmail.com')):
        return jsonify({'error': 'Email must end with @ashesi.edu.gh or @gmail.com'}), 400

    # Validate password complexity
    if len(password) < 8 or not any(char in '!@#$%^&*()_+-={}[]|\\:;"\'<>,.?/~`' for char in password):
        return jsonify({'error': 'Password must be at least 8 characters long and contain at least one special character'}), 400
    
    # Validate location format
    try:
        lat = location['lat']
        lng = location['lng']
        if not (-90 <= lat <= 90) or not (-180 <= lng <= 180):
            return jsonify({'error': 'Invalid latitude or longitude'}), 400
    except KeyError:
        return jsonify({'error': 'Location must include latitude and longitude'}), 400
    
    try:
        # Register restaurant
        restaurant = register_restaurant(email, password, name, address, location, contact, logo, banner)
        return jsonify({'message': 'Restaurant registered successfully.'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 400



def create_meal(restaurantid):
    try:
        logging.info(f"Creating meal for restaurant: {restaurantid}")

        # Retrieve restaurant document to ensure it exists
        restaurant_ref = db.collection('restaurants').document(restaurantid)
        restaurant = restaurant_ref.get()

        if not restaurant.exists:
            return jsonify({'error': 'Restaurant not found'}), 404

        # Extract meal details from the request form
        name = request.form.get('name')
        price = request.form.get('price')
        is_featured = False
        is_popular = False
        description = request.form.get('description')

        # Handle image upload
        meal_image = None
        if 'meal_image' in request.files:
            image_file = request.files['meal_image']
            if image_file.filename != '':
                # Upload to Firebase Storage
                bucket = storage.bucket()
                filename = f"meal_{restaurantid}_{image_file.filename}"  # Use unique filename
                blob = bucket.blob(f'MEAL_IMAGES/{filename}')
                
                # Upload the image
                blob.upload_from_string(image_file.read(), content_type=image_file.content_type)

                # Get the URL with proper encoding
                encoded_path = urllib.parse.quote(blob.name, safe='')
                meal_image = f"https://firebasestorage.googleapis.com/v0/b/{bucket.name}/o/{encoded_path}?alt=media"

        # Validate required fields
        if not name:
            return jsonify({'error': 'Name is required'}), 400
        if not price:
            return jsonify({'error': 'Price is required'}), 400
        if not meal_image:
            return jsonify({'error': 'Image of meal is required'}), 400

        try:
            price = float(price)
        except ValueError:
            return jsonify({'error': 'Price must be a valid number'}), 400

        # Check if a meal with the same name already exists in the restaurant
        meals_ref = db.collection('restaurants').document(restaurantid).collection('meals')
        existing_meal_query = meals_ref.where('name', '==', name).stream()

        if any(existing_meal_query):
            return jsonify({'error': f'Meal with name {name} already exists'}), 400

        # Determine the next meal ID
        existing_meals = meals_ref.stream()
        max_id = 0
        for meal in existing_meals:
            try:
                meal_id = int(meal.id)
                if meal_id > max_id:
                    max_id = meal_id
            except ValueError:
                continue

        new_id = max_id + 1

        # Create meal record
        meal = {
            'name': name,
            'description': description,
            'price': price,
            'meal_image': meal_image,
            'is_featured': is_featured,
            'is_popular': is_popular
        }

        # Add meal to the restaurant's collection using the integer ID
        meals_ref.document(str(new_id)).set(meal)

        return jsonify({'message': 'Meal created successfully', 'meal_id': new_id}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500



def edit_meal(restaurantid, meal_id):
    try:
        # Retrieve meal document to ensure it exists
        meal_ref = db.collection('restaurants').document(restaurantid).collection('meals').document(meal_id)
        meal = meal_ref.get()

        if not meal.exists:
            return jsonify({'error': 'Meal not found'}), 404

        # Extract fields from the request form
        updates = {}
        if 'name' in request.form:
            updates['name'] = request.form.get('name')
        if 'description' in request.form:
            updates['description'] = request.form.get('description')
        if 'price' in request.form:
            try:
                updates['price'] = float(request.form.get('price'))
            except ValueError:
                return jsonify({'error': 'Price must be a valid number'}), 400
        if 'is_featured' in request.form:
            updates['is_featured'] = request.form.get('is_featured').lower() == 'true'
        if 'is_popular' in request.form:
            updates['is_popular'] = request.form.get('is_popular').lower() == 'true'

        # Handle image upload if provided
        if 'meal_image' in request.files:
            image_file = request.files['meal_image']
            if image_file.filename != '':
                # Upload to Firebase Storage
                bucket = storage.bucket()
                filename = f"meal_{restaurantid}_{image_file.filename}"  # Use unique filename
                blob = bucket.blob(f'MEAL_IMAGES/{filename}')
                
                # Upload the image
                blob.upload_from_string(image_file.read(), content_type=image_file.content_type)

                # Get the URL with proper encoding
                encoded_path = urllib.parse.quote(blob.name, safe='')
                meal_image = f"https://firebasestorage.googleapis.com/v0/b/{bucket.name}/o/{encoded_path}?alt=media"
                updates['meal_image'] = meal_image

        # Update meal record
        if updates:
            meal_ref.update(updates)

        return jsonify({'message': 'Meal updated successfully'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500



def delete_meal(restaurantid, meal_id):
    try:
        # Retrieve meal document to ensure it exists
        meal_ref = db.collection('restaurants').document(restaurantid).collection('meals').document(meal_id)
        meal = meal_ref.get()

        if not meal.exists:
            return jsonify({'error': 'Meal not found'}), 404

        # Delete meal record
        meal_ref.delete()

        return jsonify({'message': 'Meal deleted successfully'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


def get_meals(restaurantid):
    try:
        # logging.info(f"Retrieving meals for restaurant: {restaurantid}")

        # Retrieve restaurant document to ensure it exists
        restaurant_ref = db.collection('restaurants').document(restaurantid)
        restaurant = restaurant_ref.get()

        if not restaurant.exists:
            return jsonify({'error': 'Restaurant not found'}), 404

        # Retrieve all meals for the restaurant
        meals_ref = restaurant_ref.collection('meals')
        meals = meals_ref.stream()

        # Collect meal details into a list
        meal_list = []
        for meal in meals:
            meal_data = meal.to_dict()
            meal_data['id'] = meal.id  # Add the document ID to the meal data
            meal_list.append(meal_data)

        return jsonify({'meals': meal_list}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


def get_featured_meals(restaurant_id):
    try:
        # logging.info(f"Retrieving featured meals for restaurant: {restaurant_id}")

        # Reference to the meals collection of the specified restaurant
        meals_ref = db.collection('restaurants').document(restaurant_id).collection('meals')
        
        # Query to get all meals with is_featured set to True
        query = meals_ref.where('is_featured', '==', True)
        featured_meals = query.stream()

        # Prepare a list to hold the featured meals
        meals_list = []
        for meal in featured_meals:
            meal_data = meal.to_dict()
            meal_data['id'] = meal.id  # Add the meal ID to the meal data
            meals_list.append(meal_data)

        return jsonify(meals_list), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400


def get_popular_meals():
    try:
        # logging.info("Retrieving popular meals from all restaurants")

        # Reference to the restaurants collection
        restaurants_ref = db.collection('restaurants')
        restaurants = restaurants_ref.stream()

        # Prepare a list to hold all popular meals
        popular_meals_list = []

        # Iterate through each restaurant
        for restaurant in restaurants:
            restaurant_id = restaurant.id
            restaurant_data = restaurant.to_dict()
            restaurant_name = restaurant_data.get('name')
            restaurant_address = restaurant_data.get('address')
            meals_ref = db.collection('restaurants').document(restaurant_id).collection('meals')

            # Query to get all meals with is_popular set to True
            query = meals_ref.where('is_popular', '==', True)
            popular_meals = query.stream()

            # Collect popular meals from this restaurant
            for meal in popular_meals:
                meal_data = meal.to_dict()
                meal_data['id'] = meal.id  
                meal_data['restaurant_id'] = restaurant_id
                meal_data['restaurant_name'] = restaurant_name
                meal_data['restaurant_location'] = restaurant_address
                popular_meals_list.append(meal_data)

        return jsonify(popular_meals_list), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400


def get_restaurant_details(restaurant_id):
    try:
        # logging.info(f"Retrieving details for restaurant: {restaurant_id}")

        # Reference to the specific restaurant document
        restaurant_ref = db.collection('restaurants').document(restaurant_id)
        restaurant = restaurant_ref.get()

        if not restaurant.exists:
            return jsonify({'error': 'Restaurant not found'}), 404

        # Convert restaurant document to dictionary
        restaurant_data = restaurant.to_dict()

        # Convert GeoPoint fields to JSON serializable format
        for key, value in restaurant_data.items():
            if isinstance(value, GeoPoint):
                restaurant_data[key] = {
                    'latitude': value.latitude,
                    'longitude': value.longitude
                }
        restaurant_data['restaurant_id'] = restaurant.id

        return jsonify(restaurant_data), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400


def get_all_restaurants():
    try:
        # Query the restaurants collection
        restaurants_ref = db.collection('restaurants')
        docs = restaurants_ref.stream()

        # Collect restaurant data
        restaurants = []
        for doc in docs:
            restaurant = doc.to_dict()
            restaurant['restaurant_id'] = doc.id

            # Convert GeoPoint fields to JSON serializable format
            for key, value in restaurant.items():
                if isinstance(value, GeoPoint):
                    restaurant[key] = convert_geo_point(value)
            
            restaurants.append(restaurant)

        return jsonify({'restaurants': restaurants}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


def get_meal_details(restaurant_id, meal_id):
    try:
        # Access the meals collection within the specified restaurant
        meal_ref = db.collection('restaurants').document(restaurant_id).collection('meals').document(meal_id)
        meal_doc = meal_ref.get()

        if not meal_doc.exists:
            return jsonify({'error': 'Meal not found'}), 404

        meal_data = meal_doc.to_dict()

        # Retrieve restaurant details
        restaurant_ref = db.collection('restaurants').document(restaurant_id)
        restaurant_doc = restaurant_ref.get()

        if not restaurant_doc.exists:
            return jsonify({'error': 'Restaurant not found'}), 404

        restaurant_data = restaurant_doc.to_dict()

        # Combine meal and restaurant data
        response_data = meal_data
        response_data.update({
            'restaurant_name': restaurant_data.get('name'),
            'restaurant_location': restaurant_data.get('location'),
            'restaurant_id': restaurant_id
        })

        # Convert GeoPoint fields to JSON serializable format
        for key, value in response_data.items():
            if isinstance(value, GeoPoint):
                response_data[key] = {
                    'latitude': value.latitude,
                    'longitude': value.longitude
                }

        return jsonify(response_data), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


def search_meals_by_name(meal_name):
    try:
        results = []
        search_term = meal_name.lower()

        # Iterate over all restaurants
        restaurants_ref = db.collection('restaurants').stream()
        for restaurant_doc in restaurants_ref:
            restaurant_data = restaurant_doc.to_dict()
            restaurant_id = restaurant_doc.id
            restaurant_name = restaurant_data.get('name')

            # Iterate over all meals in the current restaurant
            meals_ref = db.collection('restaurants').document(restaurant_id).collection('meals').stream()
            for meal_doc in meals_ref:
                meal_data = meal_doc.to_dict()
                meal_name_lower = meal_data.get('name', '').lower()
                meal_description_lower = meal_data.get('description', '').lower()
                if search_term in meal_name_lower or search_term in meal_description_lower:
                    meal_id = meal_doc.id
                    price = meal_data.get('price')
                    results.append({
                        'meal_name': meal_data.get('name'),
                        'restaurant_id': restaurant_id,
                        'meal_id': meal_id,
                        'restaurant_name': restaurant_name,
                        'price': price
                    })

        if not results:
            return jsonify({'error': 'No meals found with the given name or description'}), 404

        return jsonify(results), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


# Add to Orders
def place_order(user_id, restaurant_id, meal_id, quantity):
    try:
        # Access the meal document
        meal_ref = db.collection('restaurants').document(restaurant_id).collection('meals').document(meal_id)
        meal_doc = meal_ref.get()

        if not meal_doc.exists:
            return jsonify({'error': 'Meal not found'}), 404

        meal_data = meal_doc.to_dict()

        # Retrieve restaurant details
        restaurant_ref = db.collection('restaurants').document(restaurant_id)
        restaurant_doc = restaurant_ref.get()

        if not restaurant_doc.exists:
            return jsonify({'error': 'Restaurant not found'}), 404

        restaurant_data = restaurant_doc.to_dict()

        # Retrieve user details
        user_ref = db.collection('users').document(user_id)
        user_doc = user_ref.get()

        if not user_doc.exists:
            return jsonify({'error': 'User not found'}), 404

        user_data = user_doc.to_dict()

        # Generate a unique order ID for the user's orders collection
        user_orders_ref = db.collection('users').document(user_id).collection('orders')
        new_order_id = user_orders_ref.document().id  # This creates a unique document ID

        # Calculate the total price
        meal_price = meal_data.get('price')
        total_price = meal_price * quantity

        # Add order details to the orders collection within the restaurant
        order_data = {
            'user_name': user_data.get('name'),
            'user_contact': user_data.get('contact'),
            'meal_id': meal_id,
            'user_id': user_doc.id,
            'meal_name': meal_data.get('name'),
            'meal_image': meal_data.get('meal_image'),
            'quantity': quantity,
            'price': meal_price,
            'total': total_price,
            'payment_status': 'pending',
            'timestamp': firestore.SERVER_TIMESTAMP
        }

        # Add order to the restaurant's orders collection using the unique ID
        restaurant_orders_ref = db.collection('restaurants').document(restaurant_id).collection('orders')
        restaurant_orders_ref.document(new_order_id).set(order_data)

        # Add order details to the user's orders collection using the same unique ID
        user_order_data = {
            'meal_id': meal_id,
            'meal_name': meal_data.get('name'),
            'meal_image': meal_data.get('meal_image'),
            'quantity': quantity,
            'payment_status': 'pending',
            'total': total_price,
            'delivery_status': 'pending',  # Default status
            'timestamp': firestore.SERVER_TIMESTAMP,
            'restaurant_name': restaurant_data.get('name')
        }

        user_orders_ref.document(new_order_id).set(user_order_data)

        return jsonify({'message': 'Order placed successfully', 'order_id': new_order_id}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500



def add_to_cart(user_id, restaurant_id, meal_id, quantity):
    try:
        # Access the meal document
        meal_ref = db.collection('restaurants').document(restaurant_id).collection('meals').document(meal_id)
        meal_doc = meal_ref.get()

        if not meal_doc.exists:
            return jsonify({'error': 'Meal not found'}), 404

        meal_data = meal_doc.to_dict()

        # Retrieve restaurant details
        restaurant_ref = db.collection('restaurants').document(restaurant_id)
        restaurant_doc = restaurant_ref.get()

        if not restaurant_doc.exists:
            return jsonify({'error': 'Restaurant not found'}), 404

        restaurant_data = restaurant_doc.to_dict()

        # Reference to the cart item in the user's cart
        cart_ref = db.collection('users').document(user_id).collection('cart').document(meal_id)
        cart_doc = cart_ref.get()

        if cart_doc.exists:
            # If the meal is already in the cart, increment the quantity
            existing_cart_item = cart_doc.to_dict()
            new_quantity = existing_cart_item.get('quantity', 0) + quantity
            cart_ref.update({'quantity': new_quantity})
            message = 'Meal quantity updated successfully'
        else:
            # If the meal is not in the cart, add it as a new item
            cart_item_data = {
                'meal_id': meal_id,
                'restaurant_id': restaurant_id,
                'meal_name': meal_data.get('name'),
                'meal_image': meal_data.get('meal_image'),
                'restaurant_name': restaurant_data.get('name'),
                'price': meal_data.get('price'),
                'quantity': quantity
            }
            cart_ref.set(cart_item_data)
            message = 'Meal added to cart successfully'

        return jsonify({'message': message}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


# Delete Cart
def delete_cart(user_id, cart_id):
    try:
        # Access the cart item document using the unique cart ID
        cart_item_ref = db.collection('users').document(user_id).collection('cart').document(cart_id)
        cart_item_doc = cart_item_ref.get()

        if not cart_item_doc.exists:
            return jsonify({'error': 'Cart item not found'}), 404

        # Delete the cart item
        cart_item_ref.delete()

        return jsonify({'message': 'Cart item deleted successfully'}), 200

    except Exception as e:
        # Log the exception details for debugging
        logging.error(f"Error deleting cart item: {e}")
        return jsonify({'error': str(e)}), 500


def view_cart(user_id):
    try:
        # Access the cart collection for the specified user
        cart_ref = db.collection('users').document(user_id).collection('cart')
        cart_items = cart_ref.stream()

        # Create a list to hold the cart items
        cart_list = []
        for item in cart_items:
            cart_item = item.to_dict()
            cart_item['id'] = item.id
            cart_list.append(cart_item)

        # Return the cart items as JSON
        return jsonify({'cart': cart_list}), 200

    except Exception as e:
        # Log the exception details for debugging
        logging.error(f"Error retrieving cart items: {e}")
        return jsonify({'error': str(e)}), 500


def checkout_endpoint():
    try:
        data = json.loads(request.data)
        user_id = data.get('user_id')
        restaurant_id = data.get('restaurant_id')
        order_id = data.get('order_id')
        new_quantity = data.get('new_quantity')
        paystack_payment_reference = data.get('paystack_payment_reference')

        logging.info(f"Checkout request: {data}")

        return checkout(user_id, restaurant_id, order_id, new_quantity, paystack_payment_reference)
    except Exception as e:
        logging.error(f"Error in checkout endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500


# Getting orders made by a user
def handle_user_orders(user_id):
    logging.info(f"Extracted user_id: {user_id}")
    return get_user_orders(user_id)

def get_user_orders(user_id):
    try:
        logging.info(f"Fetching orders for user ID: {user_id}")

        if not user_id:
            return jsonify({'error': 'User ID is required'}), 400

        # Query the user's orders collection
        user_orders_ref = db.collection('users').document(user_id).collection('orders')
        user_orders = user_orders_ref.stream()

        orders_list = [order.to_dict() for order in user_orders]

        return jsonify({'orders': orders_list}), 200

    except Exception as e:
        logging.error(f"Error in get_user_orders: {str(e)}")
        return jsonify({'error': str(e)}), 500




# Marking an Order as delivered
def mark_order_as_delivered(restaurant_id, order_id, time_to_wait):
    # Retrieve the order document from the restaurant's orders collection
    order_ref = db.collection('restaurants').document(restaurant_id).collection('orders').document(order_id)
    order_doc = order_ref.get()
    if not order_doc.exists:
        raise Exception('Order not found')
    order_data = order_doc.to_dict()
    user_id = order_data.get('user_id')

    if not user_id:
        raise Exception('User ID not found in the order data')

    # Access the order document in the user's orders collection and update the waiting time
    user_order_ref = db.collection('users').document(user_id).collection('orders').document(order_id)
    user_order_ref.update({'waiting_time_seconds': time_to_wait})

    # Immediately update the delivered status to True in the restaurant's orders collection
    order_ref.update({'delivered': True})

    # Simulate waiting time
    time.sleep(time_to_wait)

    # Update the delivery status after the waiting time has elapsed
    user_order_ref.update({'delivery_status': 'delivered'})
    # order_ref.update({'delivery_status': 'delivered'})

def deliver_order():
    try:
        data = request.json
        restaurant_id = data.get('restaurant_id')
        order_id = data.get('order_id')

        if not restaurant_id or not order_id:
            return jsonify({'error': 'Restaurant ID and Order ID are required'}), 400

        # Random time between 3 to 5 minutes in seconds
        time_to_wait = random.randint(20, 55)

        # Start the delayed delivery process
        mark_order_as_delivered(restaurant_id, order_id, time_to_wait)

        mark_order_as_delivered(restaurant_id, order_id, time_to_wait)

        return jsonify({
            'message': 'Order delivered successfully',
            'estimated_waiting_time_seconds': time_to_wait,
            'delivered': True
        }), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


def get_waiting_time(user_id, order_id):
    try:
        logging.info(f"Fetching waiting time for user_id: {user_id}, order_id: {order_id}")

        # Access the user's orders collection and the specific order document
        user_order_ref = db.collection('users').document(user_id).collection('orders').document(order_id)
        user_order_doc = user_order_ref.get()

        if not user_order_doc.exists:
            logging.error(f"Order not found in user's collection: {user_id}/{order_id}")
            return jsonify({'error': 'Order not found'}), 404

        order_data = user_order_doc.to_dict()
        waiting_time = order_data.get('waiting_time_seconds')

        if waiting_time is None:
            logging.error(f"Waiting time not found in order data for order_id: {order_id}")
            return jsonify({'error': 'Waiting time not found'}), 404

        logging.info(f"Retrieved waiting time: {waiting_time}")

        return jsonify({'waiting_time_seconds': waiting_time}), 200

    except Exception as e:
        logging.error(f"Error fetching waiting time: {str(e)}")
        return jsonify({'error': str(e)}), 500


def get_orders_for_restaurant(restaurant_id):
    try:
        logging.info(f"Fetching orders for restaurant_id: {restaurant_id}")

        # Access the restaurant's orders collection
        orders_ref = db.collection('restaurants').document(restaurant_id).collection('orders')
        orders_docs = orders_ref.stream()

        orders = []
        for order_doc in orders_docs:
            order_data = order_doc.to_dict()
            order_data['order_id'] = order_doc.id  # Add the order ID to the data
            orders.append(order_data)

        logging.info(f"Retrieved {len(orders)} orders for restaurant_id: {restaurant_id}")

        return jsonify({'orders': orders}), 200

    except Exception as e:
        logging.error(f"Error fetching orders for restaurant_id {restaurant_id}: {str(e)}")
        return jsonify({'error': str(e)}), 500
