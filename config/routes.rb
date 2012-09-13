DiffaAdapterTutorial::Application.routes.draw do
  post "/users" => "users#create"

  resources :users do
    resources :options 
    resources :futures 

    resources :trades do 
      collection do 
        get 'scan'
        get 'content'
      end
    end

    resources :risks do
      collection do 
        get 'scan'
        get 'content'
      end
    end
  end

  get "/users/:user_id/trades/:trade_id/push" => "trades#propagate"
  post "/users/:user_id/trades/:trade_id/push" => "trades#propagate"

  get "/users/:id/grids" => "users#grids"
  
end
