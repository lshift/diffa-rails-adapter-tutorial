require 'sinatra/base'

module Diffa
  class ParticipantDemo < Sinatra::Base

    get '/' do
      'Diffa participant Grid'
    end
  end
end
