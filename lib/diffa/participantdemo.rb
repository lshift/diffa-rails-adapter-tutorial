require 'sinatra/base'
require 'json'
require 'diffa/grid_model'

require 'pp'

module Diffa
  class ParticipantDemoApp < Sinatra::Base
    set :raise_errors, true
    set :dump_errors, false
    set :show_exceptions, false

    def initialize data
      super()
      @base = data
    end
    get '/' do
      redirect '/index.html'
    end

    post '/' do
      data = JSON.parse(request.body.read)
      @base.update(data)
      nil
    end
  end
  
  class ParticipantDemo
    def rackapp
      @rackapp ||= ParticipantDemoApp.new(model)
    end

    def model
      @model ||= GridModel.new(default_data)
    end

    def data
      model.data
    end

    def default_data
      [ { id: 'sample-id0', version: 'sample-version0' } ]
    end
  end
end
