<script>
  import Auth from "./Auth.svelte";
  import {authWidgetUrl} from "../services/siteConfig";

  let auth = JSON.parse(localStorage.getItem("swifAuth"));

  const logout = () => {
    localStorage.setItem("swifAuth", null);
    auth = JSON.parse(localStorage.getItem("swifAuth"));
  };
  const authenticate = () => {
    const windowFeatures =
      "location=yes,resizable=yes,scrollbars=yes,status=yes,width=640,height=480";
    window.open(authWidgetUrl(), "Swif Auth", windowFeatures);
  };

  const refresh = () => {
    location.reload();
  };
</script>

<div>
  {#if auth}
    {auth.user.email}
    <button on:click={logout} class="btn btn-a btn-sm">log out</button>
  {:else}
    <button on:click={authenticate} class="btn btn-a btn-sm">log in</button>
  {/if}
</div>

<div>
  <Auth />
</div>

<div>
  <button on:click={refresh} class="btn btn-a btn-sm">refresh</button>
</div>
