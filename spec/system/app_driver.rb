require 'capybara'
require 'capybara/dsl'
require 'ostruct'

require 'pp'

module Diffa
  module Test
    class AppDriver

      def initialize(app)
        @app = app
      end

    def reload_grid(options={})
      GridPage.new(@app, options)
    end


    def create_grid(name)
      api.create_grid(name)
    end

    def api
      @api ||= Diffa::Test::DemoAPI.new(@app)
    end
  end

  class DemoAPI 
    def initialize(rackapp)
      @client = Rack::Test::Session.new(rackapp)
    end
    
    def create_grid(name)
      response = @client.post("/grids", JSON.dump(name: name))
      OpenStruct.new(JSON.parse(response.body))
    end
  end

  class GridPage
    include RSpec::Matchers
    GRID_HEADINGS = ["id", "version"]
    # Yes, this is quite nasty. --CS
    CANCEL_EDIT_JS = 'var e = jQuery.Event("keydown"); e.which = $.ui.keyCode.ENTER; $("input").trigger(e); e.which = $.ui.keyCode.ESCAPE; $("input").trigger(e);'

    def initialize(app, options={})
      @app = app
      url = options.fetch(:url)
      pp options
      session.visit(url)
      begin
        session.should have_content("Diffa participant Grid")
      rescue RSpec::Expectations::ExpectationNotMetError
        print session.html
        raise 
      end
    end

    def screenshot
      session.driver.render('root.png', :full => true)
    end


    def has_grid?(name)
      # At this point in time, it's probably not worth test-driving the UI,
      # as there's not much to be designed. That may change.

      # So just work on a happy assumption.
      session.should have_selector('#grid_%s.-rendered' % [name])
    rescue
      print session.html
      raise
    end

    def save_to_server
      session.click_button('save')
      session.find('#status').find('.done')
    end

    def data
#        session.within('#myGrid') do
#          session.all('.slick-row').map do |row|
#            cell_values = row.all('.slick-cell').tap { |r| pp :row_cells => r }.map(&:text)
#            pp :row => cell_values
#          end
#        end

      session.driver.evaluate_script('Diffa.data')
    end

    def add_entity(entity_hash)
      session.click_button('addRow')
      last_row = session.all('.slick-row').last
      last_row_cells = last_row.all('.slick-cell') # .map { |e| e.text.strip }
      
      GRID_HEADINGS.zip(last_row_cells).each do |(heading, cell)|
        cell.click
        cell.find('input').set(entity_hash.fetch(heading))
      end
      session.driver.execute_script(CANCEL_EDIT_JS);
    end

    private
    def session
      @session ||= Capybara::Session.new(:poltergeist, @app)
    end
  end
end
end
