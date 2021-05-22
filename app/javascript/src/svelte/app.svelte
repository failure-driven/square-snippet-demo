<script>
  import { quintOut } from "svelte/easing";
  import { fade, draw, fly } from "svelte/transition";
  import { expand } from "./demo/custom-transitions.js";
  import { inner, outer } from "./demo/shape.js";
  import Launcher from "./launcher/Launcher.svelte";

  let visible = false;
  const handleMessage = (event) => {
    visible = event.detail.visible;
  };
</script>

{#if visible}
  <div class="container">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 103 124">
      <g out:fade={{ duration: 200 }} opacity="0.2">
        <path
          in:expand={{ duration: 400, delay: 1000, easing: quintOut }}
          style="stroke: #ff3e00; fill: #ff3e00; stroke-width: 50;"
          d={outer}
        />
        <path
          in:draw={{ duration: 1000 }}
          style="stroke:#ff3e00; stroke-width: 1.5"
          d={inner}
        />
      </g>
    </svg>

    <div class="centered" out:fly={{ y: -20, duration: 800 }}>
      {#each "SVELTE" as char, i}
        <span in:fade={{ delay: 1000 + i * 150, duration: 800 }}>{char}</span>
      {/each}
    </div>
  </div>
{/if}

<Launcher on:message={handleMessage} />

<link
  href="https://fonts.googleapis.com/css?family=Overpass:100,400"
  rel="stylesheet"
/>

<style>
  .container {
    background-color: pink;
    z-index: 2147483600;
    position: fixed;
    bottom: 100px;
    right: 20px;
    height: calc(100% - 120px);
    width: 376px;
    min-height: 250px;
    max-height: 704px;
    box-shadow: rgba(0, 0, 0, 0.16) 0px 5px 40px;
    opacity: 1;
    border-radius: 8px;
    overflow: hidden;
    transition: width 350ms ease 0s, height ease 0s, max-height ease 0s;
  }
  svg {
    width: 100%;
    height: 100%;
  }

  path {
    fill: white;
    opacity: 1;
  }

  .centered {
    font-size: 60px;
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    font-family: "Overpass";
    letter-spacing: 0.12em;
    color: #676778;
    font-weight: 400;
  }

  .centered span {
    will-change: filter;
  }
</style>
