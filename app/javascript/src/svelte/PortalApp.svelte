<script>
  import page from "page";
  import Chat from "./components/Chat.svelte";
  import Call from "./components/Call.svelte";
  import Stories from "./components/Stories.svelte";
  import Story from "./components/Story.svelte";
  import NewStory from "./components/NewStory.svelte";
  import Money from "./components/Money.svelte";
  import Account from "./components/Account.svelte";
  import {portalUrl} from "./services/siteConfig";
  import * as zoid from "zoid";
  import Icon from "./components/Icon.svelte";
  import {faHome} from "@fortawesome/free-solid-svg-icons/faHome";
  import {faCommentAlt} from "@fortawesome/free-solid-svg-icons/faCommentAlt";
  import {faPlusSquare} from "@fortawesome/free-solid-svg-icons/faPlusSquare";
  import {faCommentsDollar} from "@fortawesome/free-solid-svg-icons/faCommentsDollar";
  import {faUser} from "@fortawesome/free-solid-svg-icons/faUser";

  export let dataset;
  const {site, identity, config} = dataset;

  let component;
  let props = {};

  page.redirect("/", `/identities/${identity}/sites/${site}/portal/stories`);
  page.redirect(
    `/identities/${identity}/sites/${site}/portal`,
    `/identities/${identity}/sites/${site}/portal/stories`
  );
  page(
    "/identities/:identity/sites/:site/portal/chat",
    () => (component = Chat)
  );
  page(
    "/identities/:identity/sites/:site/portal/call",
    () => (component = Call)
  );
  page("/identities/:identity/sites/:site/portal/stories", context => {
    component = Stories;
    const {params, query} = context;
    props = {...params, ...query};
  });
  page("/identities/:identity/sites/:site/portal/stories/:id", context => {
    component = Story;
    const {params, query} = context;
    props = {...params, ...query};
  });
  page("/identities/:identity/sites/:site/portal/new_story", context => {
    component = NewStory;
    const {params, query} = context;
    props = {...params, ...query};
  });
  page("/identities/:identity/sites/:site/portal/money", context => {
    component = Money;
    const {params, query} = context;
    props = {...params, ...query};
  });
  page("/identities/:identity/sites/:site/portal/account", context => {
    component = Account;
    const {params, query} = context;
    props = {...params, ...query};
  });
  page.start();

  zoid.create({
    tag: "swif-frame",
    url: portalUrl({site, identity}),
  });
</script>

<svelte:head>
  <link rel="stylesheet" href="/min.css" />
</svelte:head>

<div class="swif">
  <nav class="{config.zoid_portal ? 'zoid' : ''} swif-dpurple">
    <div class="logo">SWIF LOGO</div>
    <div class="navlinks">
      <a
        href={`/identities/${identity}/sites/${site}/portal/`}
        class="swif-stories-link"
        class:active={component == Stories}
      >
        <Icon class="myClass1 myClass2 navIcon" icon={faHome} />
      </a>
      {#if config}
        <a
          href={`/identities/${identity}/sites/${site}/portal/chat`}
          class:active={component == Chat}
          alt="Chat"
        >
          <Icon class="myClass1 myClass2 navIcon" icon={faCommentAlt} />
        </a>
      {/if}
      <a
        href={`/identities/${identity}/sites/${site}/portal/new_story`}
        class:active={component == Stories}
        class="new-story-link"
        alt="New Story"
      >
        <Icon class="myClass1 myClass2 navIcon" icon={faPlusSquare} />
      </a>
      {#if config && config.in_dev}
        <a
          href={`/identities/${identity}/sites/${site}/portal/money`}
          class:active={component == Money}
          alt="Negotiate payment"
        >
          <Icon class="myClass1 myClass2 navIcon" icon={faCommentsDollar} />
        </a>
      {/if}
      <a
        href={`/identities/${identity}/sites/${site}/portal/account`}
        class:active={component == Account}
      >
        <Icon class="myClass1 myClass2 navIcon" icon={faUser} />
      </a>
    </div>
  </nav>
  <main>
    <svelte:component this={component} {...props} />
  </main>
</div>

<style>
  .swif {
    height: 100%;
    background-color: #dfe0d9 !important;
  }

  :global(.swif-lpurple) {
    background-color: #a683f2 !important;
  }

  :global(.swif-dpurple) {
    background-color: #6706bc !important;
  }

  :global(.swif-yellow) {
    background-color: #fbae17 !important;
  }

  :global(.swif-lighbg) {
    background-color: #d2d3cc !important;
  }

  :global(.content-panel) {
    padding: 1rem 2rem !important;
    display: flex;
    flex-direction: column;
  }

  :global(h1, h2, h3) {
    text-align: center;
    color: #6706bc !important;
  }

  :global(input, textarea) {
    width: 100% !important;
    background-color: white !important;
    border-radius: 5px !important;
    border: none !important;
  }

  :global(*) {
    font-family: sans-serif;
  }

  nav {
    align-items: center;
    height: 40px;
    display: flex;
    padding: 5px 15px;
  }

  .logo {
    margin-right: auto;
  }

  .navlinks {
    display: flex;
    justify-self: flex-end;
  }

  .navlinks a {
    margin: 0 20px;
  }

  main {
    height: 90%;
  }
  div :global(.myClass1) {
    color: #212121;
  }

  div :global(.myClass2) {
    font-size: 20px;
    width: 20px;
  }
</style>
