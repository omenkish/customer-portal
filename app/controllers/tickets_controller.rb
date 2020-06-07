class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show edit update destroy close_ticket make_ticket_active]

  include RedirectUsers

  def index
    @tickets = Ticket.recent
  end

  def show
  end

  def new
    @ticket = Ticket.new
  end

  def edit
  end

  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { handle_redirect(@ticket, 'Ticket was successfully created.', :success, :created) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { handle_redirect(@ticket, 'Ticket was successfully updated.', :success, :ok) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html {
        handle_redirect(tickets_url, 'Ticket was successfully deleted.', :ok)
      }
    end
  end

  def close_ticket
    return handle_redirect(tickets_url, "Ticket is already closed", :danger, 400) if @ticket.closed?
    @ticket.close
    handle_redirect(tickets_url, "Ticket closed successfully", :success, :ok)
  end

  def make_ticket_active
    return handle_redirect(tickets_url, "Ticket is already active", :danger, 400) if @ticket.active?
    @ticket.return_to_active
    handle_redirect(tickets_url, "Ticket is now active", :success, :ok)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ticket_params
    params.require(:ticket).permit(:title, :description, :status, :user_id)
  end
end
