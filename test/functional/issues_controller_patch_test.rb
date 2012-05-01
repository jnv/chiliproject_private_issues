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

  end
end