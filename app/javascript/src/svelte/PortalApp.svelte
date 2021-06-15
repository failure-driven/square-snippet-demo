<script>
  import page from "page";
  import Auth from "./components/Auth.svelte";
  import Chat from "./components/Chat.svelte";
  import Call from "./components/Call.svelte";
  import Stories from "./components/Stories.svelte";
  import Story from "./components/Story.svelte";

  export let dataset;
  const {site, identity} = dataset;

  let component;
  let props = {};

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
  page(
    "/identities/:identity/sites/:site/portal/stories",
    () => (component = Stories)
  );
  page("/identities/:identity/sites/:site/portal/stories/:id", context => {
    component = Story;
    const {params, query} = context;
    props = {...params, ...query};
  });
  page.start();
</script>

<svelte:head>
  <link rel="stylesheet" href="/min.css" />
</svelte:head>

<div class="swif">
  <nav>
    <Auth />
    <div style="display:inline">
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
      <a
        href={`/identities/${identity}/sites/${site}/portal/stories`}
        class="swif-stories-link"
        class:active={component == Stories}
      >
        Stories</a
      >
    </div>
  </nav>
  <main>
    <svelte:component this={component} {...props} />
  </main>
</div>

<style>
  .swif {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  nav {
    height: 10%;
  }

  main {
    height: 90%;
  }
</style>
