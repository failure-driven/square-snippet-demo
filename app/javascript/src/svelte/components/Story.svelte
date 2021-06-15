<script>
  import axios from "axios";
  import {onMount} from "svelte";

  export let id;
  let story;

  onMount(async () => {
    const apiHostUrl = process.env.API_HOST_URL || "http://localhost:3000";
    axios
      .get(`${apiHostUrl}/api/v1/sites/stories/${id}`, {
        params: {
          domain: window.location.hostname,
        },
      })
      .then(response => {
        story = response.data.story;
      });
  });
</script>

<div class="swif-story">
  this is a swif story! {story}
</div>
