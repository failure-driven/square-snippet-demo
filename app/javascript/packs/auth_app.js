import PortalApp from "../src/svelte/AuthApp.svelte";

let element = document.querySelector("[data-app=auth-app]");
document.addEventListener("DOMContentLoaded", () => {
  const app = new PortalApp({
    target: element,
    props: {
      dataset: {
        user: JSON.parse(element.dataset.user)
      }
    },
  });

  window.app = app;
});
