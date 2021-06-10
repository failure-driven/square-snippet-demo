<script>
  import Content from "./components/Content.svelte";
  import Widget from "./widget/Widget.svelte";

  let site, identity;
  if ("SwifStaticConfig" in window) {
    site = window["SwifStaticConfig"].data().site;
    identity = window["SwifStaticConfig"].data().identity;
  }
  let header = "Shopping With Friends Placeholder";
</script>

<Widget>
  <div slot="header">{header}</div>
  <div slot="content">
    <Content />
  </div>
</Widget>

<style>
  :global(div[slot="content"]) {
    height: 100%;
  }

  :global(.animated-gradient) {
    background: linear-gradient(
      213deg,
      #ba00ff,
      #5c2686,
      #ff1690,
      #00f2ff,
      #00ccff
    );
    background-size: 800% 800%;

    -webkit-animation: gradient 25s ease infinite;
    -moz-animation: gradient 25s ease infinite;
    -o-animation: gradient 25s ease infinite;
    animation: gradient 25s ease infinite;
  }

  @-webkit-keyframes gradient {
    0% {
      background-position: 0% 58%;
    }
    50% {
      background-position: 100% 43%;
    }
    100% {
      background-position: 0% 58%;
    }
  }
  @-moz-keyframes gradient {
    0% {
      background-position: 0% 58%;
    }
    50% {
      background-position: 100% 43%;
    }
    100% {
      background-position: 0% 58%;
    }
  }
  @-o-keyframes gradient {
    0% {
      background-position: 0% 58%;
    }
    50% {
      background-position: 100% 43%;
    }
    100% {
      background-position: 0% 58%;
    }
  }
  @keyframes gradient {
    0% {
      background-position: 0% 58%;
    }
    50% {
      background-position: 100% 43%;
    }
    100% {
      background-position: 0% 58%;
    }
  }
</style>
