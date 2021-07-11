<script>
  import axios from "axios";
  import Story from "./Story.svelte";

  export let site, identity;
  let title = "";
  let videoUrl = "";

  let story = undefined;

  function submit() {
    let authToken = false;
    let cookie = JSON.parse(localStorage.getItem("swifAuth"));
    if (cookie) {
      authToken = cookie.user.authToken;
    }

    if (!authToken) {
      window.location.href = `/identities/${identity}/sites/${site}/portal/account`;
    } else {
      const apiHostUrl = process.env.API_HOST_URL || "http://localhost:3000";
      axios
        .post(
          `${apiHostUrl}/api/v1/sites/stories`,
          {
            domain: window.location.hostname,
            story: {
              title: this.elements["title"].value,
              url: this.elements["videoUrl"].value,
              site_id: site,
            },
          },
          {
            headers: {
              "CONTENT-TYPE": "application/json",
              AUTHORIZATION: `Token ${authToken}`,
            },
          }
        )
        .then(response => {
          story = response.data.story;
        });
    }
  }
</script>

<div class="content-panel">
  {#if story === undefined}
    <h2 class="swif-story-title">New Story</h2>

    <form class="new-story-form" on:submit|preventDefault={submit}>
      <label for="title"> Title </label>
      <input
        required
        id="title"
        minlength={2}
        maxlength={40}
        placeholder="Buying Shoes"
        bind:value={title}
      />
      <label for="videoUrl"> Video url </label>
      <input
        required
        id="videoUrl"
        placeholder="http(s)://something"
        type="url"
        bind:value={videoUrl}
      />
      <button class="new-story-form-submit btn btn-sm swif-yellow"
        >Submit</button
      >
    </form>
  {:else}
    <Story id={story.id} />
  {/if}
</div>

<style>
  button {
    width: 100%;
    margin-top: 1rem !important;
  }

  textarea {
    resize: vertical;
  }

  input {
    border-color: lightgray;
    border-radius: 4px;
    padding: 8px;
  }
  input:not(:placeholder-shown) {
    border-color: red;
  }
  input:valid {
    border-color: lightgray;
  }
  label {
    font-weight: bold;
  }
</style>
