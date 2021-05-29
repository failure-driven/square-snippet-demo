<script>
  import VisitorCount from "./app/VisitorCount.svelte";
  import "./global.css"
  import Widget from "./widget/Widget.svelte";
</script>

<Widget>
  <div slot="header">Header</div>
  <div slot="content">
    <VisitorCount/>
  </div>
</Widget>