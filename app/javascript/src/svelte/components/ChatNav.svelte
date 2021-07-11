<script>
  import {faCommentAlt} from "@fortawesome/free-solid-svg-icons/faCommentAlt";
  import {faPhone} from "@fortawesome/free-solid-svg-icons/faPhone";
  import Icon from "./Icon.svelte";
  import Chat from "./Chat.svelte";
  import Call from "./Call.svelte";
  let site, identity;
  let component = window.location.href.split("/").pop();
  console.log(component);
</script>

<nav class="icon-nav {component}">
  <a
    href={`/identities/${identity}/sites/${site}/portal/chat`}
    class:active={component == Chat}
    id="chat"
    alt="Chat"
  >
    <Icon class="dpurple" icon={faCommentAlt} />
  </a>
  <a
    href={`/identities/${identity}/sites/${site}/portal/call`}
    class:active={component == Call}
    alt="Call"
  >
    <Icon class="yellow" icon={faPhone} />
  </a>
</nav>

<style>
  nav {
    display: flex;
    justify-content: space-around;
    padding-bottom: 0.5rem;
    margin-bottom: 1rem;
  }

  .chat {
    border-bottom: 1px solid #6706bc;
  }

  .call {
    border-bottom: 1px solid #fbae17;
  }
</style>
