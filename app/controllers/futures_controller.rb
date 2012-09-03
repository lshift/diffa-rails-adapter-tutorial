class FuturesController < ApplicationController


  # before_filter UserAuthTokenVerifier
  include UserAuthTokenVerifier

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

  def users_futures
    Future.where(:user_id => params[:user_id])
  end

  # GET /futures
  # GET /futures.json
  def index *_
    @futures = users_futures

    render json: @futures
  end

  # GET /futures/1
  # GET /futures/1.json
  def show *_
    @future = users_futures.find(params[:id])

    render json: @future
  end

  # GET /futures/new
  # GET /futures/new.json
  def new *_
    @future = Future.new
    render json: @future
  end

  # GET /futures/1/edit
  def edit *_
    @future = users_futures.find(params[:id])
  end

  # POST /futures
  # POST /futures.json
  def create *_
    @future = Future.new(params[:future])
    @future.user_id = params[:user_id]

    if @future.save
      render json: @future
    else
      render json: @future.errors, status: :unprocessable_entity
    end
  end

  # PUT /futures/1
  # PUT /futures/1.json
  def update *_
    @future = users_futures.find(params[:id])

    if @future.update_attributes(params[:future])
      render json: @future
    else
      render json: @future.errors, status: :unprocessable_entity
    end
  end

  # DELETE /futures/1
  # DELETE /futures/1.json
  def destroy *_
    @future = users_futures.find(params[:id])
    @future.destroy

    head :no_content
  end

  private 

end
