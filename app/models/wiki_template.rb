class WikiTemplate < ActiveRecord::Base
  include Redmine::SafeAttributes

  unloadable

  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates :author_id, :presence => true
  validates :project_id, :presence => true
  validates :name, :presence => true

  scope :owned_by, ->(project_id) { where(:project_id => project_id) }
  scope :public, -> { where(:is_public => true) }
  scope :others_public, ->(project_id) { where("is_public = ? and project_id != ?", true, project_id) }

  safe_attributes 'name', 'text', 'is_public'
end
