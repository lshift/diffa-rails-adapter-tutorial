class ExpiryAggregation
  def initialize query_params
    @granularity = determine_granularity(query_params)

    entity_format = [:id, :version, :lastUpdated]
    aggregate_format = [:version, :attributes]
    @response_formats = {
      yearly: aggregate_format,
      monthly: aggregate_format,
      daily: aggregate_format,
      individual: entity_format
    }
    @aggregate_views = {
      yearly: TradesExpiryYearly,
      monthly: TradesExpiryMonthly,
      daily: TradesExpiryDaily,
      individual: TradesView,
    }
  end

  def scan(user)
    gran_sym = @granularity.to_sym
    @aggregate_views[gran_sym].find_all_by_user(user).to_json(only: @response_formats[gran_sym])
  end

  def determine_granularity(params)
    params.each do |param, val|
      if param == 'expiry-granularity'
        return val
      end
    end

    return 'individual'
  end
end

