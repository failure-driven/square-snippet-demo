<script>
  import {createEventDispatcher, onMount} from "svelte";
  import getSiteConfig, {portalUrl} from "../services/siteConfig";
  import Counter from "./Counter.svelte";
  import * as zoid from "zoid";

  const hostnamePartRegex = new RegExp(/[^/]+\/\/([^.^:^/]+)/i);
  const needle = (process.env.API_HOST_URL || "http://localhost:3000").match(
    hostnamePartRegex
  );
  const swifFrameContainerId = `swifFrame-container-${
    needle ? needle[1] : "null"
  }`;

  let site, identity;
  if ("SwifStaticConfig" in window) {
    site = window["SwifStaticConfig"].data().site;
    identity = window["SwifStaticConfig"].data().identity;
  }
  const dispatch = createEventDispatcher();
  let siteConfig = {};

  let swifFrame;
  const createSwifFrame = () => {
    swifFrame = zoid.create({
      tag: "swif-frame",
      url: portalUrl({site, identity}),
      dimensions: {height: "100%", width: "100%"},
      attributes: {
        iframe: {
          allow: "camera;microphone",
          class: "content-iframe",
        },
      },
      props: {
        onNotification: {
          type: "function",
          required: true,
        },
      },
    });
  };

  onMount(async () => {
    try {
      const response = await getSiteConfig({site, identity});
      siteConfig = response;
      dispatch("siteConfig", siteConfig);
      createSwifFrame();
    } catch (error) {
      console.error(500, "error: " + error.message);
    }
  });
</script>

{#if siteConfig && siteConfig.config && siteConfig.config.noisy_counter}
  <Counter />
{/if}
{#if siteConfig && siteConfig.config && siteConfig.config.zoid_portal}
  <div id={swifFrameContainerId} class="swifFrame-container">
    {swifFrame &&
      swifFrame({
        onNotification: function () {
          console.log("notification!");
        },
      }).render(`#${swifFrameContainerId}`) &&
      ""}
  </div>
{:else if siteConfig && siteConfig.config && siteConfig.config.portal}
  <iframe
    frameBorder="0"
    style="height: 350px; width: 100%"
    title="chatbot"
    allow="camera;microphone"
    src={portalUrl({site, identity})}
    class="content-iframe"
  />
{/if}

<style>
  .swifFrame-container {
    height: 100%;
  }
</style>
