import os

class Config:
    SECRET_KEY = b'\x05S\x8f\x0e\x91\x83\xd8\xc9\xd3\xd5I\xe1\x9b\x12wfZz\x0b\xe6z\xb4\xb2+'
    FIREBASE_CONFIG = {
        "apiKey": "AIzaSyD0UGb-Nyc0Pin_bLYDT2g2F3E6cQBQxFE",
        "authDomain": "quicklyapp-89f1b.firebaseapp.com",
        "databaseURL": "https://quicklyapp-89f1b-default-rtdb.firebaseio.com/",
        "projectId": "quicklyapp-89f1b",
        "storageBucket": "quicklyapp-89f1b.appspot.com",
        "messagingSenderId": "842591682894",
        "appId": "1:842591682894:web:45251c9e4d95c49bf99e1f"
    }
    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 587
    MAIL_USE_TLS = True
    MAIL_USERNAME = "quicklyfoodapp@gmail.com"
    MAIL_PASSWORD = 'gwtiwcpyirrotjvr'

