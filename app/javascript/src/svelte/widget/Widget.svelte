<script>
  import Launcher from "./Launcher.svelte";
  import MainWindow from "./MainWindow.svelte";
  import {onMount} from "svelte";

  let showMain = false;
  let mainWindow;

  function toggleMain() {
    showMain = !showMain;
  }

  export let right = window.innerWidth - 80;
  export let bottom = window.innerHeight - 80;

  let cachedWindowheight = window.innerHeight;

  let moving = false;
  let hasMoved = false;
  let mouseIsDown = false;
  let idTimeout;

  onMount(async () => {
    window.addEventListener("resize", function () {
      if (right > window.innerWidth - 60) {
        right += right - window.innerWidth;
      }
      if (cachedWindowheight !== window.innerHeight) {
        cachedWindowheight = window.innerHeight;
        bottom = window.innerHeight - 80;
      }
    });

    main.addEventListener("pointerdown", function (e) {
      mouseIsDown = true;
      idTimeout = setTimeout(function () {
        if (mouseIsDown) {
          e.preventDefault();
          showMain = false;
          main.classList.add("moving");
          moving = true;
        }
      }, 300);
    });
  });

  function onPointerMove(e) {
    if (moving) {
      right += e.movementX;
      bottom += e.movementY;
      hasMoved = true;
    }
  }

  function onPointerUp() {
    main.classList.remove("moving");
    moving = false;
    clearTimeout(idTimeout);
    mouseIsDown = false;
    if (hasMoved) {
      mainWindow.alignWindow();
      hasMoved = false;
    }
  }

  let main;
</script>

<div
  class="draggable center"
  style="left: {right}px; top: {bottom}px;"
  bind:this={main}
>
  <Launcher {showMain} on:toggleMain={toggleMain} bind:moving />
  <MainWindow {showMain} bind:this={mainWindow}>
    <div slot="header"><slot name="header" /></div>
    <div slot="content"><slot name="content" /></div>
  </MainWindow>
</div>
<svelte:window on:pointerup={onPointerUp} on:pointermove={onPointerMove} />

<style>
  .draggable {
    z-index: 1080;
    position: fixed;
    width: 3rem;
    height: 3rem;
    border: none;
    border-radius: 50%;
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
  }

  .center {
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
