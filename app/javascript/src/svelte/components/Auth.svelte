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
  <button on:click={facebookSignUp} class="btn btn-a btn-sm smooth">
    Sign in with Facebook
  </button>
{:else}
  <div style="display: inline">
    {currentUser.displayName}
    <button on:click={facebookLogOut} class="btn btn-c btn-sm smooth"
      >Log out</button
    >
  </div>
{/if}
