# -*- encoding : utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

# Reuse the default test
require File.expand_path('test/functional/issues_controller_test', RAILS_ROOT)

class IssuesControllerTest < ActionController::TestCase

  fixtures :all

  context "PrivateIssuesPlugin" do
    setup do
      @project = Project.find(1)
      @request.session[:user_id] = 2
    end

    context "view hook" do
      context "with manage permission" do
        setup do
          Role.find(1).add_permission! :manage_private_issues
          get :new, :project_id => @project, :tracker_id => 1
        end
        should_respond_with :success
        should_render_template :new
        should "render private checkbox" do
          assert_tag :tag => 'input', :attributes => {:name => 'issue[private]',
                                                      :type => 'checkbox',
                                                      :checked => nil}
        end
      end

      context "without manage permission" do
        setup do
          get :new, :project_id => @project, :tracker_id => 1
        end

        should_respond_with :success
        should_render_template :new
        should "render private checkbox" do
          assert_no_tag :tag => 'input', :attributes => {:name => 'issue[private]',
                                                         :type => 'checkbox',
                                                         :checked => nil}
        end
      end
    end

    context "POST create" do
      context "without permission" do

        setup do
          post :create, :project_id => @project.id,
               :issue => {:tracker_id => 3,
                          :status_id => 2,
                          :subject => 'This is the test_new issue',
                          :description => 'This is the description',
                          :priority_id => 5,
                          :start_date => '2010-11-07',
                          :estimated_hours => '',
                          :custom_field_values => {'2' => 'Value for field 2'},
                          :private => '1'}
        end

        should "not create private issue" do
          assert !Issue.last.private
        end

      end

      context "with permission" do
        setup do
          Role.find(1).add_permission! :manage_private_issues
          post :create, :project_id => @project.id,
               :issue => {:tracker_id => 3,
                          :status_id => 2,
                          :subject => 'This is the test_new issue',
                          :description => 'This is the description',
                          :priority_id => 5,
                          :start_date => '2010-11-07',
                          :estimated_hours => '',
                          :custom_field_values => {'2' => 'Value for field 2'},
                          :private => '1'}
        end

        should "redirect to issue" do
          assert_redirected_to :controller => 'issues', :action => 'show', :id => Issue.last.id
        end

        should "mark issue as private" do
          assert Issue.last.private
        end
      end
    end

  end
end