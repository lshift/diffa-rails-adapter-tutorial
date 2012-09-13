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

    render json: @option
  end

  # GET /options/new
  # GET /options/new.json
  def new
    @option = Option.new

    render json: @option
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

    if @option.save
      render json: @option
    else
      render json: @option.errors, status: :unprocessable_entity
    end
  end

  # PUT /options/1
  # PUT /options/1.json
  def update *_
    @option = users_options.find(params[:id])

    if @option.update_attributes(params[:option])
      render json: @option
    else
      render json: @option.errors, status: :unprocessable_entity
    end
  end

  # DELETE /options/1
  # DELETE /options/1.json
  def destroy *_
    @option = users_options.find(params[:id])
    @option.destroy

    head :no_content
  end
end
