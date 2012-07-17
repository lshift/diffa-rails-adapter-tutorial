require 'rack/test'
require 'json'

module Diffa
  module Test
    class ScanClient
      include RSpec::Matchers

      attr_reader :last_scan
      def initialize app
        @session = Rack::Test::Session.new(app)
      end

      def all_entities
        resp = @session.get('/scan')
        throw "Unexpected response status on scan: %s" % [resp.status] unless resp.status == 200
        @last_scan = JSON.parse resp.body
        @last_scan.should == @last_scan.sort_by { |e| e["id"] }
        @last_scan
      end
    end
  end
end
