<script>
  import axios from "axios";
  import {onMount} from "svelte";

  export let id;
  let storyTitle;

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
      });
  });
</script>

<div class="swif-story-title">
  {storyTitle}
</div>
