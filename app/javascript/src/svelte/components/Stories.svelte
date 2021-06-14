<script>
  import axios from "axios";
  import {onMount} from "svelte";

  let stories;

  onMount(async () => {
    const apiHostUrl = process.env.API_HOST_URL || "http://localhost:3000";
    axios
      .get(`${apiHostUrl}/api/v1/sites/stories`, {
        params: {
          domain: window.location.hostname,
        },
      })
      .then(response => {
        stories = response.data.stories;
      });
  });
</script>

<div class="swif-stories-list">
  {#if stories === undefined}
    loading
  {:else if stories === []}
    you aint got no stories bruh
  {:else}
    <ul>
      {#each stories as story}
        <li>{story.story_title}</li>
      {/each}
    </ul>
  {/if}
</div>
