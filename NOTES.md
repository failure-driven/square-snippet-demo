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

## create content

```
rails content:for_users SOURCE_URL="https://..." USER_IDS=...,... USER=... PASS=...
find tmp/content

# force sizing and reshaping
mogrify -resize 800x600! *.png

# or convert
convert -resize 1024x1024 user_id_00.png user_id_00.png

# make a movie
ffmpeg -framerate 1 -i user_id_%02d.png -vcodec libx264 -crf 25 -r 60 -pix_fmt yuv420p user_id.mp4
```

