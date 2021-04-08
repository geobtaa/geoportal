Dependencies

* Ruby 2.6.1
* Java 1.8 or greater
* Node
* Yarn

If you are using a Mac, I recommend Homebrew to install dependencies:
https://brew.sh/

Install Ruby via homebrew:
brew install rbenv

Install Java via homebrew
$ brew tap homebrew/cask-versions
$ brew update
$ brew tap caskroom/cask
$ brew cask install java

Install Node via homebrew
brew install node

Install Yarn
brew install yarn

Run bundle to install Ruby dependencies
$ bundle install

Run yarn to install Node dependencies
$ yarn install

Create your database
$ bundle exec rails db:create
$ bundle exec rails db:migrate

Spin up the application
$ bundle exec rake geoportal:server
