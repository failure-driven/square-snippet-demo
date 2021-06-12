<script>
  import {createEventDispatcher, onMount} from "svelte";
  import getSiteConfig, {portalUrl} from "../services/siteConfig";
  let site, identity;
  if ("SwifStaticConfig" in window) {
    site = window["SwifStaticConfig"].data().site;
    identity = window["SwifStaticConfig"].data().identity;
  }
  const dispatch = createEventDispatcher();
  let siteConfig = {};
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

{#if siteConfig && siteConfig.config && siteConfig.config.iframe}
  <iframe
    frameBorder="0"
    style="height: 350px; width: 100%"
    title="chatbot"
    src={siteConfig.config.iframe}
  />
{:else if siteConfig && siteConfig.config && siteConfig.config.portal}
  <iframe
    frameBorder="0"
    style="height: 350px; width: 100%"
    title="chatbot"
    src={portalUrl({site, identity})}
  />
{/if}
