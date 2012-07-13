require 'sinatra/base'

module Diffa
  class ParticipantDemo < Sinatra::Base

    get '/' do
      redirect '/index.html'
    end
  end
end
