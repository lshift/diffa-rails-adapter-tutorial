class FuturesController < ApplicationController
  # GET /futures
  # GET /futures.json
  def index
    @futures = Future.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @futures }
    end
  end

  # GET /futures/1
  # GET /futures/1.json
  def show
    @future = Future.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @future }
    end
  end

  # GET /futures/new
  # GET /futures/new.json
  def new
    @future = Future.new

    respond_to do |format|
      format.html # new.html.erb
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
        format.html { redirect_to @future, notice: 'Future was successfully created.' }
        format.json { render json: @future, status: :created, location: @future }
      else
        format.html { render action: "new" }
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
        format.html { redirect_to @future, notice: 'Future was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
      format.html { redirect_to futures_url }
      format.json { head :no_content }
    end
  end
end
