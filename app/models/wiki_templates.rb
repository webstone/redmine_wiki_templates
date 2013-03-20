class WikiTemplates < ActiveRecord::Base
  unloadable
  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  validates :author_id, :presence => true
  validates :name, :presence => true
end
