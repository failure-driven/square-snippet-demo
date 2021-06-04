import firebase from "firebase/app";
import "firebase/auth";
import "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyCze93PK9S93QwrUzcmJxs3OwvJP3yP0js",
  authDomain: "swif-41ad0.firebaseapp.com",
  projectId: "swif-41ad0",
  storageBucket: "swif-41ad0.appspot.com",
  messagingSenderId: "692230613044",
  appId: "1:692230613044:web:57462d91d9dea9d21dc261",
  measurementId: "G-CT2WTQFZKP",
};

firebase.initializeApp(firebaseConfig);

// auth
export const auth = firebase.auth();

// export const googleAuth = new firebase.auth.GoogleAuthProvider();
export const facebookSignUp = () => {
  var provider = new firebase.auth.FacebookAuthProvider();
  firebase
    .auth()
    .signInWithPopup(provider)
    .then(() => {
      // currentUser = result.user;
      // var credential = result.credential;
      // The signed-in user info.
      // user = result.user;
      // This gives you a Facebook Access Token. You can use it to access the Facebook API.
      // var accessToken = credential.accessToken;
    })
    .catch(() => {
      // Handle Errors here.
      // var errorCode = error.code;
      // var errorMessage = error.message;
      // The email of the user's account used.
      // var email = error.email;
      // The firebase.auth.AuthCredential type that was used.
      // var credential = error.credential;
    });
};

export const facebookLogOut = () => {
  firebase
    .auth()
    .signOut()
    .then(() => {
      // currentUser = null;
    })
    .catch(() => {
      // An error happened.
    });
};

// firestore
export const db = firebase.firestore();
