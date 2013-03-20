class TemplatesController < ApplicationController
  unloadable
  menu_item :settings
  model_object WikiTemplates
  before_filter :find_wiki_template, :only => [:edit, :destroy]
  before_filter :find_project, :authorize , :only => [:new, :edit, :destroy]

  def index
  end

  def new
    if request.post?
      @mitemplate = WikiTemplates.new
      @mitemplate.text = params[:mitemplate][:text]
      @mitemplate.name = params[:mitemplate][:name]
      @mitemplate.visible_children = params[:mitemplate][:visible_children]
      @mitemplate.project = @project
      @mitemplate.author = User.current
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
      @mitemplate.visible_children = params[:mitemplate][:visible_children]
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
      @mitemplate = WikiTemplates.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
end
