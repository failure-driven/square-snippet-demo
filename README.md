<h1 align="center">Square Snippet Demo - swif.club</h1>

<div align="center">

[![CircleCI](https://circleci.com/gh/failure-driven/square-snippet-demo.svg?style=svg)](https://circleci.com/gh/failure-driven/square-snippet-demo)

</div>

```
make
bin/setup

# add yourself an admin user and login with reset password link
bin/rails 'admin:make_admin_user[m@m.m]'

# enable|disable features
bin/rails 'admin:flipper[messenger,enable]' IDENTITIES=MLWS55T9N0BQ9,MLKR1MSQCYV7Y
bin/rails 'admin:flipper[messenger,disable]' IDENTITIES=MLWS55T9N0BQ9
```

