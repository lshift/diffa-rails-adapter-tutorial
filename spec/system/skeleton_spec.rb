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

  # When I load up the page, Then I should see a {trade entry,futures risk, options risk} grid
  describe "a grid page" do
    let (:page) { driver.reload_grid }
    it "Displays three grids" do
      page.should have_grid(:trade_entry)
      page.should have_grid(:futures_risk)
      page.should have_grid(:options_risk)
    end
  end

  it "Can add a row and save it to the server" do
    pending "Move Details to more focussed tests."
    grid = driver.reload_grid
    new_id = "Some identifier"
    new_version = "A dummy version"
    new_entity = {"id" => new_id, "version" => new_version}

    expect {
      grid.add_entity(new_entity)
      grid.save_to_server
    }.to change { scan_client.all_entities.size }.by(1)

    scan_client.last_scan.should include(new_entity)

    # Having kept a note of the old entries on the page.
    old_data = grid.data
    old_data.should include("id" => new_id, "version" => new_version)

    # When I reload the page
    reloaded_grid = driver.reload_grid
    # Then the grid should be the same as the old data.
    Set.new(reloaded_grid.data).should == Set.new(old_data)
  end


  it "allows the creation of multiple independant participants" do
    # I should be able to create multiple grids
    pending "Pending recreation for trading scenario."
    # Delegate /management from the participant demo app to the api app.
    # Why did I do that?
    upstream = driver.create_grid("Her Upstream")
    downstream = driver.create_grid("My Downstream")

    upstream.grid_page.title.should == "Her Upstream"
    downstream.grid_page.title.should == "My Downstream"
  end
end
