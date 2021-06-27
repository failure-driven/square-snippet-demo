# Notes

a way to inject our SWiF widget for development on a page where it is not yet
loaded.

in dev tools

```{javascript}
s1 = document.createElement("script");
s1.innerHTML = 'var SwifStaticConfig = (function(my){ my.data = () => { return {"site":"site_548304609408534002","identity":"MLWS55T9N0BQ9"} }; return(my) })(SwifStaticConfig || {})';
document.head.appendChild(s1);
s2 = document.createElement("script");
s2.src = "http://localhost:3000/identities/MLWS55T9N0BQ9/sites/site_548304609408534002/widget";
s2.defer = true;
document.head.appendChild(s2);
swifApp.app()
```
