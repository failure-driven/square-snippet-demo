<script>
  import axios from "axios";
  import {Player, Youtube} from "@vime/svelte";
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

  function autoplay() {
    document.querySelectorAll("[data-storyId]").forEach(ele => {
      console.log(window.innerHeight);
      console.log(ele.getBoundingClientRect().bottom);
      console.log(ele.getBoundingClientRect().top);

      if (
        ele.getBoundingClientRect().bottom <= window.innerHeight &&
        ele.getBoundingClientRect().top >= 0
      ) {
        if (ele.dataset.playing === "false") {
          let iframe = ele
            .querySelector("vm-youtube")
            .shadowRoot.querySelector("vm-embed")
            .shadowRoot.querySelector("iframe");
          iframe.attributes.src.value = iframe.attributes.src.value
            .replace("mute=0", "mute=1")
            .replace("autoplay=0", "autoplay=1");
          ele.dataset.playing = true;
        }
      }
    });
  }
</script>

<svelte:window on:scroll={autoplay} />

<div class="swif-stories-list">
  {#if stories === undefined}
    loading
  {:else if stories.length > 0}
    <div class="story-wrapper">
      {#each stories as story}
        <div data-storyId={story.id} data-playing={false} class="story">
          <a
            href={`/identities/${identity}/sites/${site}/portal/stories/${story.id}`}
            ><div class="title">{story.story_title}</div></a
          >
          {#if story.video_url}
            <Player controls>
              <Youtube
                videoId={story.video_url.replace(/^.*\//, "")}
                showFullscreenControl={false}
              />
            </Player>
          {/if}
        </div>
      {/each}
    </div>
  {:else}
    <div class="swif-no-stories">you aint got no stories bruh</div>
  {/if}
</div>

<style>
  .story-wrapper {
    padding-bottom: 2rem;
  }

  .story {
    border-radius: 10px;
    overflow: hidden;
    margin-bottom: 1rem;
  }

  .story .title {
    background-color: rgb(224, 224, 224);
    width: 100%;
    padding: 10 15px;
    font-family: sans-serif;
    font-weight: 600;
    transition: all 0.15s;
  }

  .story .title:hover {
    background-color: rgb(41, 41, 41);
    color: white;
  }

  .story a {
    text-decoration: none;
    color: rgb(41, 41, 41);
  }
</style>
