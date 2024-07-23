import requests
import os
from datetime import date

BASE_URL = os.getenv('ENDPOINT')

def test_put_user():
    response = requests.put(f"{BASE_URL}/john", json={"dateOfBirth": "1990-07-20"})
    assert response.status_code == 204

def test_get_user_birthday():
    response = requests.get(f"{BASE_URL}/john")
    assert response.status_code == 200
    assert "Hello, john! Your birthday is in" in response.json()["message"]

def test_user_today_birthday():
    today_date = date.today().strftime('%Y-%m-%d')
    response = requests.put(f"{BASE_URL}/doe", json={"dateOfBirth": today_date})
    assert response.status_code == 400
    response = requests.get(f"{BASE_URL}/doe")
    assert response.status_code == 404

test_put_user()
test_get_user_birthday()
test_user_today_birthday()