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
        File.open('page.html', 'w') do |f| f.write session.html; end
        session.should have_content("Diffa participant Grid")
      end

      def screenshot
        session.driver.render('root.png', :full => true)
      end

      private
      def session
        @session ||= Capybara::Session.new(:poltergeist, @app)
      end
    end
  end
end
