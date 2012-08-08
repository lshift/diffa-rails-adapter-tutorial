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
  def index *_
    @futures = Future.all

    render json: @futures
  end

  # GET /futures/1
  # GET /futures/1.json
  def show *_
    @future = Future.find(params[:id])

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
    @future = Future.find(params[:id])
  end

  # POST /futures
  # POST /futures.json
  def create *_
    @future = Future.new(params[:future])

    if @future.save
      render json: @future, status: :created
    else
      render json: @future.errors, status: :unprocessable_entity
    end
  end

  # PUT /futures/1
  # PUT /futures/1.json
  def update *_
    @future = Future.find(params[:id])

    if @future.update_attributes(params[:future])
      head :no_content
    else
      render json: @future.errors, status: :unprocessable_entity
    end
  end

  # DELETE /futures/1
  # DELETE /futures/1.json
  def destroy *_
    @future = Future.find(params[:id])
    @future.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
