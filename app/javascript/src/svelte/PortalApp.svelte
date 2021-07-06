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
  <main>
    <svelte:component this={component} {...props} />
  </main>
  <nav class="icon-nav">
    <a
      href={`/identities/${identity}/sites/${site}/portal/`}
      class="swif-stories-link"
      class:active={component == Stories}
    >
      <Icon class="myClass1 myClass2 navIcon" icon={faHome} />
    </a>
    {#if config && config.in_dev}
      <a
        href={`/identities/${identity}/sites/${site}/portal/chat`}
        class:active={component == Chat}
        alt="Chat"
      >
        <Icon class="myClass1 myClass2 navIcon" icon={faCommentAlt} />
      </a>
    {:else}
      &nbsp;
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
    {:else}
      &nbsp;
    {/if}
    <a
      href={`/identities/${identity}/sites/${site}/portal/account`}
      class:active={component == Account}
    >
      <Icon class="myClass1 myClass2 navIcon" icon={faUser} />
    </a>
  </nav>
</div>

<style>
  .swif {
    height: 100%;
  }

  nav {
    height: 28px;
    bottom: 10;
    left: 0;
    width: 100%;
    position: fixed;
    background-color: rgba(0, 0, 0, 0.8);
    display: flex;
    justify-content: space-evenly;
  }

  main {
    height: 100%;
  }
  .icon-nav {
    /* background-color: #eeeeee; */
    padding-top: 5px;
  }
  div :global(.myClass1) {
    color: #212121;
  }

  div :global(.myClass2) {
    font-size: 20px;
    width: 20px;
  }
</style>
