class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :create_admin, :create_agent, :create_customer, :assign_ticket]
  before_action :logged_in_user, only: [:index, :show, :edit ]
  before_action :correct_user, only: %i[destroy edit update]
  before_action :allow_only_admins, only: %i[index create_admin create_agent create_customer]

  include RedirectUsers

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_user

  def index
    @page_title = 'index'
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    return redirect_to tickets_url if logged_in?
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          log_in(@user)
          flash[:success] = 'Your account has been created successfully'
          return redirect_back_or(users_url)
        end
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { handle_redirect(@user,'User was successfully updated.', :success) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { handle_redirect(login_url, 'User was successfully destroyed.', :success) }
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

  def assign_ticket
    unassigned_ticket = Ticket.unassigned_ticket
    return handle_redirect(users_url, 'No unassigned ticket', :danger) if unassigned_ticket.nil?

    return handle_redirect(users_url, 'Customers cannot be assigned tickets', :danger) if @user.customer?

    @user_ticket = @user.user_tickets.build(ticket_id: unassigned_ticket.id)

    if @user_ticket.save
      unassigned_ticket.assign
      UserMailer.with(agent: @user, ticket: unassigned_ticket).ticket_assignment.deliver_later
      handle_redirect(users_url, 'A ticket is now assigned to this agent', :success)
    else
      handle_redirect(users_url, 'Operation failed', :danger)
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password,:password_confirmation, :email, :role)
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      handle_redirect(root_url, 'You cannot modify another user', :danger ) if current_user != @user
    end

  def invalid_user
    logger.error "Attempt to access invalid ticket #{params[:id]}"
    handle_redirect(users_url, "Invalid user", :danger)
  end
end
