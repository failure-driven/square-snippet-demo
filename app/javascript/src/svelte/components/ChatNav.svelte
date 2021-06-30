<script>
  import {faCommentAlt} from "@fortawesome/free-solid-svg-icons/faCommentAlt";
  import {faPhone} from "@fortawesome/free-solid-svg-icons/faPhone";
  import Icon from "./Icon.svelte";
  import Chat from "./Chat.svelte";
  import Call from "./Call.svelte";
  let site, identity;
  let component;
</script>

<nav class="icon-nav">
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
  >
    <Icon class="myClass1 myClass2" icon={faPhone} />
  </a>
</nav>

<style>
  nav {
    display: flex;
    justify-content: space-around;
  }
</style>
