module Diffa
  class GridModel
    attr_reader :data

    def initialize data
      @data = data
    end

    def update newval
      @data = newval
    end

    def query; data; end
  end
end
