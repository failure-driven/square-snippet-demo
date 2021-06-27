<script>
  import page from "page";
  import Auth from "./components/Auth.svelte";
  import Chat from "./components/Chat.svelte";
  import Call from "./components/Call.svelte";
  import Stories from "./components/Stories.svelte";
  import Story from "./components/Story.svelte";
  import NewStory from "./components/NewStory.svelte";
  import {portalUrl} from "./services/siteConfig";
  import * as zoid from "zoid";
  import Icon from "./components/Icon.svelte";
  import {faHome} from "@fortawesome/free-solid-svg-icons/faHome";
  import {faCommentAlt} from "@fortawesome/free-solid-svg-icons/faCommentAlt";
  import {faPhone} from "@fortawesome/free-solid-svg-icons/faPhone";
  import {faPlusSquare} from "@fortawesome/free-solid-svg-icons/faPlusSquare";
  import {faCommentsDollar} from "@fortawesome/free-solid-svg-icons/faCommentsDollar";
  import {faUser} from "@fortawesome/free-solid-svg-icons/faUser";

  export let dataset;
  const {site, identity} = dataset;

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
        class:active={component == Stories}
      >
        Stories</a
      >
    </div>
  </nav>
  <main>
    <svelte:component this={component} {...props} />
  </main>
  <nav class="icon-nav">
    <div style="display:flex;justify-content: space-between;">
      <a
        href={`/identities/${identity}/sites/${site}/portal/`}
        class="swif-stories-link"
        class:active={component == Stories}
      >
        <Icon class="myClass1 myClass2" icon={faHome} />
      </a>
      <a
        href={`/identities/${identity}/sites/${site}/portal/chat`}
        class:active={component == Chat}
        alt="Chat"
      >
        <Icon class="myClass1 myClass2" icon={faCommentAlt} />
      </a>
      <a
        href={`/identities/${identity}/sites/${site}/portal/call`}
        class:active={component == Call}
        alt="Call"
        style="display:none;"
      >
        <Icon class="myClass1 myClass2" icon={faPhone} />
      </a>
      <a
        href={`/identities/${identity}/sites/${site}/portal/new_story`}
        class:active={component == Stories}
        alt="New Story"
      >
        <Icon class="myClass1 myClass2" icon={faPlusSquare} />
      </a>
      <Icon class="myClass1 myClass2" icon={faCommentsDollar} />
      <a
        href={`/identities/${identity}/sites/${site}/portal/stories`}
        class:active={component == Stories}
      >
        <Icon class="myClass1 myClass2" icon={faUser} />
      </a>
    </div>
  </nav>
</div>

<style>
  .swif {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  nav {
    min-height: 25px;
  }

  main {
    height: 90%;
  }
  .icon-nav {
    background-color: #eeeeee;
    padding-top: 5px;
  }
  div :global(.myClass1) {
    color: #8c8c8c;
  }

  div :global(.myClass2) {
    font-size: 20px;
    width: 20px;
  }
</style>
