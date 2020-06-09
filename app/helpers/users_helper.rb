module UsersHelper
  def admin_actions_helper(user)
    role_buttons = {
        'admin': (link_to 'Make Agent', agent_user_path(user), class: 'btn btn-outline-secondary btn-sm') +
            ' '.html_safe +
            (link_to 'Make Customer', agent_user_path(user), class: 'btn btn-outline-info btn-sm'),
        'agent': (link_to 'Make Admin', customer_user_path(user), class: 'btn btn-outline-secondary btn-sm') +
            ' '.html_safe +
            (link_to 'Make Customer', customer_user_path(user), class: 'btn btn-outline-success btn-sm'),
        'customer': (link_to 'Make Admin', admin_user_path(user), class: 'btn btn-outline-info btn-sm') +
            ' '.html_safe +
            (link_to 'Make Agent', agent_user_path(user), class: 'btn btn-outline-success btn-sm')
    }

    # Admin should not be able to modify his own role
    role_buttons[:"#{user.role}"].html_safe unless user == current_user
  end
end
