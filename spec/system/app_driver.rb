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


      def grid
        session.within('#myGrid') do
          rows = session.all('.slick-row')
          rows.map do |row|
            row.all('.slick-cell').map do |elt|
              elt.text
            end
          end
        end
      end

      private
      def session
        @session ||= Capybara::Session.new(:poltergeist, @app)
      end
    end
  end
end
