import json
import boto3
from datetime import datetime, date
import re
import os

IS_LOCAL = os.getenv('IS_LOCAL', 'false').lower() == 'true'

if IS_LOCAL:
    dynamodb = boto3.resource('dynamodb', endpoint_url='http://localhost:4566', region_name='us-west-2')
else:
    dynamodb = boto3.resource('dynamodb', region_name='us-west-2')

table = dynamodb.Table('users')

def validate_username(username):
    return username.isalpha()

def validate_date_of_birth(dob):
    try:
        dob_date = datetime.strptime(dob, '%Y-%m-%d').date()
        return dob_date < date.today()
    except ValueError:
        return False

def lambda_handler(event, context):
    username = event['pathParameters']['username']
    http_method = event['httpMethod']

    if not validate_username(username):
        return {
            'statusCode': 400,
            'body': json.dumps({"error": "Invalid username"})
        }

    if http_method == 'PUT':
        body = json.loads(event['body'])
        date_of_birth = body.get('dateOfBirth')

        if not validate_date_of_birth(date_of_birth):
            return {
                'statusCode': 400,
                'body': json.dumps({"error": "Invalid date of birth"})
            }

        table.put_item(
            Item={
                'username': username,
                'date_of_birth': date_of_birth
            }
        )
        return {
            'statusCode': 204,
            'body': ''
        }

    elif http_method == 'GET':
        response = table.get_item(
            Key={
                'username': username
            }
        )
        user = response.get('Item')

        if not user:
            return {
                'statusCode': 404,
                'body': json.dumps({"error": "User not found"})
            }

        today = date.today()
        dob_date = datetime.strptime(user['date_of_birth'], '%Y-%m-%d').date()
        next_birthday = dob_date.replace(year=today.year)
        if next_birthday < today:
            next_birthday = next_birthday.replace(year=today.year + 1)

        days_until_birthday = (next_birthday - today).days

        if days_until_birthday == 0:
            message = f"Hello, {username}! Happy birthday!"
        else:
            message = f"Hello, {username}! Your birthday is in {days_until_birthday} day(s)"

        return {
            'statusCode': 200,
            'body': json.dumps({"message": message})
        }

    return {
        'statusCode': 400,
        'body': 'Invalid HTTP method'
    }
