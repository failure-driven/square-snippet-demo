<script>
  import InnerWindow from "./InnerWindow.svelte";
  import {onMount} from "svelte";

  export let showMain;

  let main;
  let resizer;
  let resizing = false;
  let windowClasses = ["top", "left"];

  let windowHeight = 400;
  let windowWidth = window.matchMedia("(min-device-width: 476px)").matches
    ? 400
    : Math.min(window.screen.width, window.innerWidth) * 0.82;

  onMount(async () => {
    resizer.addEventListener("pointerdown", function (e) {
      e.stopPropagation();
      e.preventDefault();
      resizing = true;
    });
  });

  function onPointerMove(e) {
    if (resizing) {
      if (windowClasses.includes("right")) {
        windowWidth += e.movementX;
      } else {
        windowWidth -= e.movementX;
      }
      if (windowClasses.includes("bottom")) {
        windowHeight += e.movementY;
      } else {
        windowHeight -= e.movementY;
      }
    }
  }

  function onPointerUp() {
    resizing = false;
  }

  export function alignWindow() {
    windowClasses = [];
    if (main.getBoundingClientRect().left + 35 < windowWidth) {
      windowClasses.push("right");
    } else {
      windowClasses.push("left");
    }
    if (main.getBoundingClientRect().top + 24 < windowHeight) {
      windowClasses.push("bottom");
    } else {
      windowClasses.push("top");
    }
  }
</script>

<div
  bind:this={main}
  id="swf-main-window"
  class="swif main animated-gradient {windowClasses.join(' ') +
    ' ' +
    showMain +
    ' resizing-' +
    resizing}"
  style="height: {windowHeight}px; width: {windowWidth}px"
>
  <div class="resizer {windowClasses.join(' ')}" bind:this={resizer}>
    <div class="animated-gradient" />
  </div>
  <InnerWindow
    {showMain}
    windowOrder={windowClasses.includes("bottom") ? "default" : "reverse"}
    spacerOrder={windowClasses.includes("left")
      ? "spacer-default"
      : "spacer-reverse"}
  >
    <slot name="header" slot="header" />
    <slot name="content" slot="content" />
  </InnerWindow>
</div>
<svelte:window on:pointerup={onPointerUp} on:pointermove={onPointerMove} />

<style>
  .main {
    position: absolute;
    border-bottom-right-radius: 2rem;
    display: flex;
    align-items: flex-end;
    justify-content: flex-end;
    padding: 5px;
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
  }

  .main.false {
    border-radius: 50%;
    height: 0 !important;
    width: 0 !important;
  }

  .main.resizing-true {
    transition: none !important;
  }

  .resizer {
    position: absolute;
    height: 15px;
    width: 15px;
    top: -3px;
    left: -3px;
    overflow: hidden;
    cursor: nw-resize;
    touch-action: none;
  }

  .resizer.right {
    left: auto;
    right: -3px;
  }

  .resizer.right.top {
    cursor: sw-resize;
  }

  .resizer.bottom.left {
    cursor: sw-resize;
  }

  .resizer.bottom {
    top: auto;
    bottom: -3px;
  }

  .resizer.right div {
    transform: rotate(135deg) translate(-9px);
  }

  .resizer.right.bottom div {
    transform: rotate(225deg) translate(-9px);
  }

  .resizer.left.bottom div {
    transform: rotate(315deg) translate(-9px);
  }

  .resizer div {
    height: 15px;
    width: 15px;
    transform: rotate(45deg) translate(-9px);
  }
</style>
