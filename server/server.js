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
            title: getTitle(documentData),
            message: getMessage(documentData),
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

function getMessage(documentData) {
  switch (documentData.status) {
    case "cancelled":
      return "Your appointment has been cancelled";
    case "rejected":
      return "Your appointment has been rejected";
    case "confirmed":
      return "Your appointment has been confirmed";
    case "started":
      return "Your appointment has been started";
    case "completed":
      return "Your appointment has been completed";
    case "reviewed":
      return "Your appointment has been reviewed";
    default:
      return "New appointment has been created"; //pending
  }
}

function getTitle(documentData) {
  switch (documentData.status) {
    case "cancelled":
      return "Service Cancelled";
    case "rejected":
      return "Service Rejected";
    case "confirmed":
      return "Service Confirmed";
    case "started":
      return "Service Started";
    case "completed":
      return "Service Completed";
    case "reviewed":
      return "Service Reviewed";
    default:
      return "New Appointment"; //pending
  }
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
      title: "Home Servies",
      body: "Your home service status has been updated.",
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
