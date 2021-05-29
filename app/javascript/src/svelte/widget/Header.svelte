<script>
  export let showMain;
  export let spacerOrder;
</script>

<div class="bubble-header {showMain} {spacerOrder}">
  <div class="header-wrapper">
    <slot name="header">
    </slot>
  </div>
  <div class="spacer"></div>
</div>

<style>
  .bubble-header {
    align-items: center;
    color: rgb(180, 180, 180);
    display: flex;
    height: 10%;
    margin: 0 10px 0 10px;
    align-items: center;
    transition: width 1.6s;
    margin: 5px 5px;
  }

  .header-wrapper {
    margin-right: auto;
    margin-left: 1rem;
  }

  .spacer {
    width: 40px;
  }

  .spacer-reverse {
    flex-direction: row-reverse;
  }

  .spacer-reverse.header-wrapper {
    margin-left: auto;
    margin-right: 1rem;
  }
</style>