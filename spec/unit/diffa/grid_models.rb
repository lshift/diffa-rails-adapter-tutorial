require 'diffa/grid_model'

describe Diffa::GridModel do
  let (:initial_data) { [] }
  let (:model) { Diffa::GridModel.new(initial_data) }


  describe "update" do
    it "updates the initial_data" do
      new_value = [{"id" => "1", "version" => 2}]
      expect { model.update(new_value) }.to change { model.data }.
        from(initial_data).to(new_value)
    end
  end
end
