module TicketsHelper
  def handle_redirect(path, message, response_type, status_code = 302)
    flash[response_type]= message
    redirect_to path, status: status_code
  end
end
