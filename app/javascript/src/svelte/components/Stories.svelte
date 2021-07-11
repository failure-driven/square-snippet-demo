<script>
  import axios from "axios";
  import {Player, Youtube} from "@vime/svelte";
  import {onMount} from "svelte";
  import Icon from "./Icon.svelte";
  import {faHeart} from "@fortawesome/free-solid-svg-icons/faHeart";
  import {faCommentAlt} from "@fortawesome/free-solid-svg-icons/faCommentAlt";
  import {faShareSquare} from "@fortawesome/free-solid-svg-icons";

  export let site, identity;
  let stories;
  let height = window.innerHeight;

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

  function showReview(title) {
    let ele = document.querySelector(`.story-functions.${title}`);
    if (ele.style.display === "none") {
      ele.style.display = "flex";
      document.querySelector(`.review-text.${title}`).style.display = "none";
    } else {
      ele.style.display = "none";
      document.querySelector(`.review-text.${title}`).style.display = "inherit";
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

<svelte:window bind:innerHeight={height} />
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
    {#each placeholderStories as story}
      <div
        class="story"
        style="
        background:linear-gradient(rgba(0, 0, 0, 0.3),rgba(0, 0, 0, 0.3)), url({story.url});
        background-size: cover;
        aspect-ratio: 9/16;
        display: flex;
        justify-content: flex-end;
        flex-direction: column;
        padding: 1rem;
        max-height: {height - 80}"
      >
        <div class="story-functions {story.title.replace(/\s+/g, '')}">
          <div class="story-controls">
            <Icon class="myClass1 myClass2 navIcon" icon={faHeart} />
            <Icon class="myClass1 myClass2 navIcon" icon={faCommentAlt} />
            <Icon class="myClass1 myClass2 navIcon" icon={faShareSquare} />
          </div>
          <div
            class="review"
            on:click={() => {
              showReview(story.title.replace(/\s+/g, ""));
            }}
          >
            ★★★★☆
          </div>
        </div>
        <div
          class="review-text {story.title.replace(/\s+/g, '')}"
          on:click={() => {
            showReview(story.title.replace(/\s+/g, ""));
          }}
        >
          <em>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur
            et neque in risus dictum tincidunt. Vivamus nisl nibh, maximus id
            gravida non, bibendum et velit.
          </em>
        </div>
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
    margin: 0 2rem;
    margin-bottom: 2rem;
  }

  .story-functions {
    display: flex;
    color: white;
  }

  .story-controls {
    width: 50%;
    justify-content: space-evenly;
    display: flex;
  }

  .review {
    cursor: pointer;
  }

  .review-text {
    border-radius: 10px;
    display: none;
    color: white;
    padding: 1rem;
    background-color: rgba(0, 0, 0, 0.4);
    transform: translateY(-200);
  }
</style>
