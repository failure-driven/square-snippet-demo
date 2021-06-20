<script>
  import {auth, db} from "../services/firebase";
  import {onDestroy} from "svelte";
  import ChatMessage from "../components/ChatMessage.svelte";
  export let roomId;
  export let leaveRoom;
  let currentUser;
  let messages = [];
  let cooldown = false;
  console.log(roomId);

  auth.onAuthStateChanged(user => (currentUser = user));
  const unsubscribe = db
    .collection("chats")
    .doc(roomId)
    .collection("messages")
    .onSnapshot(
      snapshot => {
        messages = [];
        snapshot.forEach(change => {
          messages = [...messages, change.data()].sort(
            (a, b) => a.createdAt - b.createdAt
          );
          setTimeout(() => {
            if (document.getElementById("scroll-to"))
              document
                .getElementById("scroll-to")
                .scrollIntoView({behavior: "smooth"});
          }, 500);
        });
      },
      error => {
        console.log(error);
      }
    );

  // new
  function messageSubmit(event) {
    if (event.key.toLowerCase() !== "enter") return;
    if (cooldown) return;
    const message = (
      document.getElementById("message-input").value || ""
    ).trim();
    if (!message) return;
    document.getElementById("message-input").value = "";
    cooldown = true;
    setTimeout(() => (cooldown = false), 3000);
    db.collection("chats").doc(roomId).collection("messages").add({
      message,
      email: currentUser.email,
      photoURL: currentUser.photoURL,
      uid: currentUser.uid,
      createdAt: Date.now(),
    });
  }

  let copyBtn;

  async function copyID() {
    navigator.clipboard.writeText(roomId);
    copyBtn.innerHTML = "Copied!";
    await new Promise(r => setTimeout(r, 2000));
    copyBtn.innerHTML = "Copy Room ID";
  }

  onDestroy(unsubscribe);
</script>

<div class="chat-room-wrapper">
  <div class="controls">
    <button class="btn btn-c btn-sm smooth w-50" on:click={leaveRoom}
      >Leave Chat</button
    >
    <button
      bind:this={copyBtn}
      class="btn btn-b btn-sm smooth w-50"
      on:click={copyID}>Copy Room ID</button
    >
  </div>
  <div class="chatRoom">
    {#if messages.length > 0}
      {#each messages as m, i}
        <ChatMessage
          {...m}
          self={currentUser.uid === m.uid}
          neighbouringSelf={messages[i + 1] !== undefined &&
            messages[i + 1].email === m.email}
        />
      {/each}
    {:else}
      <p>Looks like nobody's sent a message. Be the first!</p>
    {/if}
    <!-- Dummy element used to scroll chat -->
    <br id="scroll-to" />
  </div>
  <input
    on:keydown={messageSubmit}
    autocomplete="off"
    type="text"
    style="margin: 0 auto; width: 60%; margin-top: -1px"
    placeholder={cooldown
      ? "3 second cooldown"
      : "Enter message and press enter"}
    class="w3-input w3-border w3-border-gray {cooldown && 'w3-pale-red'}"
    id="message-input"
  />
</div>

<style>
  .chat-room-wrapper {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  .chatRoom {
    overflow-y: auto;
  }

  .controls {
    height: 36px;
    display: flex;
  }

  .btn {
    margin: 0px 10px;
    width: 50%;
  }
</style>
