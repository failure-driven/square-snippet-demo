<script>
  import firebase from "../firebase";

  let currentUser;

  firebase.auth().onAuthStateChanged(function(user) {
    currentUser = user.displayName;
  });

  function signUp() {
    var provider = new firebase.auth.FacebookAuthProvider();

    firebase
      .auth()
      .signInWithPopup(provider)
      .then((result) => {
        currentUser = result.user.displayName
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
</script>

<div>Logged in as: {currentUser}</div>
<button on:click={signUp}>Sign in with Facebook</button>
