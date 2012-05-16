module PrivateIssues
  module QueryPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable

        alias_method_chain :statement, :private_issues

      end
    end


    module InstanceMethods
      def statement_with_private_issues
        filters_clauses = statement_without_private_issues

        user = User.current
        unless project && user.allowed_to?(:view_private_issues, project)
          filters_clauses << " AND (issues.private = #{connection.quoted_false} OR issues.author_id = #{user.id} OR issues.assigned_to_id = #{user.id})"
        end
        filters_clauses
      end
    end

  end
end