module PrivateIssues

  class Hook < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom,
              :partial => 'hooks/private_issues/view_issues_form_details_bottom'
    render_on :view_layouts_base_html_head, :partial => 'hooks/private_issues/html_head'
    render_on :view_layouts_base_body_bottom, :partial => 'hooks/private_issues/body_bottom'
  end
end