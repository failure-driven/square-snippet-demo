<script>
  import page from "page";
  import Auth from "./components/Auth.svelte";
  import Chat from "./components/Chat.svelte";
  import Call from "./components/Call.svelte";

  export let dataset;
  const {site, identity} = dataset;

  let component;

  page.redirect("/", `/identities/${identity}/sites/${site}/portal/chat`);
  page.redirect(
    `/identities/${identity}/sites/${site}/portal`,
    `/identities/${identity}/sites/${site}/portal/chat`
  );
  page(
    "/identities/:identity/sites/:site/portal/chat",
    () => (component = Chat)
  );
  page(
    "/identities/:identity/sites/:site/portal/call",
    () => (component = Call)
  );
  page.start();
</script>

<Auth />
<nav>
  <a
    href={`/identities/${identity}/sites/${site}/portal/chat`}
    class:active={component == Chat}
  >
    Chat</a
  >
  <a
    href={`/identities/${identity}/sites/${site}/portal/call`}
    class:active={component == Call}
  >
    Call</a
  >
</nav>
<main>
  <svelte:component this={component} />
</main>
