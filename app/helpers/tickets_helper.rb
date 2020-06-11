module TicketsHelper
  def toggle_ticket_status(ticket)
    link_to_display = ''

    if  ticket.active?
      link_to_display = link_to 'Mark As Resolved', close_ticket_path(ticket), class: "text-light"
    else
      link_to_display = link_to 'Re-Open Ticket', reopen_ticket_path(ticket), class: "text-light"
    end
    link_to_display
  end
end
