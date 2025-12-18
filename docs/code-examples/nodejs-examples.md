# Node.js Code Examples

Complete Node.js/JavaScript examples for working with the Alianza API.

## Setup

### Installation

```bash
npm install axios dotenv
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

```javascript
const axios = require('axios');
require('dotenv').config();

class AlianzaClient {
    constructor({
        username = process.env.ALIANZA_USERNAME,
        password = process.env.ALIANZA_PASSWORD,
        baseUrl = process.env.ALIANZA_BASE_URL,
        partitionId = process.env.ALIANZA_PARTITION_ID
    } = {}) {
        this.username = username;
        this.password = password;
        this.baseUrl = baseUrl.replace(/\/$/, '');
        this.partitionId = partitionId;

        this.token = null;
        this.tokenExpiry = null;
        this.userId = null;

        // Create axios instance
        this.client = axios.create({
            baseURL: this.baseUrl,
            headers: {
                'Content-Type': 'application/json'
            }
        });

        // Add request interceptor for authentication
        this.client.interceptors.request.use(
            async (config) => {
                await this._ensureAuthenticated();
                config.headers['X-AUTH-TOKEN'] = this.token;
                return config;
            },
            (error) => Promise.reject(error)
        );

        // Add response interceptor for retry on 401
        this.client.interceptors.response.use(
            (response) => response,
            async (error) => {
                if (error.response?.status === 401 && !error.config._retry) {
                    error.config._retry = true;
                    await this.authenticate();
                    error.config.headers['X-AUTH-TOKEN'] = this.token;
                    return this.client(error.config);
                }
                return Promise.reject(error);
            }
        );
    }

    async authenticate() {
        const response = await axios.post(`${this.baseUrl}/v2/authorize`, {
            userName: this.username,
            password: this.password
        });

        const data = response.data;
        this.token = data.authToken;
        this.tokenExpiry = new Date(Date.now() + data.expiresIn * 1000);
        this.userId = data.userId;

        return data;
    }

    async _ensureAuthenticated() {
        const now = new Date();
        const fiveMinutes = 5 * 60 * 1000;

        if (!this.token || now >= new Date(this.tokenExpiry - fiveMinutes)) {
            await this.authenticate();
        }
    }

    async logout() {
        if (this.token) {
            await axios.put(
                `${this.baseUrl}/v2/authorize/logout`,
                {},
                { headers: { 'X-AUTH-TOKEN': this.token } }
            );
            this.token = null;
            this.tokenExpiry = null;
        }
    }

    // Account Methods
    async listAccounts() {
        const response = await this.client.get(
            `/v2/partition/${this.partitionId}/account`
        );
        return response.data;
    }

    async getAccount(accountId) {
        const response = await this.client.get(
            `/v2/partition/${this.partitionId}/account/${accountId}`
        );
        return response.data;
    }

    async createAccount(accountData) {
        const response = await this.client.post(
            `/v2/partition/${this.partitionId}/account`,
            accountData
        );
        return response.data;
    }

    async updateAccount(accountId, accountData) {
        const response = await this.client.put(
            `/v2/partition/${this.partitionId}/account/${accountId}`,
            accountData
        );
        return response.data;
    }

    async deleteAccount(accountId) {
        await this.client.delete(
            `/v2/partition/${this.partitionId}/account/${accountId}`
        );
    }

    // User Methods
    async listUsers(accountId) {
        const response = await this.client.get(
            `/v2/partition/${this.partitionId}/account/${accountId}/user`
        );
        return response.data;
    }

    async createUser(accountId, userData) {
        const response = await this.client.post(
            `/v2/partition/${this.partitionId}/account/${accountId}/user`,
            userData
        );
        return response.data;
    }

    // Phone Number Methods
    async searchNumbers({ npa, nxx, quantity = 10 } = {}) {
        const params = { quantity };
        if (npa) params.npa = npa;
        if (nxx) params.nxx = nxx;

        const response = await this.client.get(
            `/v2/partition/${this.partitionId}/telephone-number/search`,
            { params }
        );
        return response.data.telephoneNumbers;
    }

    async orderNumber(telephoneNumber, accountId) {
        const response = await this.client.post(
            `/v2/partition/${this.partitionId}/telephone-number/order`,
            {
                telephoneNumbers: [telephoneNumber],
                accountId
            }
        );
        return response.data;
    }

