import App from '../src/svelte/app.svelte'

const element = document.querySelector('[data-widget=demo-widget]');
console.log(element)
document.addEventListener('DOMContentLoaded', () => {
  const app = new App({
    target: element,
    props: {
      name: 'Svelte'
    }
  });

  window.app = app;
})

