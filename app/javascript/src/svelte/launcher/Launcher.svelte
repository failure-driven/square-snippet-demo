<script>
  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();
  let visible = false;
  let toggleVisible = () => {
    visible = !visible;
    dispatch("message", { visible: visible });
  };
</script>

<div on:click={toggleVisible}><span>show</span></div>

<style>
  div {
    z-index: 2147483600; /* z-index: 2147483647; MAX*/
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: rgb(48, 71, 236);
    box-shadow: rgb(0 0 0 / 6%) 0px 1px 6px 0px,
      rgb(0 0 0 / 16%) 0px 2px 32px 0px;
  }
  span {
    display: block;
    margin-top: 15px;
    padding-left: 9px;
    color: white;
    font-size: 22px;
  }
</style>
