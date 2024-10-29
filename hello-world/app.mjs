import admin from 'firebase-admin';
import AWS from 'aws-sdk';

const secretsManager = new AWS.SecretsManager();

async function getSecretValue(secretName) {
    const data = await secretsManager.getSecretValue({ SecretId: secretName }).promise();
    const secret = data.SecretString ? JSON.parse(data.SecretString) : null;

    if (secret && secret.privateKey) {
        secret.privateKey = secret.privateKey.replace(/\\n/g, '\n');
    }

    return secret;
}

let firebaseInitialized = false;
async function initializeFirebase() {
    if (!firebaseInitialized) {

        const firebaseCredentials = await getSecretValue('FirebaseAdminCredentials');

        admin.initializeApp({
            credential: admin.credential.cert(firebaseCredentials),
        });
        firebaseInitialized = true;
        console.log('Firebase initialized successfully');
    }
}

export const handler = async (event) => {
    // Inicialize o Firebase antes de usar o serviço
    await initializeFirebase();

    const { title, body, route, fcmToken } = JSON.parse(event.body);

    const message = {
        notification: {
            title,
            body,
        },
        data: {
            url: route,
        },
        token: fcmToken,
    };

    try {
        console.log(`Start sendPushNotification - Request - ${JSON.stringify({ title, body, route, fcmToken })}`);

        const response = await admin.messaging().send(message);

        console.log(`Successfully sent message: ${response}`);
        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Push notification sent successfully' }),
        };
    } catch (error) {
        console.error(`Error sending message: ${error}`);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to send push ' }),
        };
    }
};
