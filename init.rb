# -*- encoding : utf-8 -*-
require 'redmine'
require 'dispatcher'
require_dependency 'private_issues/hook'
Dispatcher.to_prepare :chiliproject_private_issues do
  require_dependency 'issue'
  unless Issue.included_modules.include? PrivateIssues::IssuePatch
    Issue.send(:include, PrivateIssues::IssuePatch)
  end

  require_dependency 'query'
  unless Query.included_modules.include? PrivateIssues::QueryPatch
    Query.send(:include, PrivateIssues::QueryPatch)
  end

  require_dependency 'issues_controller'
  unless IssuesController.included_modules.include? PrivateIssues::IssuesControllerPatch
    IssuesController.send(:include, PrivateIssues::IssuesControllerPatch)
  end
end

Redmine::Plugin.register :chiliproject_private_issues do
  name 'Private Issues'
  author 'Jan Vlnas'
  description 'Allows individual issues to be set as private'
  version '0.0.1'
  url 'https://github.com/jnv/chiliproject_private_issues'
  author_url 'https://github.com/jnv'


  project_module :issue_tracking do
    permission :view_private_issues, {}
    permission :manage_private_issues, {}, :require => :member
  end
end
