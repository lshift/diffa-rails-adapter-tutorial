require 'demo_environment'
require 'diffa/token_generator'

class UsersController < ApplicationController


  # POST /users
  # POST /users.json
  def create
    token = request.query_parameters['authToken']
    if not token.nil? and token == DemoEnvironment::AUTH_TOKEN
      user_token = Diffa::TokenGenerator.generate
      user = User.new(auth_token: user_token)

      if user.save
        render json: user.to_json(only: [:id, :auth_token]), status: :created
      else
        render json: user.errors, status: :unprocessable_entity
      end
    else
      render text: "You are not permitted to create this resource", status: :unauthorized
    end
  end

  def grids *args
    @user = User.find(params[:id])
    render status: :unauthorized, text: "Unauthorized" unless @user.correct_token?(params[:authToken])
  end

  private
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

end
