# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/encode', to: 'short_links#create'
      get '/decode', to: 'short_links#show'
    end
  end

  get 's/:code', to: 'short_links#show', as: :short_link
end
