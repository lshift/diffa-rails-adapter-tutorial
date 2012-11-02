# Diffa Rails Adapter Tutorial

This is a simple Rails app that implements the Diffa scanning protocol.

#### Dependencies:

* rvm ― https://rvm.io/
* bundler -- http://gembundler.com/ or `gem install bundler` in the rvm
  environment.

#### Steps:

* After clone the git repo, make sure you initialize the submodules:

	$ git submodule init
	$ git submodule update

* Bundle the dependencies:

	$ bundle install

* Run a rake DB migration

	$ rake db:migrate
	$ rake db:seed	

* (If you want to add users via the API, set the following environment variable to some random token):

	$ export ADAPTER_TUTORIAL_AUTH_TOKEN=eb3ab1d26bcc7c2bb434ece420b1e58d	


#### License

This tutorial uses the Apache license, Version 2.0.