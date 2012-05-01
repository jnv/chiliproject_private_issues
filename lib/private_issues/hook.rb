module PrivateIssues

  class Hook < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom,
              :partial => 'hooks/private_issues/view_issues_form_details_bottom'
  end
end