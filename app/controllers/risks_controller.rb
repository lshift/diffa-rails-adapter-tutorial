class RisksController < ApplicationController
  def scan
    user = params[:user_id]
    pp user: user, params: params
    params = request.query_parameters.reject { |param, val| param == "authToken" }

    aggregation = Diffa::DateAggregation.new(user, 'trade_date', params, {
#      yearly: RisksTradeDateYearly,
#      monthly: RisksTradeDateMonthly,
#      daily: RisksTradeDateDaily,
      individual: RisksView,
    })
    render json: aggregation.scan
  end
end
