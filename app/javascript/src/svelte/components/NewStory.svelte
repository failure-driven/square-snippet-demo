<script>
  import axios from "axios";
  import Story from "./Story.svelte";

  export let site;
  let title = "";
  let description = "";
  let videoUrl = "";

  let story = undefined;

  function submit() {
    const authToken = JSON.parse(localStorage.getItem("swifAuth")).user
      .authToken;

    const apiHostUrl = process.env.API_HOST_URL || "http://localhost:3000";
    axios
      .post(
        `${apiHostUrl}/api/v1/sites/stories`,
        {
          domain: window.location.hostname,
          story: {
            title: this.elements["title"].value,
            description: this.elements["description"].value,
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
</script>

<div>
  {#if story === undefined}
    <h2 class="swif-story-title">New Story</h2>

    <form class="new-story-form" on:submit|preventDefault={submit}>
      <label>
        Title
        <input
          required
          name="title"
          minlength={2}
          maxlength={40}
          placeholder="Buying Shoes"
          bind:value={title}
        />
      </label>
      <label>
        Description
        <textarea
          required
          name="description"
          minlength={2}
          maxlength={160}
          placeholder=" "
          bind:value={description}
        />
      </label>
      <label>
        Video url
        <input
          required
          name="videoUrl"
          placeholder="http(s)://something"
          type="url"
          bind:value={videoUrl}
        />
      </label>
      <button class="new-story-form-submit">Submit</button>
    </form>
  {:else}
    <Story id={story.id} />
  {/if}
</div>

<style>
  input {
    border-color: lightgray;
    border-radius: 4px;
    padding: 4px;
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
