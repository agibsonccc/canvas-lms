class AddExternalToolFlags < ActiveRecord::Migration
  def self.up
    add_column :context_external_tools, :has_user_navigation, :boolean
    add_column :context_external_tools, :has_course_navigation, :boolean
    add_column :context_external_tools, :has_account_navigation, :boolean
    add_column :context_external_tools, :has_resource_selection, :boolean
    add_column :context_external_tools, :has_editor_button, :boolean
    add_index :context_external_tools, [:context_id, :context_type, :has_user_navigation]
    add_index :context_external_tools, [:context_id, :context_type, :has_course_navigation]
    add_index :context_external_tools, [:context_id, :context_type, :has_account_navigation]
    add_index :context_external_tools, [:context_id, :context_type, :has_resource_selection]
    add_index :context_external_tools, [:context_id, :context_type, :has_editor_button]
  end

  def self.down
    remove_column :context_external_tools, :has_user_navigation
    remove_column :context_external_tools, :has_course_navigation
    remove_column :context_external_tools, :has_account_navigation
    remove_column :context_external_tools, :has_resource_selection
    remove_column :context_external_tools, :has_editor_button
    remove_index :context_external_tools, [:context_id, :context_type, :has_user_navigation]
    remove_index :context_external_tools, [:context_id, :context_type, :has_course_navigation]
    remove_index :context_external_tools, [:context_id, :context_type, :has_account_navigation]
    remove_index :context_external_tools, [:context_id, :context_type, :has_resource_selection]
    remove_index :context_external_tools, [:context_id, :context_type, :has_editor_button]
  end
end
