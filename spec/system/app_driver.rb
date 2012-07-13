require 'capybara'
require 'capybara/dsl'

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
        session.somethingihaventfiguredoutyet
      end

      private
      def session
        @session ||= Capybara::Session.new(:poltergeist, @app)
      end
    end
  end
end
