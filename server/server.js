const dotenv = require("dotenv");
dotenv.config();

const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

const recipientFCMToken = process.env.recipientFCMTokenWei;

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://app-dev-ee700.firebaseio.com",
});

const db = admin.firestore();

// Define an array of Firestore collection names to track
const collectionsToTrack = ["serviceRecords"];

// Function to set up listeners for collections
function setupCollectionListeners() {
  collectionsToTrack.forEach((collectionName) => {
    const collectionRef = db.collection(collectionName);

    // Listen for changes in the collection
    collectionRef.onSnapshot((snapshot) => {
      snapshot.docChanges().forEach((change) => {
        const documentData = change.doc.data();
        console.log(documentData);

        // Send an FCM notification to your Flutter app
        sendNotification(documentData, recipientFCMToken);
      });
    });
  });
}

// Start tracking collections
setupCollectionListeners();

function sendNotification(recordChanged, token) {
  const message = {
    token: token,
    notification: {
      title: "Data Changed",
      body: "Data in the Firestore collection has been updated.",
    },
    // topic: "serviceRecords",
    data: {
      // You can include custom data in the notification
      uid: recordChanged.uid,
      rid: recordChanged.rid,
      timeStamp: Date.now().toString(),
    },
  };

  // Send the message
  admin
    .messaging()
    .send(message)
    .then((response) => {
      console.log("Notification sent:", response);
    })
    .catch((error) => {
      console.error("Error sending notification:", error);
    });
}
