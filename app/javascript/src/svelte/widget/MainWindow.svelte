<svelte:options accessors />

<script>
  import InnerWindow from "./InnerWindow.svelte";
  export let showMain;
  export let windowClasses;

  let windowOrder = windowClasses.includes("bottom") ? "default" : "reverse";
</script>

<div id="swf-main-window" class={windowClasses.join(" ") + " " + showMain}>
  <InnerWindow {showMain}
  windowOrder={windowClasses.includes("bottom") ? "default" : "reverse"}
  spacerOrder={windowClasses.includes("left") ? "spacer-default" : "spacer-reverse"}
  >
    <div slot="header"><slot name="header"></slot></div>
    <div slot="content"><slot name="content"></slot></div>
  </InnerWindow>
</div>

<style>
  .main {
    position: absolute;
    border-bottom-right-radius: 2rem;
    display: flex;
    align-items: flex-end;
    justify-content: flex-end;
    padding: 5px;
    overflow: hidden;
    background-color: white;
    transition: width 0.3s, height 0.3s, border-radius 0.5s;
  }

  .main.left.top {
    border-bottom-right-radius: 0px;
  }
  .main.left.bottom {
    align-items: end;
  }
  .main.left.bottom {
    border-top-right-radius: 0px;
  }
  .main.right.top {
    justify-content: flex-start;
  }
  .main.right.top {
    border-bottom-left-radius: 0px;
  }
  .main.right.bottom {
    align-items: flex-start;
    justify-content: flex-start;
  }
  .main.right.bottom {
    border-top-left-radius: 0px;
  }

  .main.top {
    bottom: 10px;
  }
  .main.bottom {
    top: 10px;
  }
  .main.left {
    right: 10px;
  }
  .main.right {
    left: 10px;
  }

  .content {
    padding: 15px;
  }

  .main.true {
    border-radius: 20px 20px 20px 20px;
    height: 400px;
    width: 82vw;
  }

  @media (min-width: 476px) {
    .main.true {
      height: 400px;
      width: 400px;
    }
  }

  .main.false {
    border-radius: 50%;
    height: 0 !important;
    width: 0 !important;
  }
</style>
