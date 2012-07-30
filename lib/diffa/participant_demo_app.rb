require 'sinatra/base'
require 'json'
require 'liquid'

module Diffa
  class ParticipantDemoApp < Sinatra::Base
    set :raise_errors, true
    set :dump_errors, false
    set :show_exceptions, false

    def initialize(grid_store, nextapp=nil)
      super(nextapp)
      @grid_storage = grid_store
    end
    get '/' do
      redirect '/index.html'
    end

    post '/' do
      data = JSON.parse(request.body.read)
      @base.update(data)
      nil
    end

    get '/scan/:grid_id/entered_trades' do |grid_id|
      grid = @grid_storage.fetch Integer(grid_id)
      JSON.dump(grid.entered_trades)
    end

    get '/data' do
      JSON.dump(@base.query)
    end


    get '/grids/:id' do |id|
      id = Integer(id)
      @grid_storage.fetch(id)
      
      view_data =  { :grid_url => "/grids/%d/data" % [id] }
      liquid :grid, locals: view_data
    end


#    get /(.*)/ do |path|
#      fail "Hit wildcard route: #{path}"
#    end
  end
end