    async assignNumber(accountId, userId, telephoneNumber, e911Address) {
        const response = await this.client.put(
            `/v2/partition/${this.partitionId}/account/${accountId}/user/${userId}/telephone-number`,
            {
                telephoneNumber,
                primary: true,
                e911Address
            }
        );
        return response.data;
    }

    // Address Methods
    async validateAddress(address, postalCode, country = 'USA') {
        const response = await this.client.get('/v2/address/validate', {
            params: { address, postalCode, country }
        });
        return response.data;
    }
}

// Export
module.exports = AlianzaClient;

// Usage Example
async function main() {
    const client = new AlianzaClient();

    try {
        // Authenticate
        const loginInfo = await client.authenticate();
        console.log(`Logged in as: ${loginInfo.userName}`);

        // List accounts
        const accounts = await client.listAccounts();
        console.log(`Found ${accounts.length} accounts`);

        // Create account
        const newAccount = await client.createAccount({
            accountNumber: '3002',
            name: 'Node.js Test Account',
            timeZone: 'America/New_York',
            status: 'ACTIVE'
        });
        console.log(`Created account: ${newAccount.accountId}`);

        // Search numbers
        const numbers = await client.searchNumbers({ npa: '607', quantity: 5 });
        console.log(`Available numbers:`, numbers.map(n => n.telephoneNumber));

        // Logout
        await client.logout();
        console.log('Logged out');

    } catch (error) {
        console.error('Error:', error.response?.data || error.message);
    }
}

// Run if executed directly
if (require.main === module) {
    main();
}
```

## Quick Examples

### Authentication

```javascript
const axios = require('axios');

async function authenticate() {
    const response = await axios.post(
        'https://api.alianza.com/v2/authorize',
        {
            userName: 'user',
            password: 'pass'
        }
    );

    const { authToken } = response.data;
    return authToken;
}
```

### Create Account

```javascript
const axios = require('axios');

async function createAccount(token, partitionId) {
    const response = await axios.post(
        `https://api.alianza.com/v2/partition/${partitionId}/account`,
        {
            accountNumber: '2001',
            name: 'Acme Corp',
            timeZone: 'America/New_York'
        },
        {
            headers: { 'X-AUTH-TOKEN': token }
        }
    );

    return response.data;
}
```

### Search and Order Phone Number

```javascript
async function searchAndOrder(token, partitionId, accountId) {
    // Search
    const searchResponse = await axios.get(
        `https://api.alianza.com/v2/partition/${partitionId}/telephone-number/search`,
        {
            params: { npa: '607', quantity: 10 },
            headers: { 'X-AUTH-TOKEN': token }
        }
    );

    const numbers = searchResponse.data.telephoneNumbers;

    // Order first number
    const orderResponse = await axios.post(
        `https://api.alianza.com/v2/partition/${partitionId}/telephone-number/order`,
        {
            telephoneNumbers: [numbers[0].telephoneNumber],
            accountId
        },
        {
            headers: { 'X-AUTH-TOKEN': token }
        }
    );

    return orderResponse.data;
}
```

## TypeScript Version

```typescript
import axios, { AxiosInstance } from 'axios';

interface AuthResponse {
    authToken: string;
    expiresIn: number;
    userId: string;
    partitionId: string;
}

interface Account {
    accountId?: string;
    accountNumber: string;
    name: string;
    timeZone: string;
    status?: string;
}

class AlianzaClient {
    private token: string | null = null;
    private tokenExpiry: Date | null = null;
    private client: AxiosInstance;

    constructor(
        private username: string,
        private password: string,
        private baseUrl: string,
        private partitionId: string
    ) {
        this.client = axios.create({
            baseURL: this.baseUrl,
            headers: { 'Content-Type': 'application/json' }
        });
    }

    async authenticate(): Promise<AuthResponse> {
        const response = await axios.post<AuthResponse>(
            `${this.baseUrl}/v2/authorize`,
            {
                userName: this.username,
                password: this.password
            }
        );

        this.token = response.data.authToken;
        this.tokenExpiry = new Date(Date.now() + response.data.expiresIn * 1000);

        return response.data;
    }

    async createAccount(accountData: Account): Promise<Account> {
        const response = await this.client.post<Account>(
            `/v2/partition/${this.partitionId}/account`,
            accountData,
            {
                headers: { 'X-AUTH-TOKEN': this.token! }
            }
        );

        return response.data;
    }
}
```

See other language examples:
- [Python](python-examples.md)
- [PHP](php-examples.md)
- [Java](java-examples.md)
- [C#](csharp-examples.md)
- [Ruby](ruby-examples.md)
