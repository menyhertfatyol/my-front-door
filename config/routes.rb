Rails.application.routes.draw do
  get 'doorlock/index'
  root to: 'doorlock#index'
end
