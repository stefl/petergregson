PeterGregson.controllers :statuses do

  get :index, :map => "/" do
    @statuses = Status.all.order_by([[:happening_at, :asc]])
    render :"statuses/index"
  end
  
end
