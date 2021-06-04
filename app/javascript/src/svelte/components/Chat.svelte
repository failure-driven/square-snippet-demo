<script>
  import {auth, db} from "../services/firebase";
  import {onDestroy} from "svelte";
  import ChatMessage from "../components/ChatMessage.svelte";
  let currentUser;
  let messages = [];
  let cooldown = false;

  auth.onAuthStateChanged(user => (currentUser = user));

  const unsubscribe = db.collection("messages").onSnapshot(snapshot => {
    snapshot.docChanges().forEach(change => {
      if (change.type === "added") {
        messages = [...messages, change.doc.data()];
        setTimeout(() => {
          if (document.getElementById("scroll-to"))
            document
              .getElementById("scroll-to")
              .scrollIntoView({behavior: "smooth"});
        }, 500);
      }
    });
  });

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
    db.collection("messages").add({
      message,
      email: currentUser.email,
      photoURL: currentUser.photoURL,
      uid: currentUser.uid,
      createdAt: Date.now(),
    });
  }
  onDestroy(unsubscribe);
</script>

{#if typeof currentUser === "undefined"}
  loading ...
{:else if currentUser}
  <p>Chatroom</p>
  <br />
  <div style="margin: 0 auto; width: 100vw; height: 50vh; overflow-y: auto;">
    <br />
    {#if messages.length > 0}
      {#each messages as m}
        <ChatMessage {...m} self={currentUser.uid === m.uid} />
      {/each}
    {:else}
      <p>Looks like nobody's sent a message. Be the first!</p>
    {/if}
    <!-- Dummy element used to scroll chat -->
    <br id="scroll-to" />
  </div>
  <input
    on:keydown={messageSubmit}
    type="text"
    style="margin: 0 auto; width: 60%; margin-top: -1px"
    placeholder={cooldown
      ? "3 second cooldown"
      : "Enter message and press enter"}
    class="w3-input w3-border w3-border-gray {cooldown && 'w3-pale-red'}"
    id="message-input"
  />
  <br />
{:else}
  <p class="w3-center w3-section">Not logged in!</p>
{/if}
