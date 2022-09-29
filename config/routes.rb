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
      resources :sat, except: [:show], as: "admin_indices_sat", controller: :indices_sat do
        resources :feedbacks, except: [:show], controller: :indices_feedbacks
      end
    end
  end
end

module Decidim
  module Surveys
    class Engine < ::Rails::Engine
      routes do
        resources :surveys do
          get :feedback, on: :member
          # get :export_user_answers, on: :member
        end
      end
    end
  end
end

module Decidim
  module Pages
    class Engine < ::Rails::Engine
      routes do
        resources :pages do
          get :export_user_answers, on: :member
        end
      end
    end
  end
end
