module TicketsHelper
  def toggle_ticket_status(ticket)
    link_to_display = ''

    if  ticket.active?
      link_to_display = link_to 'Close Ticket', close_ticket_path(ticket), class: "text-light"
    else
      link_to_display = link_to 'Make Ticket Active', reopen_ticket_path(ticket), class: "text-light"
    end
    link_to_display
  end

  def build_csv_enumerator(header, data)
    Enumerator.new do |y|
      CsvBuilder.new(header, data, y).build
    end
  end

  def set_headers
    headers["X-Accel-Buffering"] = "no"
    headers["Cache-Control"] = "no-cache"
    headers["Content-Type"] = "text/csv; charset=utf-8"
    headers["Content-Disposition"] =
        %(attachment; filename="#{csv_filename}")
  end

  private
  def csv_filename
    "tickets-report-#{Time.zone.now.to_date.to_s(:default)}.csv"
  end
end
