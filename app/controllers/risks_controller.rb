require 'diffa/date_aggregation'

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


  def content
    pp content: params
    id_match =  /^0*(\d+)/.match(params[:identifier])

    if id_match
      trade = RisksView.find(id_match[1].to_i)
      render text: trade.attributes.map { |k, v| "#{k}=#{v}" }.join("\n")
    else
      render status: :not_found, text: "Item #{params[:identifier].inspect} Not found"
    end
  end


end
