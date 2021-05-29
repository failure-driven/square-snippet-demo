<script>
import MessageInput from "./MessageInput.svelte";

</script>
<div class="content">
  <slot name="content">
  </slot>
</div>

<style>
  .content {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 90%;
    margin: 10px;
  }
</style>