class WikiTemplatesController < ApplicationController
  unloadable
  menu_item :settings
  model_object WikiTemplate
  before_filter :find_project_by_project_id, :only => [:new]
  before_filter :find_model_object, :except => [:new]
  before_filter :find_project_from_association, :except => [:new]
  before_filter :authorize

  def show
  end

  def new
    @wiki_template = WikiTemplate.new(:project => @project, :author => User.current)
    if request.post?
      @wiki_template.safe_attributes = params[:wiki_template]
      if @wiki_template.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => 'projects', :action => 'settings', :tab => 'wiki_templates', :id => @project
      else
        render :action => 'new'
      end
    end
  end

  def edit
  end

  def update
    @wiki_template.safe_attributes = params[:wiki_template]
    if request.put? and @wiki_template.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller => 'projects', :action => 'settings', :tab => 'wiki_templates', :id => @project
    else
      render :action => 'edit'
    end
  end

  def destroy
    if request.delete? and @wiki_template.destroy
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_to :controller => 'projects', :action => 'settings', :tab => 'wiki_templates', :id => @project
  end
end
