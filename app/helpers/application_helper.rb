module ApplicationHelper
  def nav_helper
    admin_link = ''
    nav_links = ''
    if logged_in?
      admin_link = link_to 'Users', users_path, class: 'p-2 text-dark' if current_user.admin?
      nav_links = "#{link_to 'Tickets', tickets_url, class: 'p-2 text-dark'} #{admin_link}"
    else
      nav_links = login_helper
    end

    nav_links.html_safe
  end

  private

  def login_helper
    (link_to 'Login', login_path, class: 'btn btn-outline-dark') +
        ' '.html_safe +
        (link_to 'Sign up', register_path, class: 'btn btn-outline-info')
  end
end
