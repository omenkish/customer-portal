class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :create_admin, :create_agent, :create_customer]
  # before_action :logged_in_user, only: %i[:index :show :edit ]
  # before_action :allow_only_admins, except: %i[:new :create, :destroy]

  include RedirectUsers
  # GET /users
  def index
    @page_title = 'index'
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { handle_redirect(@user, 'User was successfully created.', :success) }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { handle_redirect(@user,'User was successfully updated.', :success) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { handle_redirect(users_url, 'User was successfully destroyed.', :success) }
    end
  end

  def create_admin
    @page_title = 'index'
    return handle_redirect(users_url, 'This user is already an admin', :danger) if @user.admin?
    handle_redirect(users_url, 'User is now an admin', :success) if @user&.become_an_admin
  end

  def create_agent
    @page_title = 'index'
    return handle_redirect(users_url, 'This user is already an agent', :danger) if @user.agent?

    handle_redirect(users_url, 'This user is now an agent', :success) if @user&.become_an_agent
  end

  def create_customer
    @page_title = 'index'
    return handle_redirect(users_url, 'This user is already a customer', :danger) if @user.customer?

    handle_redirect(users_url, 'This user is now a customer', :success) if @user&.revoke_admin_or_agent_privilege
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password,:password_confirmation, :email, :role)
    end
end
