# BUGS

- this commit broke our styles by adding mailer.css which should ONLY be used
  for emails
  https://github.com/failure-driven/square-snippet-demo/commit/c062045ccfe6c374400d0577345db2af972b2e64
- add retries for flaky api calls failing
- swif is slow to load? investigate if onLoad module thing is slowing it down?
- lint does not complain about console.log???
- no error pages in rails - will show up in widget
- sort out images in chat
- [ ] error if user has no sites at all (refer PR, branch `fix-no-site`)
- error first time user uses the app as there are no sites to load
- resizing the window makes the SWiF launch button disappear
- there is quite a lag when dragging the SWiF launch button around the screen,
  is this on puropse?
- [ ] identiy site list has text over text in different page sizes (fixed as part of `portal_toggle` feature branch)

## DONE

- [x] alert color lost
- [x] name and sign out button are too close together in less than medium breakpoint
