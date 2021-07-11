<script>
  import {auth, db} from "../services/firebase";
  import ChatRoom from "./ChatRoom.svelte";
  import ChatNav from "./ChatNav.svelte";
  import {onMount} from "svelte";

  let currentUser;
  let roomId = localStorage.getItem("swifChatId");
  let site, identity;
  let xprops;
  let domain;

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

  onMount(async () => {
    xprops = window.xprops;
    if (xprops !== undefined) {
      domain = xprops.hostname;
    }
  });
</script>

<div class="chat">
  <ChatNav {site} {identity} />

  {#if typeof currentUser === "undefined"}
    loading ...
  {:else if currentUser}
    {#if roomId}
      <ChatRoom {roomId} {leaveRoom} />
    {:else}
      <div class="chat-controls">
        <button class="btn btn-a btn-sm smooth" on:click={newChatRoom}
          >Create a new private chat room</button
        >
        <div class="join-chat">
          <input id="chatroom-id" placeholder="Chatroom ID" />
          <button class="btn btn-b btn-sm smooth" on:click={joinChatRoom}
            >Join chat room</button
          >
        </div>

        <button class="btn btn-sm smooth" on:click={newChatRoom}
          >Join {domain || ""} global chat</button
        >
      </div>
    {/if}
  {:else}
    <p class="w3-center w3-section">Not logged in!</p>
  {/if}
</div>

<style>
  #chatroom-id {
    border-top-left-radius: 5px;
    border-bottom-left-radius: 5px;
    width: 50%;
  }
  .join-chat {
    width: 100%;
    display: flex;
    margin-bottom: 1rem;
  }
  .join-chat .btn {
    border-top-left-radius: 0px;
    border-bottom-left-radius: 0px;
    margin: 0 !important;
    width: 50%;
  }
  .chat-controls {
    margin: 1rem 0;
    display: flex;
    flex-direction: column;
  }
  .chat-controls .btn {
    margin-bottom: 1rem;
    align-items: flex-end;
  }

  .chat {
    margin: 1rem;
  }
</style>
