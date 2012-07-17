require 'diffa/participant_demo_api'
require 'rack/test'
require 'json'
require 'ostruct'

describe Diffa::ParticipantDemoAPI do
  
  let (:grid_store) { mock('grid store').as_null_object }
  let (:api) { Diffa::ParticipantDemoAPI.new(grid_store) }
  let (:client) { Rack::Test::Session.new api }

  describe "#create_grid" do
    let (:request ) { Hash[name: "my slippers"] }
    it "Returns a 202 created" do
      response = client.post("/grids", JSON.dump(request))
      response.status.should == 202
    end

    it "Calls out to the grid store" do
      grid_store.should_receive(:create).with(hash_including(:name => request[:name]))
      client.post "/grids", JSON.dump(request)
    end

    describe "the response" do
      let (:response) { client.post("/grids", JSON.dump(request)) }
      let (:json_response) { JSON.parse(response.body) }
      let (:grid_id) { 23342}
      let (:grid) { OpenStruct.new(:id => grid_id) }

      before do
        grid_store.stub(:create).and_return(grid)
      end

      it "Returns a JSON representation of the created grid" do
        json_response.should include('grid_url')
        json_response['grid_url'].should == "/grids/%d" % [grid_id]
      end
    end
  end

end


