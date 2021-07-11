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
    <div class="logo">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 164.84 158.8"
        ><g id="Layer_2" data-name="Layer 2"
          ><g id="Layer_1-2" data-name="Layer 1"
            ><path
              d="M62.2,70.35A4.37,4.37,0,0,1,57.83,66V48.29c0-1.68-4.11-4.75-10.84-4.75s-10.84,3.07-10.84,4.75V66a4.37,4.37,0,0,1-8.74,0V48.29C27.41,40.72,36,34.8,47,34.8s19.59,5.92,19.59,13.49V66A4.37,4.37,0,0,1,62.2,70.35Z"
            /><path
              d="M14.63,158.8a55.53,55.53,0,0,1-11.22-1.11,4.38,4.38,0,0,1-.76-8.28c4.44-1.92,9.5-4.79,11.78-8.57H14.1a14,14,0,0,1-14-15.4l5.79-59a9.93,9.93,0,0,1,9.93-9H68.07a4.37,4.37,0,1,1,0,8.74H15.79a1.22,1.22,0,0,0-1.23,1.08l-5.79,59a5.2,5.2,0,0,0,1.34,4,5.31,5.31,0,0,0,4,1.76H20a4.37,4.37,0,0,1,4.37,4.28c.08,3.87-1.19,8.8-6.29,13.6,7.83-.63,16.83-3.81,19.37-14.52a4.36,4.36,0,0,1,4.25-3.36H79.89a5.31,5.31,0,0,0,4-1.75,4.37,4.37,0,0,1,6.46,5.9,14.16,14.16,0,0,1-10.43,4.59H45c-3.52,9.79-11.56,15.82-23.46,17.5A50.75,50.75,0,0,1,14.63,158.8Z"
            /><path
              d="M133.06,54.72a4.38,4.38,0,0,1-4.38-4.37V32.65c0-1.67-4.11-4.75-10.83-4.75S107,31,107,32.65v17.7a4.38,4.38,0,0,1-8.75,0V32.65c0-7.56,8.6-13.49,19.59-13.49s19.58,5.93,19.58,13.49v17.7A4.37,4.37,0,0,1,133.06,54.72Z"
            /><path
              d="M150.21,143.17a49.26,49.26,0,0,1-6.89-.47c-11.9-1.68-19.94-7.7-23.46-17.49H85a14.07,14.07,0,0,1-14-15.41l5.79-59a9.93,9.93,0,0,1,9.93-9h62.41a9.92,9.92,0,0,1,9.92,9l5.8,59a14.07,14.07,0,0,1-14,15.41h-.33c2.27,3.77,7.33,6.64,11.78,8.56a4.37,4.37,0,0,1-.76,8.28A55.1,55.1,0,0,1,150.21,143.17ZM86.64,50.54a1.2,1.2,0,0,0-1.22,1.08l-5.8,59h0a5.18,5.18,0,0,0,1.34,4,5.31,5.31,0,0,0,4,1.76h38.17a4.38,4.38,0,0,1,4.25,3.37c2.54,10.7,11.53,13.88,19.36,14.51-5.09-4.79-6.36-9.73-6.29-13.59a4.38,4.38,0,0,1,4.37-4.29h5.93a5.31,5.31,0,0,0,4-1.76,5.18,5.18,0,0,0,1.34-4l-5.8-59a1.2,1.2,0,0,0-1.22-1.08ZM75.27,110.23h0Z"
            /><path
              d="M67.07,32.13a3.3,3.3,0,0,1-3-.7l-13.83-12a3.3,3.3,0,1,1,4.33-5l13.84,12a3.3,3.3,0,0,1,.32,4.66A3.22,3.22,0,0,1,67.07,32.13Z"
            /><path
              d="M76.87,24.22a3.3,3.3,0,0,1-4-2.34L68.07,4.16a3.31,3.31,0,0,1,2.33-4h0a3.3,3.3,0,0,1,4,2.34l4.77,17.72a3.3,3.3,0,0,1-2.34,4Z"
            /><path
              d="M89.21,26.29a3.24,3.24,0,0,1-2.12-.15,3.29,3.29,0,0,1-1.76-4.32L92.46,4.91a3.3,3.3,0,0,1,6.08,2.56L91.41,24.38A3.27,3.27,0,0,1,89.21,26.29Z"
            /></g
          ></g
        ></svg
      >
    </div>
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

  svg {
    width: 35px;
    fill: white;
  }
</style>
