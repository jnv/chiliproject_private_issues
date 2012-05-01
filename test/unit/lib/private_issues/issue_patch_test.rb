# -*- encoding : utf-8 -*-
require File.expand_path('../../../../test_helper', __FILE__)

require_dependency 'issue'
class PrivateIssues::IssueTestPatch < ActiveSupport::TestCase

  subject { Issue.new }

  # Based on WikiPageDropTest
  def setup
    @project = Project.generate!
    @issue = Issue.generate_for_project!(@project, {:private => true})
    User.current = @user = User.generate!
    @role = Role.generate!(:permissions => [:view_issues])
    Member.generate!(:principal => @user, :project => @project, :roles => [@role])
  end

  context "#visible?" do
    should "not be visible without permission" do
      assert @issue.private
      assert !@issue.visible?
    end

    should "be visible with permission" do
      @role.add_permission! :view_private_issues
      User.current.reload

      assert @issue.visible?
    end

    should "respect private pages in upper hierarchy" do
      @child = Issue.generate_for_project!(@project) do |issue|
        issue.parent_issue_id = @issue.id
      end
      assert !@child.visible?
    end

  end

end
