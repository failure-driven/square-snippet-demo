<script>
  import axios from "axios";
  import { onMount } from "svelte";

  let visitCount;

  onMount(async () => {
    const apiHostUrl = process.env.API_HOST_URL || "http://localhost:3000";
    axios
      .get(`${apiHostUrl}/api/v1/sites/visit_count`, {
        params: {
          domain: window.location.hostname,
        },
      })
      .then((response) => {
        visitCount = response.data.visit_count;
      });
  });

  async function addVisit() {
    const apiHostUrl = process.env.API_HOST_URL || "http://localhost:3000";
    axios
      .patch(`${apiHostUrl}/api/v1/sites/visit_count`, {
        domain: window.location.hostname,
      })
      .then((response) => {
        visitCount = response.data.visit_count;
      });
  }
</script>

<div>
  <h1>This site has been visited {visitCount} times!</h1>
  <button on:click={addVisit}>Add a visit</button>
</div>
