<script>
  import {onMount} from "svelte";
  import getSiteConfig from "./../services/siteConfig";
  let site, identity;
  if ("SwifStaticConfig" in window) {
    site = window["SwifStaticConfig"].data().site;
    identity = window["SwifStaticConfig"].data().identity;
  }
  let siteConfig = {};
  onMount(async () => {
    try {
      const response = await getSiteConfig({site, identity});
      siteConfig = response;
    } catch (error) {
      this.error(500, "error: " + error.message);
    }
  });
</script>

{#if siteConfig && siteConfig.config && siteConfig.config.iframe}
  <iframe
    frameBorder="0"
    style="height: 350px; width: 100%"
    title="chatbot"
    src={siteConfig.config.iframe}
  />
{/if}
