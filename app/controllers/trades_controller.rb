require "diffa/date_aggregation"

class TradesController < ApplicationController
  def propagate
    t = TradesView.where(:user => params[:user_id]).find(params[:trade_id])
    future = Future.new(version: t.version, user_id: t.user,
                        quantity: t.quantity, expiry: t.expiry, entered_at: t.entered_at,
                        price: t.price, direction: t.direction)
    future.id = t.id
    future.save
    render json: future
  end

  def grid
    user = params[:user_id]
    trades = TradesView.where(:user => user)
    render json: trades
  end

  def scan
    user = params[:user_id]
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
  def index
    @trades = TradesView.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trades }
    end
  end

  # GET /trades/1
  # GET /trades/1.json
  def show
    @trade = TradesView.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trade }
    end
  end

  # GET /trades/new
  # GET /trades/new.json
  def new
    @trade = Trade.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trade }
    end
  end

  # GET /trades/1/edit
  def edit
    @trade = Trade.find(params[:id])
  end

  # POST /trades
  # POST /trades.json
  def create
    @trade = Trade.new(params[:trade])

    respond_to do |format|
      if @trade.save
        format.html { redirect_to @trade, notice: 'Trade was successfully created.' }
        format.json { render json: @trade, status: :created, location: @trade }
      else
        format.html { render action: "new" }
        format.json { render json: @trade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trades/1
  # PUT /trades/1.json
  def update
    @trade = Trade.find(params[:id])

    respond_to do |format|
      if @trade.update_attributes(params[:trade])
        format.html { redirect_to @trade, notice: 'Trade was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trades/1
  # DELETE /trades/1.json
  def destroy
    @trade = Trade.find(params[:id])
    @trade.destroy

    respond_to do |format|
      format.html { redirect_to trades_url }
      format.json { head :no_content }
    end
  end
end
