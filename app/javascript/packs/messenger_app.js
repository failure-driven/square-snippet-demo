import MessengerApp from "../src/svelte/MessengerApp.svelte";

let element = document.querySelector("[data-app=messenger-app]");
document.addEventListener("DOMContentLoaded", () => {
  const app = new MessengerApp({
    target: element,
    props: {
      dataset: {
        identity: element.dataset.identity,
        site: element.dataset.site,
      },
    },
  });

  window.app = app;
});
