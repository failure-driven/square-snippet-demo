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
  measurementId: "G-CT2WTQFZKP",
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

function facebookSignUp() {
  var provider = new firebase.auth.FacebookAuthProvider();
  firebase
    .auth()
    .signInWithPopup(provider)
    .then((result) => {
      // currentUser = result.user;
      // var credential = result.credential;
      // The signed-in user info.
      // user = result.user;
      // This gives you a Facebook Access Token. You can use it to access the Facebook API.
      // var accessToken = credential.accessToken;
    })
    .catch((error) => {
      // Handle Errors here.
      // var errorCode = error.code;
      // var errorMessage = error.message;
      // The email of the user's account used.
      // var email = error.email;
      // The firebase.auth.AuthCredential type that was used.
      // var credential = error.credential;
    });
}

function logOut() {
  firebase
    .auth()
    .signOut()
    .then(() => {
      // currentUser = null;
    })
    .catch((error) => {
      // An error happened.
    });
}

export { firebase, facebookSignUp, logOut };
