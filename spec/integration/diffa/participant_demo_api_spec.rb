require 'diffa/participant_demo_api'
require 'rack/test'
require 'json'
require 'ostruct'

describe Diffa::ParticipantDemoAPI do
  
  let (:grid_store) { mock('grid store').as_null_object }
  let (:api) { Diffa::ParticipantDemoAPI.new(grid_store) }
  let (:client) { Rack::Test::Session.new api }

  describe "#provision_grid" do
    let (:request ) { Hash[name: "my slippers"] }
    it "Returns a 202 provisiond" do
      response = client.post("/grids", JSON.dump(request))
      response.status.should == 202
    end

    it "Calls out to the grid store" do
      grid_store.should_receive(:provision).with(hash_including(:name => request[:name]))
      client.post "/grids", JSON.dump(request)
    end

    describe "the response" do
      let (:response) { client.post("/grids", JSON.dump(request)) }
      let (:json_response) { JSON.parse(response.body) }
      let (:grid_id) { 23342}

      before do
        grid_store.stub(:provision).and_return(grid_id)
      end

      it "Returns a JSON representation of the provisiond grid" do
        json_response.should include('grid_url')
        json_response['grid_url'].should == "/grids/%d" % [grid_id]
      end
    end
  end

end


