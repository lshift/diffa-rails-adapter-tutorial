require 'diffa/grid_model'

describe Diffa::Grid do
  let (:initial_data) { [] }
  let (:model) { Diffa::Grid.new(initial_data) }


  describe "#update" do
    it "updates the initial_data" do
      new_value = [{"id" => "1", "version" => 2}]
      expect { model.update(new_value) }.to change { model.data }.
        from(initial_data).to(new_value)
    end
  end


  describe "#query" do
    let (:mike) { {"id" => "mike", 'version' => "b" } }
    let (:myspace) { {"id" => "MySpace", 'version' => "a" } }
    let (:initial_data) { [mike, myspace] }

    it "returns data sorted by id in ASCII collation order" do
      model.query.should == [myspace, mike]
    end
  end
end
