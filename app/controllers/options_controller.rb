class OptionsController < ApplicationController

  include UserAuthTokenVerifier

  def grid
    user = params[:user_id]
    options = Option.where(user_id: user)
    render json: options
  end

  # GET /options
  # GET /options.json

  def users_options
    Option.where(:user_id => params[:user_id])
  end
  def index *_
    @options = users_options

    render json: @options
  end

  # GET /options/1
  # GET /options/1.json
  def show *_
    @option = users_options.find(params[:id])

    respond_to do |format|
      format.json { render json: @option }
    end
  end

  # GET /options/new
  # GET /options/new.json
  def new
    @option = Option.new

    respond_to do |format|
      format.json { render json: @option }
    end
  end

  # GET /options/1/edit
  def edit
    @option = users_options.find(params[:id])
  end

  # POST /options
  # POST /options.json
  def create *_
    @option = Option.new(params[:option])
    @option.user_id = params[:user_id]

    respond_to do |format|
      if @option.save
        format.json { render json: @option }
      else
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /options/1
  # PUT /options/1.json
  def update *_
    @option = users_options.find(params[:id])

    respond_to do |format|
      if @option.update_attributes(params[:option])
        format.json { render json: @option }
      else
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /options/1
  # DELETE /options/1.json
  def destroy *_
    @option = users_options.find(params[:id])
    @option.destroy

    format.json { head :no_content }
  end
end
