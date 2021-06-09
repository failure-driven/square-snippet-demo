<script>
  import {auth, db} from "../services/firebase";
  import ChatRoom from "./ChatRoom.svelte";
  let currentUser;
  let roomId = localStorage.getItem("swifChatId");

  auth.onAuthStateChanged(user => (currentUser = user));

  function newChatRoom() {
    db.collection("chats")
      .add({
        createdAt: Date.now(),
        owner: currentUser.uid,
      })
      .then(result => {
        localStorage.setItem("swifChatId", result.id);
        roomId = result.id;
      });
  }

  function joinChatRoom() {
    let id = document.getElementById("chatroom-id").value;
    localStorage.setItem("swifChatId", id);
    roomId = id;
  }

  function leaveRoom() {
    localStorage.removeItem("swifChatId");
    roomId = null;
  }
</script>

{#if typeof currentUser === "undefined"}
  loading ...
{:else if currentUser}
  {#if roomId}
    <ChatRoom {roomId} {leaveRoom} />
  {:else}
    {roomId}
    <button class="btn btn-a btn-sm smooth" on:click={newChatRoom}
      >New chat room</button
    >
    <button class="btn btn-b btn-sm smooth" on:click={joinChatRoom}
      >Join chat room</button
    ><input id="chatroom-id" placeholder="Chatroom ID" />
  {/if}
{:else}
  <p class="w3-center w3-section">Not logged in!</p>
{/if}
