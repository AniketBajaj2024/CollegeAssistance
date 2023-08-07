import pandas as pd
import io
from flask import Flask, request, jsonify
import firebase_admin
from datetime import datetime
from firebase_admin import credentials, storage
# from google.auth.transport.requests import Request
# from google.oauth2 import service_account
# import google.auth

app = Flask(__name__)

# Import Firebase SDK and initialize Firebase app
# Replace with the appropriate Firebase credentials and configuration
cred = credentials.Certificate(r"C:\Users\Aniket\Desktop\maj_project\major-project-fda10-firebase-adminsdk-l2m5v-95473fc900.json")
firebase_admin.initialize_app(cred, {
    'storageBucket': 'major-project-fda10.appspot.com'
})

@app.route('/webhook', methods=['POST'])
def webhook():
    req = request.get_json(force=True)
    if 'queryResult' not in req:
        response_text = "Invalid request. 'queryResult' key is missing."
        response = {
            "fulfillmentMessages": [
                {
                    "text": {
                        "text": [response_text]
                    }
                }
            ]
        }
        return jsonify(response)

    intent_name = req['queryResult']['intent']['displayName']

    if intent_name == 'Timetable Intent':
        # Fetch the CSV data from Firebase Storage
        csv_data = get_csv_from_firebase()

        if csv_data:
            # Parse the CSV content using Pandas
            timetable_data = parse_csv_data(csv_data)

            # Create a response text with the timetable information
            response_text = "Here is your timetable:\n" + timetable_data
        else:
            response_text = "Sorry, the timetable data is not available at the moment."


    elif intent_name == 'Today\'s Timetable Intent':
        csv_data = get_csv_from_firebase()
        if csv_data:
            df = pd.read_csv(io.StringIO(csv_data))
            timetable_data = get_today_timetable(df)
            response_text = timetable_data
        else:
            response_text = "Sorry, the timetable data is not available."

    elif intent_name == 'Specific Day Timetable Intent':
        # Get the day from the user's query
        day = req['queryResult']['parameters']['day_of_week']
        csv_data = get_csv_from_firebase()
        if csv_data:
            df = pd.read_csv(io.StringIO(csv_data))
            timetable_data = get_specific_day_timetable(df, day)
            response_text = timetable_data

    elif intent_name == 'Attendance Intent':
        # Retrieve attendance data from Firebase Cloud Storage
        attendance_data = get_attendance_data()

        if attendance_data:
            # Create the attendance response
            response_text = attendance_data
        else:
            response_text = "Sorry, your attendance data is not available."

            

    else:
        response_text = "Sorry, the timetable data is not available."

    

    # Create a response JSON using the Dialogflow webhook response format
    response = {
        "fulfillmentMessages": [
            {
                "text": {
                    "text": [response_text]
                }
            }
        ]
    }

    return jsonify(response)

def get_csv_from_firebase():
    # Logic to fetch the CSV data from Firebase Storage
    bucket = storage.bucket()
    blob = bucket.blob('timetable.csv')

    try:
        csv_data = blob.download_as_text()
        return csv_data
    except Exception as e:
        print("Error fetching CSV data:", e)
        return None

def parse_csv_data(csv_data):
    # Parse the CSV content using Pandas
    df = pd.read_csv(io.StringIO(csv_data))
    
    # Process the CSV data and create the timetable information as a string
    timetable_data = ""
    for _, row in df.iterrows():
        timetable_data += f"{row['DAY']} - {row['TIME']} - {row['SUBJECT']} - {row['CLASS-ROOM']}\n"
        
    return timetable_data

def get_today_timetable(df):
    # Get the current day (Monday, Tuesday, etc.)
    current_day = datetime.now().strftime('%A')

    # Filter the DataFrame to get classes of today
    today_classes = df[df['DAY'] == current_day]

    # Create a response text with today's timetable
    timetable_data = "Here is today's timetable:\n"
    for _, row in today_classes.iterrows():
        timetable_data += f"{row['DAY']} - {row['TIME']} - {row['SUBJECT']} - {row['CLASS-ROOM']}\n"

    return timetable_data

def get_specific_day_timetable(df, day):
    # Filter the DataFrame to get classes of the specific day
    specific_day_classes = df[df['DAY'] == day]

    # Create a response text with the timetable of the specific day
    timetable_data = f"Here is the timetable for {day}:\n"
    for _, row in specific_day_classes.iterrows():
        timetable_data += f"{row['DAY']} - {row['TIME']} - {row['SUBJECT']} - {row['CLASS-ROOM']}\n"

    return timetable_data


def get_attendance_data():
    try:
        bucket = storage.bucket()
        blob = bucket.blob('attendence.csv')  # Replace with the actual path to your attendance CSV file
        attendance_data = blob.download_as_text()
        return attendance_data
    except Exception as e:
        print("Error fetching attendance data:", e)
        return "Error fetching attendance data."
    

# def create_attendance_response(attendance_data):
#     lines = attendance_data.strip().split('\n')
#     header = lines[0].split(',')
#     rows = [line.split(',') for line in lines[1:]]

#     # Create the attendance response
#     response_text = ""
#     for row in rows:
#         subject = row[0]
#         attendance = row[1]
#         total_classes = row[2]
#         response_text += f"{subject}\t{attendance}/{total_classes}\n"

#     return response_text


if __name__ == "__main__":
    app.run(debug=True)
