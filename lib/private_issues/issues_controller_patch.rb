module PrivateIssues
  module IssuesControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable

        alias_method_chain :find_issue, :private_issues
      end
    end

    module InstanceMethods

      private

      def find_issue_with_private_issues
        find_issue_without_private_issues
        if @issue && @issue.private_with_ancestors && !@issue.private_issue_visible?(@project, User.current)
          deny_access
        end
      end


    end
  end
end