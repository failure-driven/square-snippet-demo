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
    dimensions: {height: "400px", width: "350px"},
  });

  onMount(async () => {
    try {
      const response = await getSiteConfig({site, identity});
      siteConfig = response;
      dispatch("siteConfig", siteConfig);
    } catch (error) {
      this.error(500, "error: " + error.message);
    }
    swifFrame().render("#swifFrame-container");
  });
</script>

{#if siteConfig && siteConfig.config && siteConfig.config.portal}
  <div id="swifFrame-container" />
{/if}
