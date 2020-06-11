module ApplicationHelper
  def nav_helper
    admin_link = ''
    nav_links = ''
    if logged_in?
      nav_links += "#{link_to 'Home', tickets_url, class: 'p-2 text-dark'} #{admin_link}"
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

  def sidebar_items
    [
      {
        url: users_path,
        title: 'Users'
      },
      {
        url: tickets_path,
        title: 'Tickets'
      },
    ]
  end

  def sidebar_helper(tag_style:, tag_name:, a_tag_style:)
    nav_links = ''
    sidebar_items.each do |item|
      nav_links << "<#{tag_name} class='#{tag_style}'><a href='#{item[:url]}' class='#{a_tag_style} #{active? item[:url]}'>
      #{item[:title]}</a></#{tag_name}>"
    end

    nav_links.html_safe
  end

  def active? path
    'active' if current_page? path
  end

  def render_empty_page(resource)
    content = {
        'user': ("<p>No  #{resource.capitalize}s found. Please create #{link_to 'One', users_path}</p>").html_safe,
        'ticket': ("<p>No  #{resource.capitalize}s found. Please create #{link_to 'One', tickets_path}</p>").html_safe
    }

    content[:"#{resource}"]
  end
end
