<script>
  import { firebase, facebookSignUp, logOut } from "../firebase";
  import VisitorCount from "./VisitorCount.svelte";

  let currentUser = null;

  firebase.auth().onAuthStateChanged(function (user) {
    currentUser = user;
  });
</script>

{#if currentUser === null}
  <div>
    <h2>Welcome to Shopping With Friends!</h2>
    <div>To get started please sign in:</div>
    <div>
      <button on:click={facebookSignUp} class="btn-primary">
        Sign in with Facebook
      </button>
    </div>
  </div>
{:else}
  <div class="account-controls">
    {currentUser.displayName}
    <button on:click={logOut} class="btn-danger">Log out</button>
  </div>
  <VisitorCount />
{/if}

<style>
  .account-controls {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
</style>
