require 'rspec'

require 'capybara/rspec'
require 'capybara/poltergeist'

require 'diffa/participantdemo'

require_relative 'app_driver'
require_relative 'scan_client'

Capybara.javascript_driver = :poltergeist

describe "Application skeleton", :js => true do
  let (:app) { Diffa::ParticipantDemo.new }
  let (:driver) { Diffa::Test::AppDriver.new(app.rackapp) }
  let (:scan_client) { Diffa::Test::ScanClient.new(app.rackapp) }

  it "Can add a row and save it to the server" do
    grid = driver.reload_grid
    new_id = "Some identifier"
    new_version = "A dummy version"
    new_entity = {"id" => new_id, "version" => new_version}

    expect {
      driver.add_entity(new_entity)
      driver.save_to_server
    }.to change { scan_client.all_entities.size }.by(1)

    scan_client.last_scan.should include(new_entity)

    # Having kept a note of the old entries on the page.
    old_data = driver.grid
    old_data.should include("id" => new_id, "version" => new_version)

    # When I reload the page
    driver.reload_grid
    # Then the grid should be the same as the old data.
    driver.grid.should == old_data
  end
end
