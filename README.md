# SWIF - Social Shopping app powered by Square Unboxed - API snippet [![CircleCI](https://circleci.com/gh/failure-driven/square-snippet-demo.svg?style=svg)](https://circleci.com/gh/failure-driven/square-snippet-demo)
## Enables your Square powered app to add powerful "Interactive Social Shopping Feature" in 60 seconds

[![Square Unboxed - API snippet for Rails Template Walkthrough](https://i.ibb.co/6X4wXtw/Screen-Shot-2021-06-08-at-2-28-36-pm.png)](https://www.youtube.com/watch?v=JbytzNibk54)

## Requirements

You'll need the following installed to run the template successfully:

* Ruby 3.0.1 or higher
* bundler - `gem install bundler`
* rails - `gem install rails`
* Yarn - `brew install yarn` or [Install Yarn](https://yarnpkg.com/en/docs/install)

Other:
* Svelte Compiler/ JS framework (Provided out of the box) - lightweight and fast alternative to React/Vue/Angular
* Database (MySQL Provided out of the box)

# Commands to run / Setting up
## Set credentials key
```zsh
touch config/credentials/development.key
echo '/config/credentials/development.key' >> .gitignore
git status # '/config/credentials/development.key' should not be there, we don't want to push it to Github.
```
paste your key in the above file and make sure it stays private
## Ruby Gems
```zsh
bundle install
```
## Yarn
```zsh
yarn install
```
## Running the app
```zsh
rails c
```
## Go to "http://localhost:3000/" and login 
![login](https://i.ibb.co/qMX9tM0/Screen-Shot-2021-06-08-at-3-09-32-pm.png)
## Enable our snippet on your app
![Enable Widget](https://i.ibb.co/JxGfNrj/Screen-Shot-2021-06-08-at-3-13-31-pm.png)
# That's it! 🚀
## Misc
```bash
make
bin/setup

# add yourself an admin user and login with reset password link
bin/rails 'admin:make_admin_user[m@m.m]'

# enable|disable features
bin/rails 'admin:flipper[portal,enable]' IDENTITIES=MLWS55T9N0BQ9,MLKR1MSQCYV7Y
bin/rails 'admin:flipper[portal,disable]' IDENTITIES=MLWS55T9N0BQ9
```
### ❓Having trouble? 
Create and issue or get in touch
