class UserTicketsController < ApplicationController
  def index
    return redirect_to tickets_url if current_user.customer?

    return @user_tickets = current_user.user_tickets.page(params[:page]).per(5) if current_user&.agent?

    @user_tickets = UserTicket.all.page(params[:page]).per(5)
  end

end
