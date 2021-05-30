<script>
  export let dataset;
  const { site, identity } = dataset;
  import Auth from "./components/Auth.svelte";
  import Chat from "./components/Chat.svelte";
</script>

<Auth />
<Chat />
