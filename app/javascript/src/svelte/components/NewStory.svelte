<script>
  import axios from "axios";

  let title = "";
  let description = "";
  let videoUrl = "";

  let success = "";

  function submit() {
      const authToken = JSON.parse(localStorage.getItem("swifAuth")).user.authToken

      const apiHostUrl = process.env.API_HOST_URL || "http://localhost:3000";
      axios
          .post(`${apiHostUrl}/api/v1/sites/stories`, {
              params: {
                  domain: window.location.hostname,
                }
              },
              {
                headers: {
                    "CONTENT-TYPE": "application/json",
                    "AUTHORIZATION": `Token ${authToken}`,
                }
              })
          .then(response => {
              success = response.data;
          });
  }
</script>

<div>
    {JSON.stringify(success)}

  <h2 class="swif-story-title">New Story</h2>

  <form on:submit|preventDefault={submit}>
    <label>
      Title
      <input
        required
        minlength={2}
        maxlength={40}
        placeholder="Buying Shoes"
        bind:value={title}
      />
    </label>
    <label>
      Description
        <textarea
            required
            minlength={2}
            maxlength={160}
            placeholder=" "
            bind:value={description}
        />
    </label>
    <label>
      Video url
      <input
        required
        placeholder="http(s)://something"
        type="url"
        bind:value={videoUrl}
      />
    </label>
    <button>Submit</button>
  </form>
</div>

<style>
  input {
    border-color: lightgray;
    border-radius: 4px;
    padding: 4px;
  }
  input:not(:placeholder-shown) {
    border-color: red;
  }
  input:valid {
    border-color: lightgray;
  }
  label {
    font-weight: bold;
  }
</style>
