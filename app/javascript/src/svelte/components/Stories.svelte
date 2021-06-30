<script>
  import axios from "axios";
  import {onMount} from "svelte";

  export let site, identity;
  let stories;

  onMount(async () => {
    const apiHostUrl = process.env.API_HOST_URL || "http://localhost:3000";
    axios
      .get(`${apiHostUrl}/api/v1/sites/stories?site_id=${site}`, {
        params: {
          domain: window.location.hostname,
        },
      })
      .then(response => {
        stories = response.data.stories;
      });
  });
</script>

<a
  class="new-story-link"
  href={`/identities/${identity}/sites/${site}/portal/new_story`}
>
  create your own story!
</a>

<div class="swif-stories-list">
  {#if stories === undefined}
    loading
  {:else if stories.length > 0}
    <ul>
      {#each stories as story}
        <li>
          <a
            href={`/identities/${identity}/sites/${site}/portal/stories/${story.id}`}
          >
            {story.story_title}
          </a>
        </li>
      {/each}
    </ul>
  {:else}
    <div class="swif-no-stories">you aint got no stories bruh</div>
  {/if}
</div>
