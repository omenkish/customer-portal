class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show edit update destroy close_ticket reopen_ticket]
  before_action :logged_in_user, only: %i[index new create destroy close_ticket reopen_ticket tickets_report]
  before_action :correct_user, only: %i[destroy edit update]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_ticket

  include CsvStreamBuilderHelper

  def index
    if current_user.customer?
      return @tickets = current_user.tickets.recent.page(params[:page]).per(5)
    end
    @page_title = 'index' if current_user.admin?
    @tickets = Ticket.recent.page(params[:page]).per(5)
  end

  def show
    #Fetch ticket with its comments
    @ticket = Ticket.includes(:comments).find(params[:id])

    # Instantiate comment
    @comment = Comment.new
  end

  def new
    @ticket = Ticket.new
  end

  def edit
  end

  def create
    @ticket = current_user.tickets.build(ticket_params)
    if @ticket.save
      flash[:success] = "Your ticket has been created. We will get back to you as soon as possible"
      return redirect_to tickets_url
    end

    render "new"
  end

  def update
    if @ticket.update(ticket_params)
      flash[:success] = "Ticket was successfully updated."
      return redirect_to @ticket
    end
    render "edit"
  end

  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html {
        handle_redirect(tickets_url, "Ticket was successfully deleted.", :success)
      }
    end
  end

  def close_ticket
    return handle_redirect(tickets_url, "This ticket is already closed", :danger) if @ticket.closed?

    return handle_redirect(tickets_url, "You cannot perform this action", :danger) if current_user.customer?
    if @ticket.close
      UserMailer.with(ticket: @ticket).ticket_resolution.deliver_later
      handle_redirect(request.referer || tickets_url, "Ticket closed successfully", :success)
    end
  end

  def reopen_ticket
    return handle_redirect(tickets_url, "This ticket is already active", :danger) if @ticket.active?

    return handle_redirect(tickets_url, "You cannot perform this action", :danger) if current_user.customer?
    @ticket.reopen
    handle_redirect(request.referer || tickets_url, "Ticket is now active", :success)
  end

  def tickets_report
    @tickets = Ticket.closed_since_last_month

    respond_to do |format|
      format.html { redirect_to "/not-found"}
      format.csv do
        header = ['Id', 'Title', 'Description', 'Status', 'Closed At', 'User Id', 'Date Created']
        self.response_body = build_csv_enumerator(header, @tickets)
      end
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :status, :user_id)
  end

  def invalid_ticket
    logger.error "Attempt to access invalid ticket #{params[:id]}"
    handle_redirect(tickets_url, "Invalid ticket", :danger)
  end

  # check if the user trying to perform an action is the owner of the ticket
  def correct_user
    @ticket = current_user&.tickets.find_by(id: params[:id])
    handle_redirect(root_url, 'Only the owner of a ticket can modify it', :danger ) if @ticket.nil?
  end

  def handle_redirect(path, msg, response_type)
    flash[response_type] = msg
    redirect_to path
  end
end
