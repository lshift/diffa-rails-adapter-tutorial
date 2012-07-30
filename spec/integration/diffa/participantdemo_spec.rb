require 'diffa/participantdemo'
require 'diffa/participant_demo_app'

require 'rack/test'
require 'json'

# TODO: I do all of the things. Please split me up by responsibility.
# --CS
describe Diffa::ParticipantDemoApp do
  let (:data_base) { stub(:data_base).as_null_object }

  let (:grid_store) { mock(:grid_store) }

  let (:app) { Diffa::ParticipantDemoApp.new(grid_store) }

  let (:client) { Rack::Test::Session.new(app) }

  let (:data) { [ {"id" => "dummy id", "version" => "dummy version"} ] }

#  describe "Saving grid state" do
#    let (:response) { client.post "/", JSON.dump(data) }
#
#    it "respond with 2xx status" do
#      response.status.should == 200
#    end
#
#    it "should parse submitted JSON, and pass through to app" do
#      data_base.should_receive(:update).with(data)
#      response
#    end
#  end

# TODO: 404 behavior?
  describe "Performing entity scans" do 
    let (:grid_id) { 31343 }
    let (:get_trades) { client.get "/scan/%d/entered_trades" % [grid_id] }
    let (:parsed_trades) { JSON.parse(get_trades.body) }
    let (:grid) { OpenStruct.new(entered_trades: data) }
    

    before do
      grid_store.stub(:fetch).with(grid_id).and_return(grid)
    end

    it "respond with 2xx status" do
      get_trades.status.should == 200
    end

    it "looks up the grid" do
      grid_store.should_receive(:fetch).with(grid_id).and_return(grid)
      get_trades
    end

    it "should respond with query result" do
      parsed_trades.should == data
    end
  end


#  describe "Retreiving the current dataset" do
#    let (:get_response)  { client.get "/data" }
#    let (:parsed_response) { JSON.parse(get_response.body) }
#
#    before do
#      data_base.stub(:query).with().and_return(data)
#    end
#
#    it "respond with 2xx status" do
#      get_response.status.should == 200
#    end
#
#    it "should query the data source" do
#      data_base.should_receive(:query).with().and_return(data)
#      get_response
#    end
#
#    it "should respond with query result" do
#      parsed_response.should == data
#    end
#  end
#
  describe "fetch grid page" do
    let (:grid_id) { 42 }
    let (:get_response)  { client.get "/grids/%d" % [grid_id] }
    let (:aGrid) { Grid.new(name: "Test grid") }


    before do
      grid_store.stub(:fetch).with(grid_id)# .and_return(aGrid)
    end

    it "should lookup a grid" do
      grid_store.should_receive(:fetch).with(grid_id)# .and_return(aGrid)
      get_response
    end
  
    it "should return OK" do
      get_response.status.should == 200
    end
    it "should return the grid html page" do
      get_response.body.should include("Diffa participant Grid")
    end

    it "should contain a reference to the grid data source" do
      get_response.body.should include(grid_id.to_s)
    end
  end
end
