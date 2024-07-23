import os
import firebase_admin
from google.oauth2 import service_account
from firebase_admin import auth, credentials, firestore
from flask_mail import Mail, Message
from google.cloud import firestore as gcf

mail = Mail()


service_account_path = "key.json"

# Initialize Firebase Admin SDK
cred = credentials.Certificate(service_account_path)
firebase_admin.initialize_app(cred, {'storageBucket': 'quicklyapp-61eaf.appspot.com'})

# Firebase database instance
db = firestore.client()

def signup_user(email, password, name, dob, contact, profile_image):
    user = auth.create_user(
        email=email,
        password=password,
        display_name=name,
    )
    user_record = {
        'email': email,
        'name': name,
        'contact': contact,
        'dob': dob,
        'profile_image': '',
    }
    db.collection('users').document(email).set(user_record)
    
    return user

def register_restaurant(email, password, name, address, location, contact, logo, banner):
    # Create a new user in Firebase Authentication
    restaurant = auth.create_user(
        email=email,
        password=password,
        display_name=name,
    )
    
    # Convert location to GeoPoint
    geo_point = gcf.GeoPoint(location['lat'], location['lng'])
    
    # Store restaurant information in Firestore
    restaurant_record = {
        'email': email,
        'name': name,
        'contact': contact,
        'address': address,
        'location': geo_point,
        'logo': '',
        'banner': '',
    }
    
    db.collection('restaurants').document(email).set(restaurant_record)
    
    return restaurant

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
