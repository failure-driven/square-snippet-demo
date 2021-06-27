<script>
  function stringifyEvent(e) {
    const obj = {};
    for (let k in e) {
      obj[k] = e[k];
    }
    return JSON.stringify(
      obj,
      (k, v) => {
        if (v instanceof Node)
          return `Node: {nodeName: ${v.nodeName}, innerHTML: ${
            v.innerHTML && v.innerHTML.substring(0, 200)
          }}`;
        if (v instanceof Window) return "Window";
        return v;
      },
      " "
    );
  }
  const output = e => {
    console.log(e);
    console.log(stringifyEvent(e));
    console.log(e.timeStamp);
    console.log(e.baseURI);
    console.log(e.srcElement.href);
    console.log(e.srcElement.outerText);
  };
  document.body.onclick = output;
</script>
