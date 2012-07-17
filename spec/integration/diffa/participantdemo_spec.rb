require 'diffa/participantdemo'

require 'rack/test'
require 'json'

describe Diffa::ParticipantDemoApp do
  let (:data_base) { stub(:data_base).as_null_object }

  let (:app) { Diffa::ParticipantDemoApp.new(data_base) }

  let (:client) { Rack::Test::Session.new(app) }

  let (:data) { [ {"id" => "dummy id", "version" => "dummy version"} ] }
  describe "Saving grid state" do
    let (:response) { client.post "/", JSON.dump(data) }

    it "respond with 2xx status" do
      response.status.should == 200
    end

    it "should parse submitted JSON, and pass through to app" do
      data_base.should_receive(:update).with(data)
      response
    end
  end


  describe "Performing entity scans" do 
    let (:get_response) { client.get "/scan" }
    let (:parsed_response) { JSON.parse(get_response.body) }

    before do
      data_base.stub(:query).with().and_return(data)
    end

    it "respond with 2xx status" do
      get_response.status.should == 200
    end

    it "should query the data source" do
      data_base.should_receive(:query).with().and_return(data)
      get_response
    end

    it "should respond with query result" do
      parsed_response.should == data
    end
  end
end
