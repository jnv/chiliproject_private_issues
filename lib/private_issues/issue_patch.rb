module PrivateIssues
  module IssuePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable

        named_scope :nonprivate_only, :conditions => {:private => false}
        #alias_method_chain :visible?, :private_issues

        safe_attributes 'private',
                        :if => lambda { |issue, user| user.allowed_to?(:manage_private_issues, issue.project) }
      end
    end

    module InstanceMethods
      #def private_with_ancestors
      #  self.private || ancestors.detect { |anc| anc.private }
      #end
      #
      #def private_issue_visible?(project, user)
      #  !user.nil? && user.allowed_to?(:view_private_issues, project)
      #end
      #
      #def visible_with_private_issues?(user=User.current)
      #  allowed = visible_without_private_issues?(user)
      #  if allowed and self.private_with_ancestors
      #    return private_page_visible?(project, user)
      #  end
      #  allowed
      #end

    end
  end
end