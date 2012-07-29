require 'diffa/grid_storage'

describe Diffa::GridStorage do
  describe "provisioning" do
    # When we are passed in a hash with name: specified
    # Then we should be able to retreive a grid iwth the same name.
    
    let (:store) { Diffa::GridStorage.new }

    it "must support retrieval for multiple grids" do
      names = ["dummy 1", "dummy 2", "dummy 3"]
      grid_ids = names.map { |name| store.provision(name: name) }
      grid_ids.map { |id| store.fetch(id) }.map(&:name).should == names
    end
  end
end
