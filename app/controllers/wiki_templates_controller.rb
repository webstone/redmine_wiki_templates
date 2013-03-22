class WikiTemplatesController < ApplicationController
  unloadable
  menu_item :settings
  model_object WikiTemplate
  before_filter :find_wiki_template, :only => [:edit, :destroy]
  before_filter :find_project, :authorize , :only => [:new, :edit, :destroy]

  def index
  end

  def new
    if request.post?
      @mitemplate = WikiTemplate.new(:project => @project, :author => User.current)
      @mitemplate.text = params[:mitemplate][:text]
      @mitemplate.name = params[:mitemplate][:name]
      @mitemplate.is_public = params[:mitemplate][:is_public]
      if @mitemplate.save
        flash[:notice] = l(:notice_successful_create)
      end
      redirect_to :controller => 'projects', :action => 'settings', :tab => 'wiki_templates', :id => @project
    end
  end

  def destroy
    if @mitemplate.destroy
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_to :controller => 'projects', :action => 'settings', :tab => 'wiki_templates', :id => @project
    return
  end

  def edit
    if request.post?
      @mitemplate.text = params[:mitemplate][:text]
      @mitemplate.name = params[:mitemplate][:name]
      @mitemplate.is_public = params[:mitemplate][:is_public]
      if @mitemplate.save
        flash[:notice] = l(:notice_successful_update)
      end
      redirect_to :controller => 'projects', :action => 'settings', :tab => 'wiki_templates', :id => @project
    end
  end

  private

  def find_project
    begin
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end

  def find_wiki_template
    begin
      @mitemplate = WikiTemplate.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
end
