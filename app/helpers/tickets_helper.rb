module TicketsHelper
  def toggle_ticket_status(ticket)
    return if current_user.customer?
    link_to_display = ''

    if  ticket.active?
      link_to_display = link_to 'Mark As Resolved', close_ticket_path(ticket), class: "btn btn-sm btn-dark"
    else
      link_to_display = link_to 'Re-Open Ticket', reopen_ticket_path(ticket), class:"btn btn-sm btn-dark"
    end
    link_to_display
  end

  def display_csv_button(tickets)
    if !current_user.customer? && tickets.any?(&:closed?)
      link_to "Download CSV", tickets_report_path(format: "csv"), { class: "btn btn-dark mb-4 offset-9" }
    end
  end
end
