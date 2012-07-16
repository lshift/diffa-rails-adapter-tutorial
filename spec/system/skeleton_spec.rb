require 'rspec'

require 'capybara/rspec'
require 'capybara/poltergeist'

require 'diffa/participantdemo'

require_relative 'app_driver'

Capybara.javascript_driver = :poltergeist

describe "Application skeleton", :js => true do
  let (:app) { Diffa::ParticipantDemo.new }
  let (:driver) { Diffa::Test::AppDriver.new(app.rackapp) }
  let (:scan_client) { Diffa::Test::ScanClient.new(app.rackapp) }

  it "Can add a row and save it to the server" do
    driver.show_grid
    new_row = ["Some identifier", "A dummy version"]
    headers = ["id", "version"]

    expect {
      driver.add_entity(new_row)
      driver.save_to_server
    }.to change { app.data.size }.by(1)

    app.data.last.should == Hash[*headers.zip(new_row).flatten]
  end
end
