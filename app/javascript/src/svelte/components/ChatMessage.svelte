<script>
  import md5 from "md5";
  // export let photoURL;
  export let createdAt;
  export let email;
  export let message;
  export let uid;
  // if the message was made by the current user
  export let self = false;
  export let neighbouringSelf;
</script>

<div
  title={`${email} (${uid}) at ${new Date(createdAt)}`}
  class="message {self} {email} {neighbouringSelf
    ? 'neighboringSelf'
    : 'endChain'}"
>
  <img
    src={`https://www.gravatar.com/avatar/${md5(email)}?d=mp&s=32&r=g`}
    alt="avatar"
  />
  <span class="msg-body">{message}</span>
</div>

<style>
  .neighboringSelf img {
    opacity: 0;
  }

  .endChain {
    margin-bottom: 20px !important;
  }

  .message {
    margin: 5px;
    display: flex;
    align-items: center;
  }

  .message.true {
    flex-direction: row-reverse;
  }

  .message img {
    position: relative;
    bottom: -10;
    border-radius: 50%;
    padding: 0px 5px;
  }

  .msg-body {
    padding: 10px 15px;
    background-color: #e7e7e7;
    border-radius: 20px;
    font-family: sans-serif;
  }

  .true > .msg-body {
    background-color: #019fc7;
    color: white;
  }
</style>
