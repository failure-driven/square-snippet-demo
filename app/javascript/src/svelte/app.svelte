<script>
  import Content from "./components/Content.svelte";
  import Widget from "./widget/Widget.svelte";

  let site, identity;
  if ("SwifStaticConfig" in window) {
    site = window["SwifStaticConfig"].data().site;
    identity = window["SwifStaticConfig"].data().identity;
  }
  let header = "Shopping With Friends Placeholder";
  let cssVarStyles = {};
  const processSiteConfig = event => {
    const siteConfig = event.detail.config;
    if (siteConfig.title) {
      header = siteConfig.title;
    }
    cssVarStyles = `--swif-background-color:${siteConfig["background-color"]};`;
  };
</script>

<Widget>
  <!-- <div slot="header">{header}</div> -->
  <div slot="content" class="main swif-lightbg" style={cssVarStyles}>
    <Content on:siteConfig={processSiteConfig} />
  </div>
</Widget>

<style>
  :global(div[slot="content"]) {
    height: 100%;
  }

  :global(.swif-lpurple) {
    background-color: #a683f2 !important;
  }

  :global(.swif-dpurple) {
    background-color: #6706bc !important;
  }

  :global(.swif-yellow) {
    background-color: #fbae17 !important;
  }

  :global(.swif-lightbg) {
    background-color: #dfe0d9 !important;
  }

  :global(.swif-purple-gradient) {
    background: linear-gradient(130deg, #6706bc, #a683f2) !important;
  }
</style>
