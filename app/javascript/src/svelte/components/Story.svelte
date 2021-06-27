<script>
  import axios from "axios";
  import {onMount} from "svelte";
  import {Player, Ui} from "@vime/svelte";

  export let id;
  let storyTitle, contents;

  onMount(async () => {
    const apiHostUrl = process.env.API_HOST_URL || "http://localhost:3000";
    axios
      .get(`${apiHostUrl}/api/v1/sites/stories/${id}`, {
        params: {
          domain: window.location.hostname,
        },
      })
      .then(response => {
        storyTitle = response.data.story.story_title;
        contents = response.data.contents;
      });
  });
</script>

<div>
  <h2 class="swif-story-title">{storyTitle}</h2>

  {#if contents === undefined}
    loading
  {:else if contents === []}
    you aint got no contents bruh
  {:else}
    <ul class="swif-contents-list">
      {#each contents as content}
        <li>
          <a href={`${content.url}`}>
            {content.content_title}
          </a>
          <p>{content.description}</p>
          {#if content.video_url}
            <Player>
              <vm-youtube video-id={content.video_url.replace(/^.*\//, "")} />
              <Ui>
                <!-- UI components are placed here. -->
              </Ui>
            </Player>
          {/if}
        </li>
      {/each}
    </ul>
  {/if}
</div>
