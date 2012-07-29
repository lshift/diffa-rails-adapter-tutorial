require 'diffa/grid_model'
require 'diffa/participant_demo_api'
require 'diffa/grid_storage'
require 'pp'

module Diffa
  class ParticipantDemo
    def apiapp
      @apiapp ||= ParticipantDemoAPI.new(grid_store)
    end

    def rackapp
      @rackapp ||= ParticipantDemoApp.new(grid_store, apiapp)
    end

    def model
      @model ||= Grid.new(default_data)
    end

    def data
      model.data
    end

    def grid_store
      @grid_store ||= GridStorage.new
    end

    def default_data
      [ { id: 'sample-id0', version: 'sample-version0' } ]
    end
  end
end
