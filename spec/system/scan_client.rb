require 'rack/test'
require 'json'

module Diffa
  module Test
    class ScanClient

      attr_reader :last_scan
      def initialize app
        @session = Rack::Test::Session.new(app)
      end

      def all_entities
        resp = @session.get('/scan')
        throw "Unexpected response status on scan: %s" % [resp.status] unless resp.status == 200
        @last_scan = JSON.parse resp.body
      end
    end
  end
end
