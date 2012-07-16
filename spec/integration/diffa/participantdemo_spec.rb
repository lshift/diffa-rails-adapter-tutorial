require 'diffa/participantdemo'

require 'rack/test'
require 'json'

describe Diffa::ParticipantDemoApp do

  let (:data_base) { stub(:data_base).as_null_object }

  let (:app) { Diffa::ParticipantDemoApp.new(data_base) }

  let (:client) { Rack::Test::Session.new(app) }

  describe "Saving grid state" do
    let (:data) { [ {"id" => "dummy id", "version" => "dummy version"} ] }
    let (:response) { client.post "/", JSON.dump(data) }

    it "respond with 2xx status" do
      response.status.should == 200
    end

    it "should parse submitted JSON, and pass through to app" do
      data_base.should_receive(:update).with(data)
      response
    end
  end
end
