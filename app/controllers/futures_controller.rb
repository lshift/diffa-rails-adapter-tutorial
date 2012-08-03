class FuturesController < ApplicationController
  def grid
    user = params[:user_id]
    futures = Future.where(user_id: user)
    render json: futures
  end

  def scan
    user = params[:user_id]
    risks = Future.where(user_id: user)
    render json: risks.to_json(only: [:id, :version])
  end

  # GET /futures
  # GET /futures.json
  def index
    @futures = Future.all

    respond_to do |format|
      format.json { render json: @futures }
    end
  end

  # GET /futures/1
  # GET /futures/1.json
  def show
    @future = Future.find(params[:id])

    respond_to do |format|
      format.json { render json: @future }
    end
  end

  # GET /futures/new
  # GET /futures/new.json
  def new
    @future = Future.new

    respond_to do |format|
      format.json { render json: @future }
    end
  end

  # GET /futures/1/edit
  def edit
    @future = Future.find(params[:id])
  end

  # POST /futures
  # POST /futures.json
  def create
    @future = Future.new(params[:future])

    respond_to do |format|
      if @future.save
        format.json { render json: @future, status: :created }
      else
        format.json { render json: @future.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /futures/1
  # PUT /futures/1.json
  def update
    @future = Future.find(params[:id])

    respond_to do |format|
      if @future.update_attributes(params[:future])
        format.json { head :no_content }
      else
        format.json { render json: @future.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /futures/1
  # DELETE /futures/1.json
  def destroy
    @future = Future.find(params[:id])
    @future.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
