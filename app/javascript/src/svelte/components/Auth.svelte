<script>
  import {auth, facebookSignUp, facebookLogOut} from "../services/firebase";
  import {createEventDispatcher} from "svelte";

  const dispatch = createEventDispatcher();

  let currentUser = null;
  auth.onAuthStateChanged(function (user) {
    dispatch("auth");
    currentUser = user;
  });
</script>

{#if !currentUser}
  <button on:click={facebookSignUp} class="btn-primary">
    Sign in with Facebook
  </button>
{:else}
  <div>
    {currentUser.displayName}
    <button on:click={facebookLogOut} class="btn-danger">Log out</button>
  </div>
{/if}
