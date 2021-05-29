<script>
  import axios from "axios";
  import { onMount } from 'svelte';

  let visitCount;

  onMount(async () => {
		axios.get('https://swif.club/api/v1/sites/'+ window.location.hostname).then((response) => {
      visitCount = response.data.visit_count
    })
	});

  async function addVisit(){
    axios.patch('https://swif.club/api/v1/sites/'+ window.location.hostname).then((response) => {
      visitCount = response.data.visit_count
    })
  }
</script>

<div>
  <h1>This site has been visited {visitCount} times!</h1>
  <button on:click={addVisit}>Add a visit</button>
</div>