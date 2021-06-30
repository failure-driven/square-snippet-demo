import PortalApp from "../src/svelte/PortalApp.svelte";

let element = document.querySelector("[data-app=portal-app]");
document.addEventListener("DOMContentLoaded", () => {
  const app = new PortalApp({
    target: element,
    props: {
      dataset: {
        identity: element.dataset.identity,
        site: element.dataset.site,
        config: JSON.parse(element.dataset.config),
      },
    },
  });

  window.app = app;
});
