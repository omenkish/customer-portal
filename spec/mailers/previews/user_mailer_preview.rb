# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def ticket_resolution
    # Set up a temporary order for the preview
    ticket = Ticket.first

    UserMailer.with(ticket: ticket).ticket_resolution
  end

  def ticket_assignment
    # Set up a temporary order for the preview
    ticket = Ticket.first
    agent = User.last
    UserMailer.with(agent: agent, ticket: ticket).ticket_assignment
  end

end
