class UserMailer < ApplicationMailer
  def ticket_resolution
    @ticket = params[:ticket]

    mail to: @ticket.user.email, subject: "Ticket Resolution"
  end

  def ticket_assignment
    @ticket = params[:ticket]
    @agent = params[:agent]

    mail to: @agent.email, subject: "Ticket Assignment"
  end
end
