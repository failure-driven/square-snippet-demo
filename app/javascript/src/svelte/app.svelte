<script>
  export let name;

  let count = 0;

  function handleClick() {
    count += 1;
  }

  import { quintOut } from "svelte/easing";
  import { fade, draw, fly } from "svelte/transition";
  import { expand } from "./demo/custom-transitions.js";
  import { inner, outer } from "./demo/shape.js";

  let visible = false;
  let toggleVisible = () => {
    visible = !visible;
  };
</script>

<div class="container">
  {#if visible}
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

    <h1>Hello {name}!</h1>

    <button on:click={handleClick}>
      Clicked {count}
      {count === 1 ? "time" : "times"}
    </button>
  {/if}
</div>

<div on:click={toggleVisible}>show</div>

<link
  href="https://fonts.googleapis.com/css?family=Overpass:100,400"
  rel="stylesheet"
/>

<style>
  h1 {
    color: #ff3e00;
  }

  .container {
    width: 300px;
    height: 200px;
    position: relative;
  }
  svg {
    width: 100%;
    height: 100%;
  }

  path {
    fill: white;
    opacity: 1;
  }

  label {
    top: 1em;
    left: 1em;
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
