module Diffa
  class Grid
    attr_reader :data

    def initialize data
      @data = data
    end

    def update newval
      @data = newval
    end

    def query
      data.sort_by { |entity| entity['id'] }
    end
  end
end
