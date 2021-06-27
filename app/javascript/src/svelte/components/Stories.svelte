<script>
  import axios from "axios";
  import {onMount} from "svelte";
  import {authWidgetUrl} from "../services/siteConfig";

  export let site, identity;
  let stories;

  let auth = JSON.parse(localStorage.getItem("swifAuth"));

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

  const logout = () => {
    localStorage.setItem("swifAuth", null);
    auth = JSON.parse(localStorage.getItem("swifAuth"));
  };
  const authenticate = () => {
    const windowFeatures =
      "location=yes,resizable=yes,scrollbars=yes,status=yes,width=640,height=480";
    window.open(authWidgetUrl(), "Swif Auth", windowFeatures);
  };
</script>

<div>
  {#if auth}
    {auth.user.email}
    <button on:click={logout} class="btn btn-a btn-sm">log out</button>
  {:else}
    <button on:click={authenticate} class="btn btn-a btn-sm">log in</button>
  {/if}
</div>

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
