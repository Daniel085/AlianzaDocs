# Python Code Examples

Complete Python examples for working with the Alianza API.

## Setup

### Installation

```bash
pip install requests python-dotenv
```

### Environment Configuration

Create a `.env` file:

```env
ALIANZA_USERNAME=your-username
ALIANZA_PASSWORD=your-password
ALIANZA_BASE_URL=https://api.alianza.com
ALIANZA_PARTITION_ID=your-partition-id
```

## Complete SDK Client

```python
import os
import requests
import time
from datetime import datetime, timedelta
from typing import Optional, Dict, List
from dotenv import load_dotenv

load_dotenv()

class AlianzaClient:
    """Complete Alianza API client with authentication and error handling"""

    def __init__(
        self,
        username: str = None,
        password: str = None,
        base_url: str = None,
        partition_id: str = None
    ):
        self.username = username or os.getenv('ALIANZA_USERNAME')
        self.password = password or os.getenv('ALIANZA_PASSWORD')
        self.base_url = (base_url or os.getenv('ALIANZA_BASE_URL')).rstrip('/')
        self.partition_id = partition_id or os.getenv('ALIANZA_PARTITION_ID')

        self.token: Optional[str] = None
        self.token_expiry: Optional[datetime] = None
        self.user_id: Optional[str] = None

    def authenticate(self) -> Dict:
        """Obtain authentication token"""
        response = requests.post(
            f'{self.base_url}/v2/authorize',
            json={
                'userName': self.username,
                'password': self.password
            }
        )
        response.raise_for_status()

        data = response.json()
        self.token = data['authToken']
        self.token_expiry = datetime.now() + timedelta(seconds=data['expiresIn'])
        self.user_id = data.get('userId')

        return data

    def _ensure_authenticated(self):
        """Refresh token if expired or missing"""
        if not self.token or datetime.now() >= self.token_expiry - timedelta(minutes=5):
            self.authenticate()

    def _make_request(
        self,
        method: str,
        endpoint: str,
        **kwargs
    ) -> requests.Response:
        """Make authenticated API request with retry logic"""
        self._ensure_authenticated()

        headers = kwargs.pop('headers', {})
        headers['X-AUTH-TOKEN'] = self.token
        headers['Content-Type'] = 'application/json'

        url = f'{self.base_url}{endpoint}'

        # First attempt
        response = requests.request(method, url, headers=headers, **kwargs)

        # Retry on 401
        if response.status_code == 401:
            self.authenticate()
            headers['X-AUTH-TOKEN'] = self.token
            response = requests.request(method, url, headers=headers, **kwargs)

        response.raise_for_status()
        return response

    # Authentication Methods
    def logout(self):
        """Logout and invalidate token"""
        if self.token:
            requests.put(
                f'{self.base_url}/v2/authorize/logout',
                headers={'X-AUTH-TOKEN': self.token}
            )
            self.token = None
            self.token_expiry = None

    # Account Methods
    def list_accounts(self) -> List[Dict]:
        """List all accounts in partition"""
        response = self._make_request(
            'GET',
            f'/v2/partition/{self.partition_id}/account'
        )
        return response.json()

    def get_account(self, account_id: str) -> Dict:
        """Get account details"""
        response = self._make_request(
            'GET',
            f'/v2/partition/{self.partition_id}/account/{account_id}'
        )
        return response.json()

    def create_account(self, account_data: Dict) -> Dict:
        """Create new account"""
        response = self._make_request(
            'POST',
            f'/v2/partition/{self.partition_id}/account',
            json=account_data
        )
        return response.json()

    def update_account(self, account_id: str, account_data: Dict) -> Dict:
        """Update account"""
        response = self._make_request(
            'PUT',
            f'/v2/partition/{self.partition_id}/account/{account_id}',
            json=account_data
        )
        return response.json()

    def delete_account(self, account_id: str):
        """Delete account"""
        self._make_request(
            'DELETE',
            f'/v2/partition/{self.partition_id}/account/{account_id}'
        )

    # User Methods
    def list_users(self, account_id: str) -> List[Dict]:
        """List users in account"""
        response = self._make_request(
            'GET',
            f'/v2/partition/{self.partition_id}/account/{account_id}/user'
        )
        return response.json()

    def create_user(self, account_id: str, user_data: Dict) -> Dict:
        """Create end user"""
        response = self._make_request(
            'POST',
            f'/v2/partition/{self.partition_id}/account/{account_id}/user',
            json=user_data
        )
        return response.json()

    # Phone Number Methods
    def search_numbers(
        self,
        npa: str = None,
        nxx: str = None,
        quantity: int = 10
    ) -> List[Dict]:
        """Search for available phone numbers"""
        params = {'quantity': quantity}
        if npa:
            params['npa'] = npa
        if nxx:
            params['nxx'] = nxx

        response = self._make_request(
            'GET',
            f'/v2/partition/{self.partition_id}/telephone-number/search',
            params=params
        )
        return response.json()['telephoneNumbers']

    def order_number(self, telephone_number: str, account_id: str) -> Dict:
        """Order telephone number"""
        response = self._make_request(
            'POST',
            f'/v2/partition/{self.partition_id}/telephone-number/order',
            json={
                'telephoneNumbers': [telephone_number],
                'accountId': account_id
            }
        )
        return response.json()

    def assign_number(
        self,
        account_id: str,
        user_id: str,
        telephone_number: str,
        e911_address: Dict
    ) -> Dict:
        """Assign phone number to user with E911"""
        response = self._make_request(
            'PUT',
            f'/v2/partition/{self.partition_id}/account/{account_id}/user/{user_id}/telephone-number',
            json={
                'telephoneNumber': telephone_number,
                'primary': True,
                'e911Address': e911_address
            }
        )
        return response.json()

    # Address Methods
    def validate_address(
        self,
        address: str,
        postal_code: str,
        country: str = 'USA'
    ) -> Dict:
        """Validate address for E911"""
        response = self._make_request(
            'GET',
            '/v2/address/validate',
            params={
                'address': address,
                'postalCode': postal_code,
                'country': country
            }
        )
        return response.json()


# Usage Examples
if __name__ == '__main__':
    # Initialize client
    client = AlianzaClient()

    # Authenticate
    login_info = client.authenticate()
    print(f"Logged in as: {login_info['userName']}")

    # List accounts
    accounts = client.list_accounts()
    print(f"Found {len(accounts)} accounts")

    # Create account
    new_account = client.create_account({
        'accountNumber': '3001',
        'name': 'Python Test Account',
        'timeZone': 'America/New_York',
        'status': 'ACTIVE'
    })
    print(f"Created account: {new_account['accountId']}")

    # Search phone numbers
    numbers = client.search_numbers(npa='607', quantity=5)
    print(f"Available numbers: {[n['telephoneNumber'] for n in numbers]}")

    # Logout
    client.logout()
    print("Logged out")
```

