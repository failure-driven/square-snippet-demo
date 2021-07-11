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
  <span class="msg-body">{message}</span>
  <img
    src={`https://www.gravatar.com/avatar/${md5(email)}?d=mp&s=32&r=g`}
    alt="avatar"
  />
</div>

<style>
  .neighboringSelf img {
    display: none;
  }

  .message {
    margin: 5px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
  }

  .message.true {
    align-items: flex-end;
  }

  .message img {
    position: relative;
    margin-top: -10;
    margin-right: 5;
    border-radius: 50%;
    padding: 0px 5px;
  }

  .message.true img {
    margin-right: -5;
  }

  .msg-body {
    margin: 0px 10px;
    padding: 10px 15px;
    background-color: #a683f2;
    color: white;
    border-radius: 20px;
    font-family: sans-serif;
    overflow-wrap: anywhere;
  }

  .true > .msg-body {
    background-color: #6706bc;
  }
</style>
