Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest


  # Definisco la rotta per le pagine *.html.erb del controller Sikuel
  get "page", to: "file#page"
  get "stock", to: "file#stock"
  get "table", to: "file#table"
  get "sqlite3", to: "file#sqlite3"
  get "mex", to: "file#mex"

  # URI file json
  post "json/piatti", to: "file#piatti", defaults: { format: "json" }
  post "json/tavolo", to: "file#disponibile", defaults: { format: "json" }
  get "json/prenota", to: "file#prenota"

  # test
  get "hello/name", to: "file#name"

  # Imposto la pagina di default della mia app
  root "file#index"
end
