# This file is used by Rack-based servers to start the application.

require 'diffa/participantdemo'

require ::File.expand_path('../config/environment',  __FILE__)
run AdapterDemo::Application
#run Diffa::ParticipantDemo.new.rackapp
