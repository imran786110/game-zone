// Configuration - Update after deployment
const CONFIG = {
    userPoolId: 'YOUR_USER_POOL_ID',
    clientId: 'YOUR_CLIENT_ID',
    apiEndpoint: 'YOUR_API_ENDPOINT'
};

class AuthService {
    constructor() {
        this.token = localStorage.getItem('idToken');
        this.user = JSON.parse(localStorage.getItem('user') || 'null');
    }

    async signUp(email, password, username) {
        const response = await fetch(`https://cognito-idp.us-east-1.amazonaws.com/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-amz-json-1.1',
                'X-Amz-Target': 'AWSCognitoIdentityProviderService.SignUp'
            },
            body: JSON.stringify({
                ClientId: CONFIG.clientId,
                Username: email,
                Password: password,
                UserAttributes: [{ Name: 'email', Value: email }]
            })
        });
        return await response.json();
    }

    async signIn(email, password) {
        const response = await fetch(`https://cognito-idp.us-east-1.amazonaws.com/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-amz-json-1.1',
                'X-Amz-Target': 'AWSCognitoIdentityProviderService.InitiateAuth'
            },
            body: JSON.stringify({
                AuthFlow: 'USER_PASSWORD_AUTH',
                ClientId: CONFIG.clientId,
                AuthParameters: {
                    USERNAME: email,
                    PASSWORD: password
                }
            })
        });

        const data = await response.json();
        if (data.AuthenticationResult) {
            this.token = data.AuthenticationResult.IdToken;
            localStorage.setItem('idToken', this.token);
            localStorage.setItem('accessToken', data.AuthenticationResult.AccessToken);
            localStorage.setItem('refreshToken', data.AuthenticationResult.RefreshToken);
            await this.loadUserProfile();
        }
        return data;
    }

    async loadUserProfile() {
        const response = await fetch(`${CONFIG.apiEndpoint}/profile`, {
            headers: { 'Authorization': `Bearer ${this.token}` }
        });
        this.user = await response.json();
        localStorage.setItem('user', JSON.stringify(this.user));
    }

    async updateProfile(username) {
        const response = await fetch(`${CONFIG.apiEndpoint}/profile`, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${this.token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ username })
        });
        await this.loadUserProfile();
        return await response.json();
    }

    async saveScore(gameId, score, metadata = {}) {
        const response = await fetch(`${CONFIG.apiEndpoint}/scores`, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${this.token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ gameId, score, metadata })
        });
        return await response.json();
    }

    async getScores(gameId) {
        const response = await fetch(`${CONFIG.apiEndpoint}/scores/${gameId}`, {
            headers: { 'Authorization': `Bearer ${this.token}` }
        });
        return await response.json();
    }

    async getLeaderboard(gameId) {
        const response = await fetch(`${CONFIG.apiEndpoint}/leaderboard/${gameId}`);
        return await response.json();
    }

    signOut() {
        this.token = null;
        this.user = null;
        localStorage.clear();
        window.location.href = 'index.html';
    }

    isAuthenticated() {
        return !!this.token;
    }

    getUser() {
        return this.user;
    }
}

const auth = new AuthService();
