require 'capybara'
require 'capybara/dsl'

require 'pp'

module Diffa
  module Test
    class AppDriver
      include RSpec::Matchers

      def initialize(app)
        @app = app
      end


      def show_grid
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
          rows = session.all('.slick-row')
          rows.map do |row|
            row.all('.slick-cell').map do |elt|
              elt.text
            end
          end
        end
      end


      def add_entity(row)
        session.click_button('addRow')
        last_row = session.all('.slick-row').last
        last_row_cells = last_row.all('.slick-cell') # .map { |e| e.text.strip }
        last_row_cells.zip(row).each do |(cell, content)|
          cell.click
          cell.find('input').set(content)
        end
        last_row_cells[0].click
      end

      private
      def session
        @session ||= Capybara::Session.new(:poltergeist, @app)
      end
    end
  end
end
