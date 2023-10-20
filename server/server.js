const dotenv = require("dotenv");
const cors = require("cors");
const express = require("express");
dotenv.config();

const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

const app = express();
app.use(cors());

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

        //Save notification to firestore
        db.collection("notifications")
          .add({
            uid: documentData.uid,
            pid: documentData.pid,
            rid: documentData.rid,
            timeStamp: Date.now(),
          })
          .then((docRef) => {
            console.log("Document written with ID: ", docRef.id);
          })
          .catch((error) => {
            console.error("Error adding document: ", error);
          });

        // Send an FCM notification to your Flutter app
        sendNotification(documentData);
      });
    });
  });
}

// Start tracking collections
setupCollectionListeners();

function sendNotification(recordChanged) {
  // Get tokens from Firestore
  db.collection("users")
    .doc(recordChanged.uid)
    .get()
    .then((doc) => {
      if (doc.exists) {
        console.log("Document data:", doc.data());

        sendNotificationToToken(doc.data().fcmToken, recordChanged);
      } else {
        // doc.data() will be undefined in this case
        console.log("No such document!");
        // return [];
      }
    })
    .catch((error) => {
      console.log("Error getting document:", error);
      // return [];
    });

  const providerToken = db
    .collection("providers")
    .doc(recordChanged.pid)
    .get()
    .then((doc) => {
      if (doc.exists) {
        console.log("Document data:", doc.data());
        sendNotificationToToken(doc.data().fcmToken, recordChanged);
        // return doc.data().fcmToken;
      } else {
        // doc.data() will be undefined in this case
        console.log("No such document!");
        // return [];
      }
    })
    .catch((error) => {
      console.log("Error getting document:", error);
      // return [];
    });
}
function sendNotificationToToken(token, recordChanged) {
  const message = {
    token: token,
    // topic: "ServiceRecords",
    notification: {
      title: "Data Changed",
      body: "Data in the Firestore collection has been updated.",
    },
    // data: {
    //   // You can include custom data in the notification
    //   uid: recordChanged.uid,
    //   pid: recordChanged.pid,
    //   rid: recordChanged.rid,
    //   timeStamp: Date.now().toString(),
    // },
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
