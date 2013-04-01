class WikiTemplate < ActiveRecord::Base
  include Redmine::SafeAttributes

  unloadable

  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  WIKI_TEMPLATE_SHARINGS = %w(none descendants system)

  validates :author_id, :presence => true
  validates :project_id, :presence => true
  validates :name, :presence => true
  validates_inclusion_of :sharing, :in => WIKI_TEMPLATE_SHARINGS

  scope :owned_by, ->(project_id) { where(:project_id => project_id) }
  scope :others_available, ->(project_id) {
    where("sharing = 'system' AND project_id != ?", project_id)
  }
  scope :sort_by_name, -> { order("name ASC") }
  scope :sort_by_proj, -> { joins(:project).order("projects.name ASC, wiki_templates.name ASC") }

  safe_attributes 'name', 'text', 'sharing'
end
