module Diffa
  class GridModel
    attr_reader :data

    def initialize data
      @data = data
    end

    def update newval
      @data = newval
    end
  end
end