## Quick Examples

### Authentication

```python
import requests

# Login
response = requests.post(
    'https://api.alianza.com/v2/authorize',
    json={'userName': 'user', 'password': 'pass'}
)
auth_data = response.json()
token = auth_data['authToken']

# Use token
headers = {'X-AUTH-TOKEN': token}
```

### Create Account

```python
account = {
    'accountNumber': '2001',
    'name': 'Acme Corp',
    'timeZone': 'America/New_York'
}

response = requests.post(
    f'https://api.alianza.com/v2/partition/{partition_id}/account',
    json=account,
    headers=headers
)
print(response.json())
```

### Search and Order Phone Number

```python
# Search
search_response = requests.get(
    f'https://api.alianza.com/v2/partition/{partition_id}/telephone-number/search',
    params={'npa': '607', 'quantity': 10},
    headers=headers
)
numbers = search_response.json()['telephoneNumbers']

# Order first number
order_response = requests.post(
    f'https://api.alianza.com/v2/partition/{partition_id}/telephone-number/order',
    json={
        'telephoneNumbers': [numbers[0]['telephoneNumber']],
        'accountId': account_id
    },
    headers=headers
)
print(order_response.json())
```

See other language examples:
- [Node.js](nodejs-examples.md)
- [PHP](php-examples.md)
- [Java](java-examples.md)
- [C#](csharp-examples.md)
- [Ruby](ruby-examples.md)
