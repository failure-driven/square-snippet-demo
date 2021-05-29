import App from '../src/svelte/app.svelte'

let element = document.querySelector('[data-widget=demo-widget]');
if(!element) {
  element = document.createElement("div");
  element.setAttribute("data-widget", "demo-widget");
  document.body.appendChild(element);
}
document.addEventListener('DOMContentLoaded', () => {
  const app = new App({
    target: element,
    props: {
      name: 'Svelte'
    }
  });

  window.app = app;
})

