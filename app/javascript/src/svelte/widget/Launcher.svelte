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
  class="swif launcher swif-purple-gradient {showMain} moving-{moving}"
  on:click={handleClick}
>
  {moving ? "✢" : "SWiF"}
</button>

<style>
  .launcher {
    padding: 0;
    z-index: 1090;
    position: absolute;
    width: 4rem;
    height: 4rem;
    border: none;
    border-radius: 50%;
    transition: height 0.15s, width 0.15s;
    color: white;
    font-weight: 800;
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.425);
  }

  @media (hover: hover) and (pointer: fine) {
    .launcher:hover {
      width: 150%;
      height: 150%;
    }
  }

  .moving-true {
    cursor: move;
  }
</style>
