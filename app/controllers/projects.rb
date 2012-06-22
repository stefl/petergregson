PeterGregson.controllers :projects do
  get :index, :map => "/projects" do
    @projects = Project.all
    render :"projects/index"
  end

  get :show, :map => "/projects/:slug" do
    not_found unless @project = Project.where(:slug => params[:slug]).first
    render :"projects/show"
  end

  get :image, :map => "/projects/:slug/image" do
    not_found unless @project = Project.where(:slug => params[:slug]).first
    not_found unless @image = @project.image
    send_file(@project.image, :disposition => nil)
  end
end
