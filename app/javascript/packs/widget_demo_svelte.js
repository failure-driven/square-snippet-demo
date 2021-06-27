import App from '../src/svelte/app.svelte'

let element = document.querySelector('[data-widget=demo-widget]');
if (!element) {
  element = document.createElement("div");
  element.setAttribute("data-widget", "demo-widget");
  document.body.appendChild(element);
}
var swifApp = (function (my) {
  my.app = () => {
    var app = new App({
      target: element,
      props: {
        name: 'Svelte'
      }
    });

    window.app = app;
    return app;
  };
  return (my)
})(swifApp || {})
window.swifApp = swifApp;
document.addEventListener('DOMContentLoaded', () => {
  window.swifApp.app()
})

