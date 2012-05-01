class AddPrivateToIssues < ActiveRecord::Migration
 
  def self.up
    add_column :issues, :private, :boolean, :default => false)
  end

  def self.down
    remove_column(:issues, :private
  end
end
