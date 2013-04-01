class ExtendSharingMode < ActiveRecord::Migration
  def up
    add_column :wiki_templates, :sharing, :string, :default => "none", :null => false
    execute "UPDATE wiki_templates SET sharing = 'system' WHERE is_public = true"
    remove_column :wiki_templates, :is_public
  end

  def down
    add_column :wiki_templates, :is_public, :boolean, :default => false, :null => false
    execute "UPDATE wiki_templates SET is_public = true WHERE sharing = 'system'"
    remove_column :wiki_templates, :sharing
  end
end
