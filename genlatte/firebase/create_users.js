const admin = require('firebase-admin');

// Initialize Firebase Admin
admin.initializeApp();

const auth = admin.auth();

const branch = process.env.BRANCH_NAME;
const password = process.env.USER_PASSWORD;

if (!branch) {
  console.error('BRANCH_NAME environment variable is not set.');
  process.exit(1);
}

if (!password) {
  console.error('USER_PASSWORD environment variable is not set.');
  process.exit(1);
}

const usersToCreate = [
  { email: `nohe+kiosk_${branch}@google.com`, claims: { kiosk: true } },
  { email: `nohe+barista_${branch}@google.com`, claims: { barista: true } },
  { email: `nohe+queue_${branch}@google.com`, claims: { queue: true } },
  { email: `nohe+recent_${branch}@google.com`, claims: { recent: true } },
  { email: `nohe+moderator_${branch}@google.com`, claims: { moderator: true } },
];

async function seedUsers() {
  for (const userData of usersToCreate) {
    try {
      let user;
      try {
        user = await auth.getUserByEmail(userData.email);
        console.log(`User already exists: ${userData.email}`);
      } catch (error) {
        if (error.code === 'auth/user-not-found') {
          console.log(`Creating user: ${userData.email}`);
          user = await auth.createUser({
            email: userData.email,
            password: password,
            emailVerified: true,
          });
        } else {
          throw error;
        }
      }

      const currentClaims = user.customClaims || {};
      const newClaims = userData.claims || {};

      const keys1 = Object.keys(currentClaims);
      const keys2 = Object.keys(newClaims);

      let claimsMatch = keys1.length === keys2.length;
      if (claimsMatch) {
        for (const key of keys1) {
          if (currentClaims[key] !== newClaims[key]) {
            claimsMatch = false;
            break;
          }
        }
      }

      if (!claimsMatch) {
        console.log(`Setting custom claims for ${userData.email}:`, userData.claims);
        await auth.setCustomUserClaims(user.uid, userData.claims);
      } else {
        console.log(`Claims already up to date for ${userData.email}`);
      }
    } catch (error) {
      console.error(`Error processing user ${userData.email}:`, error);
      process.exit(1);
    }
  }
  console.log('User seeding completed successfully.');
}

seedUsers();
