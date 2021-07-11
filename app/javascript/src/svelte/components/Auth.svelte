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
  <button on:click={facebookSignUp} class="btn btn-a btn-sm smooth swif-yellow">
    Sign in with Facebook
  </button>
{:else}
  <div style="display: inline">
    <button
      on:click={facebookLogOut}
      class="btn btn-c btn-sm smooth swif-yellow">Log out</button
    >
  </div>
{/if}

<style>
  .btn {
    padding: 7px !important;
    width: 100%;
  }
</style>
