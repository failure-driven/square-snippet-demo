<script>
  import Launcher from "./Launcher.svelte";
  import MainWindow from "./MainWindow.svelte";
	import { onMount } from 'svelte';

  let showMain = false;

  function toggleMain() {
    showMain = !showMain;
  }

  export let right = window.innerWidth - 80;
  export let bottom = window.innerHeight - 80;

  let moving = false;

  let mouseIsDown = false;
  let idTimeout;

  onMount(async () => {
    main.addEventListener("mousedown", function (e) {
      mouseIsDown = true;
      idTimeout = setTimeout(function () {
        if (mouseIsDown) {
          e.preventDefault();
          showMain = false;
          main.classList.add("moving");
          moving = true;
        }
      }, 500);
    });
  });

  function onMouseMove(e) {
    if (moving) {
      right += e.movementX;
      bottom += e.movementY;
    }
  }

  function onMouseUp() {
    main.classList.remove("moving");
    moving = false;
    clearTimeout(idTimeout);
    mouseIsDown = false;
    alignWindow();
  }

  let height = 400;
  let width = 400;

  let main;
  let windowClasses = ["main", "animated-gradient", "top", "left"];

  function alignWindow() {
    windowClasses = ["main", "animated-gradient"];
    if (main.getBoundingClientRect().left + 24 < width) {
      windowClasses.push("right");
    } else {
      windowClasses.push("left");
    }
    if (main.getBoundingClientRect().top + 24 < height) {
      windowClasses.push("bottom");
    } else {
      windowClasses.push("top");
    }
  }
</script>

<div
  class="draggable center"
  style="left: {right}px; top: {bottom}px;"
  bind:this={main}
>
  <Launcher {showMain} on:toggleMain={toggleMain} bind:moving/>
  <MainWindow {showMain} bind:windowClasses>
    <div slot="header"><slot name="header"></slot></div>
    <div slot="content"><slot name="content"></slot></div>
  </MainWindow>
</div>
<svelte:window on:mouseup={onMouseUp} on:mousemove={onMouseMove} />

<style>
  .draggable {
    z-index: 1080;
    position: fixed;
    width: 3rem;
    height: 3rem;
    border: none;
    border-radius: 50%;
  }

  .center {
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
