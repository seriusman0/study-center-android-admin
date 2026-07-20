import requests
import re

session = requests.Session()

# 1. Get login page
login_url = "https://studycenter.seriusman.shop/login"
response = session.get(login_url)

csrf_token = ''
match = re.search(r'name="_token" value="([^"]+)"', response.text)
if match:
    csrf_token = match.group(1)
else:
    match = re.search(r'content="([^"]+)" name="csrf-token"', response.text)
    if match:
        csrf_token = match.group(1)

# 2. Login
login_data = {
    '_token': csrf_token,
    'login': 'admin@studycenter.com',
    'password': 'password'
}

response = session.post(login_url, data=login_data)

# 3. Get presensi/create
create_url = "https://studycenter.seriusman.shop/presensi/create"
response = session.get(create_url)

print("Status code:", response.status_code)
print("Form fields on presensi/create:")
# Extract inputs, selects, textareas
fields = re.findall(r'<(?:input|select|textarea)[^>]*name="([^"]+)"', response.text)
for field in list(dict.fromkeys(fields)):
    print(f"Field: {field}")

