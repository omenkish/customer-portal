class UserTicket < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  delegate :title, :description, :assigned, :status, :ticket_date, :ticket_owner, to: :ticket, prefix: :ticket

  def ticket_date
    ticket.created_at
  end

  def ticket_owner
    ticket.user.name
  end
end
