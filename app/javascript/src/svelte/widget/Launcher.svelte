<script>
  import {createEventDispatcher} from "svelte";

  export let moving;
  export let showMain;
  const dispatch = createEventDispatcher();

  function handleClick() {
    dispatch("toggleMain");
  }
</script>

<button
  class="swif launcher animated-gradient {showMain} moving-{moving}"
  on:click={handleClick}
>
  SWiF
</button>

<style>
  .launcher {
    padding: 0;
    z-index: 1090;
    position: absolute;
    width: 3.2rem;
    height: 3.2rem;
    border: none;
    border-radius: 50%;
    transition: height 0.15s, width 0.15s;
    color: white;
    font-weight: 800;
  }

  .launcher:hover {
    width: 125%;
    height: 125%;
  }

  .moving-true {
    cursor: move;
  }
</style>
