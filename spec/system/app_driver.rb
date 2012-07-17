require 'capybara'
require 'capybara/dsl'

require 'pp'

module Diffa
  module Test
    class AppDriver
      GRID_HEADINGS = ["id", "version"]


      # Yes, this is quite nasty. --CS
      CANCEL_EDIT_JS = 'var e = jQuery.Event("keydown"); e.which = $.ui.keyCode.ENTER; $("input").trigger(e); e.which = $.ui.keyCode.ESCAPE; $("input").trigger(e);'
      include RSpec::Matchers

      def initialize(app)
        @app = app
      end

      def reload_grid
        session.visit('/')
        session.should have_content("Diffa participant Grid")
      end

      def screenshot
        session.driver.render('root.png', :full => true)
      end

      def save_to_server
        session.click_button('save')
        session.find('#status').find('.done')
      end

      def grid
        pp :window_data => session.driver.evaluate_script('Diffa.data');
        session.within('#myGrid') do
          session.all('.slick-row').map do |row|
            # cell_values = row.all('.slick-cell').map(&:text)
            pp :row => cell_values
            Hash[*GRID_HEADINGS.zip(cell_values).flatten]
          end
        end
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
