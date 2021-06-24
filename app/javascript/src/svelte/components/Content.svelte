<script>
  import {createEventDispatcher, onMount} from "svelte";
  import getSiteConfig, {portalUrl} from "../services/siteConfig";
  import * as zoid from "zoid";

  let site, identity;
  if ("SwifStaticConfig" in window) {
    site = window["SwifStaticConfig"].data().site;
    identity = window["SwifStaticConfig"].data().identity;
  }
  const dispatch = createEventDispatcher();
  let siteConfig = {};

  let swifFrame = zoid.create({
    tag: "swif-frame",
    url: portalUrl({site, identity}),
    dimensions: {height: "100%", width: "100%"},
    props: {
      onNotification: {
        type: "function",
        required: true,
      },
    },
  });

  onMount(async () => {
    try {
      const response = await getSiteConfig({site, identity});
      siteConfig = response;
      dispatch("siteConfig", siteConfig);
    } catch (error) {
      this.error(500, "error: " + error.message);
    }
  });
</script>

{#if siteConfig && siteConfig.config && siteConfig.config.portal}
  <div id="swifFrame-container">
    {#if swifFrame({onNotification: function () {
        console.log("notification!");
      }}).render("#swifFrame-container")}
      {""}
    {/if}
  </div>
{/if}

<style>
  #swifFrame-container {
    height: 100%;
  }
</style>
