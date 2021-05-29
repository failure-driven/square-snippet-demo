// Firebase App (the core Firebase SDK) is always required and must be listed first
import firebase from "firebase/app";
// If you are using v7 or any earlier version of the JS SDK, you should import firebase using namespace import
// import * as firebase from "firebase/app"

// If you enabled Analytics in your project, add the Firebase SDK for Analytics
import "firebase/analytics";

// Add the Firebase products that you want to use
import "firebase/auth";

// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCze93PK9S93QwrUzcmJxs3OwvJP3yP0js",
  authDomain: "swif-41ad0.firebaseapp.com",
  projectId: "swif-41ad0",
  storageBucket: "swif-41ad0.appspot.com",
  messagingSenderId: "692230613044",
  appId: "1:692230613044:web:57462d91d9dea9d21dc261",
  measurementId: "G-CT2WTQFZKP"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

export default firebase