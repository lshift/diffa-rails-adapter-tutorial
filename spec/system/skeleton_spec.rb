require 'rspec'

require 'capybara/rspec'
require 'capybara/poltergeist'

require 'diffa/participantdemo'

require_relative 'app_driver'

Capybara.javascript_driver = :poltergeist

describe "Application skeleton", :js => true do
  let (:app) { Diffa::ParticipantDemo.new }
  let (:driver) { Diffa::Test::AppDriver.new(app.rackapp) }

  it "Can add and remove data from the database" do
    driver.show_grid
    driver.grid.should include(["sample-id0", "sample-version0"])
    expect {
      driver.add_entity(["id1", "version1"])
      driver.save_to_server
    }.to change { app.data.size }.from(1).to(2)
  end
end
