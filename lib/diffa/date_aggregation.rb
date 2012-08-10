require 'delegate'
module Diffa
  class DateAggregation
    def initialize(user, attr_name, query_params, view_map)
      @user = user
      @granularity = determine_granularity(attr_name, query_params)
      @constraints = {text: 'user = ?', vars: [@user]}
      @constraints = add_constraints(attr_name, query_params, @constraints)
      @aggregate_views = view_map

      entity_format = [:id, :attributes, :version, :lastUpdated]
      aggregate_format = [:attributes, :version]
      @response_formats = {
        yearly: aggregate_format,
        monthly: aggregate_format,
        daily: aggregate_format,
        individual: entity_format
      }
    end

    class FixedWidthIdFormat < SimpleDelegator
      def id_formatted; "%08d" % [id]; end

      def as_json options={}
        super(options).merge('id' => id_formatted)
      end

    end

    def scan
      g = @granularity.to_sym
      where_text = @constraints[:text]
      where_vars = @constraints[:vars]
      entities= @aggregate_views[g].where(where_text, *where_vars).order(:id)
      entities.map { |e| FixedWidthIdFormat.new(e) }.to_json(only: @response_formats[g])
    end

    def add_constraints(attr_name, params, constraints)
      params.each do |param, val|
        if param == attr_name + '-start'
          constraints[:text].concat(' and ' + attr_name + ' >= ?')
          constraints[:vars].append(val)
        elsif param == attr_name + '-end'
          constraints[:text].concat(' and ' + attr_name + ' < ?')
          constraints[:vars].append(val)
        end
      end

      return constraints
    end

    private
    def determine_granularity(attr_name, params)
      params.each do |param, val|
        if param == attr_name + '-granularity'
          return val
        end
      end

      return 'individual'
    end
  end
end

