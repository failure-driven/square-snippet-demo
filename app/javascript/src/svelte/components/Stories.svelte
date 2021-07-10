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
    let found = false;
    let elements = document.querySelectorAll("[data-storyId]");
    for (let i = 0; i < elements.length && !found; i++) {
      let ele = elements[i];
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
        found = true;
      }
    }
  }

  const placeholderStories = [
    {
      title: "Stair put on",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_stairs_put_on.gif",
    },
    {
      title: "toe stand",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_stand_toe.gif",
    },
    {
      title: "lace up",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_lace_up.gif",
    },
    {
      title: "lace bow",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_lace_up_bow.gif",
    },
    {
      title: "look down",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_looking_down.gif",
    },
    {
      title: "shake spin",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_shake_and_side_to_side.gif",
    },
    {
      title: "side to side",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_side_to_side.gif",
    },
    {
      title: "side",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_side_view.gif",
    },
    {
      title: "side to side",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_up_and_down_side_to_side.gif",
    },
    {
      title: "walk away",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_walk_away.gif",
    },
    {
      title: "walk across",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_walk_away_across.gif",
    },
    {
      title: "away",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_walk_away_again.gif",
    },
    {
      title: "away fast",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_walk_away_fast.gif",
    },
    {
      title: "towards",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_walk_towards_close.gif",
    },
    {
      title: "towards pause",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_walk_towards_pause.gif",
    },
    {
      title: "towards stop",
      url: "https://s3.amazonaws.com/swif.club/demo_assets/pink_sneaker_walk_towards_stop.gif",
    },
  ];
</script>

<div class="swif-stories-list" on:scroll={autoplay}>
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
                muted={true}
              />
            </Player>
          {/if}
        </div>
      {/each}
    </div>
  {:else}
    <div class="swif-no-stories">you aint got no stories bruh</div>
    {#each placeholderStories as story}
      <div class="story">
        <img alt={story.title} src={story.url} style="width:100%;" />
      </div>
    {/each}
  {/if}
</div>

<style>
  .swif-stories-list {
    overflow-y: scroll;
    height: 100%;
    padding: 2rem 0;
  }

  .swif-stories-list::-webkit-scrollbar {
    width: 0.5em;
  }

  .swif-stories-list::-webkit-scrollbar-track {
    background-color: #dfe0d9;
  }

  .swif-stories-list::-webkit-scrollbar-thumb {
    background-color: darkgrey;
  }

  .story-wrapper {
    padding-bottom: 2rem;
    padding: 0 1rem;
  }

  .story:last-child {
    margin-bottom: 200px;
  }

  .story {
    border-radius: 10px;
    overflow: hidden;
    margin-bottom: 2rem;
  }
</style>
