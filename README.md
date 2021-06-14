# SWIF Club - Shop with your friends on any website [![CircleCI](https://circleci.com/gh/failure-driven/square-snippet-demo.svg?style=svg)](https://app.circleci.com/pipelines/github/failure-driven/square-snippet-demo?branch=main)
## Enables your Square powered app to add powerful "Interactive Social Shopping Feature" in 60 seconds 🎉

[![Square Unboxed - API snippet for Rails Template Walkthrough](https://i.ibb.co/6X4wXtw/Screen-Shot-2021-06-08-at-2-28-36-pm.png)](https://www.youtube.com/watch?v=JbytzNibk54)

## Requirements

You'll need the following installed to run the template successfully:

* **Ruby 3.0.1**
* bundler - included in Ruby now, no need to install
* rails - will be installed via bundler
* Yarn - `npm install --global yarn` or [Install Yarn](https://yarnpkg.com/en/docs/install)

Other noticable features (provided out of the box):
* Svelte Compiler / JS framework
* Postgres Database

# Commands to run / Setting up
## Add development.key config/credentials/development.key / Check you have it correctly
```zsh
cat config/credentials/development.key
# d6.............9a
git status # '/config/credentials/development.key' should not be there.
```
paste your key in the above file and make sure it stays private

## Setup app
```zsh
make
make build
bin/setup
```
## Running the app
```zsh
rails s
```
## Go to "http://localhost:3000/" and login 
![login](https://i.ibb.co/qMX9tM0/Screen-Shot-2021-06-08-at-3-09-32-pm.png)
## Enable our snippet on your app
![Enable Widget](https://i.ibb.co/JxGfNrj/Screen-Shot-2021-06-08-at-3-13-31-pm.png)
# That's it! 🚀
## Misc
```bash
# add yourself an admin user and login with reset password link
bin/rails 'admin:make_admin_user[m@m.m]'

# enable|disable features
bin/rails 'admin:flipper[portal,enable]' IDENTITIES=MLWS55T9N0BQ9,MLKR1MSQCYV7Y
bin/rails 'admin:flipper[portal,disable]' IDENTITIES=MLWS55T9N0BQ9
```
### ❓Having trouble? 
Create and issue or get in touch
