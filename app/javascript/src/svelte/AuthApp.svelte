<script>
  export let dataset;
  const {user} = dataset;

  function writeAuth() {
    localStorage.setItem("swifAuth", JSON.stringify({user}));
  }
  writeAuth();
  let closing = false;
  setTimeout(() => (closing = true), 3000);
  setTimeout(closeWindow, 4000);
  function closeWindow() {
    window.opener && window.opener && window.opener.location.reload();
    window.close();
  }
</script>

<div>Success</div>
<div><button class="btn btn-primary" on:click={closeWindow}>close</button></div>
<div>
  {#if closing}Closing ...{/if}
</div>

<style>
  div {
    display: flex;
    justify-content: center;
  }
</style>
