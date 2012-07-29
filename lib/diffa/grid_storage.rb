
require 'ostruct'

module Diffa
  class GridStorage
    def initialize
      @store = []
    end

    def provision properties
      theId = @store.length
      @store[theId] = OpenStruct.new(properties.merge(id: theId))
      theId
    end


    def fetch id
      @store[id]
    end
  end
end
