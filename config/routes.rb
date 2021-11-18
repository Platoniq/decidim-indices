# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :weblyzard_logs, only: [:create], module: "indices"
end

# Add a simple menu in the admin part
Decidim::Admin::Engine.routes.draw do
  resources :indices, only: [:index], as: "admin_indices" do
    collection do
      resources :sat, as: "admin_indices_sat", controller: :indices_sat
    end
  end
end
