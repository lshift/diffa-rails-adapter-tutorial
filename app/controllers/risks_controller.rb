class RisksController < ApplicationController
  def scan
    user = params[:id]
    pp user: user, params: params
    params = request.query_parameters.reject { |param, val| param == "authToken" }

    aggregation = Diffa::DateAggregation.new(user, 'expiry', params, {
#      yearly: RisksExpiryYearly,
#      monthly: RisksExpiryMonthly,
#      daily: RisksExpiryDaily,
      individual: RisksView,
    })
    render json: aggregation.scan
  end
end
