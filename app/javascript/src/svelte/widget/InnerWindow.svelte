<script>
  import Header from "./Header.svelte";
  import WindowContent from "./WindowContent.svelte";
  export let windowOrder = "";
  export let spacerOrder = "";
  export let showMain;
</script>

<div class="inner {showMain} {windowOrder}">
  <Header {spacerOrder}>
    <slot name="header" />
  </Header>
  <WindowContent>
    <slot name="content" />
  </WindowContent>
</div>

<style>
  .inner {
    display: flex;
    flex-direction: column;
    overflow: hidden;
    border-radius: 10px;
    background-color: white;
    transition: width 0.3s, height 0.3s, border-radius 0.5s;
  }
  .inner.false {
    border-radius: 50% 50% 50% 50%;
    width: 0px;
    height: 0px;
  }
  .inner.true {
    border-radius: 10px;
    width: 100%;
    height: 100%;
  }
  .reverse {
    flex-direction: column-reverse;
  }
</style>
