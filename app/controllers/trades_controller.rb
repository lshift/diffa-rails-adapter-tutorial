require "diffa/date_aggregation"

class TradesController < ApplicationController

  def propagate
    t = TradesView.where(:user => params[:user_id]).find(params[:trade_id])
    future = Future.find_by_trade_id(t.id) || Future.new
    future.update_attributes(quantity: t.quantity, expiry: t.expiry, entered_at: t.entered_at,
                        price: t.price, direction: t.direction)

    future.trade_id = t.id
    future.version = t.version
    future.user_id = t.user
    future.version = t.version
    future.save!
    render json: future
  end

  def grid
    user = params[:user_id]
    trades = TradesView.where(:user => user)
    render json: trades
  end

  def scan
    user = params[:id]
    pp user: user, params: params
    params = request.query_parameters.reject { |param, val| param == "authToken" }

    aggregation = Diffa::DateAggregation.new(user, 'expiry', params, {
      yearly: TradesExpiryYearly,
      monthly: TradesExpiryMonthly,
      daily: TradesExpiryDaily,
      individual: TradesView,
    })
    render json: aggregation.scan
  end

  # GET /trades
  # GET /trades.json
  def index *_
    @trades = TradesView.where(:user => params[:user_id])

    render json: @trades
  end

  # GET /trades/1
  # GET /trades/1.json
  def show
    @trade = TradesView.find(params[:id])

    # using render: @trade assumes that there is a route named trade_path,
    render json: @trade
  end

  # GET /trades/new
  # GET /trades/new.json
  def new
    @trade = Trade.new

    render json: @trade
  end

  # GET /trades/1/edit
  def edit
    @trade = Trade.find(params[:id])
  end

  # POST /trades
  # POST /trades.json
  def create *args
    @user = User.find(params[:user_id])
    @trade = Trade.new(params[:trade])
    @trade.user_id = @user.id

    if @trade.save
      render json: @trade, status: :created, location: user_trade_path(@user, @trade)
    else
      render action: "new"
    end
  end

  # PUT /trades/1
  # PUT /trades/1.json
  def update*args
    pp args: args

    @trade = Trade.find(params[:id])

    if @trade.update_attributes(params[:trade])
      head :no_content
    else
      render json: @trade.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trades/1
  # DELETE /trades/1.json
  def destroy*args
    pp args: args

    @trade = Trade.find(params[:id])
    @trade.destroy

    head :no_content
  end
end
