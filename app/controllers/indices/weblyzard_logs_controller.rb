# frozen_string_literal: true

module Indices
  class WeblyzardLogsController < ApplicationController
    def create
      doc = params[:document]
      log = WeblyzardLog.find_by(resource_type: doc[:resource_type], resource_id: doc[:resource_id])

      return render json: { error: "Resource not found!" }, status: :unprocessable_entity unless log
      return render json: { error: "No permissions for resource!" }, status: :unprocessable_entity unless user_has_permission?(log)

      log.defaults = params[:defaults]
      log.keywords = params[:keywords]
      log.active = params[:active]

      if log.save
        render json: { msg: "✔" }
      else
        render json: { error: "Invalid data" }, status: :unprocessable_entity
      end
    end

    private

    def user_has_permission?(log)
      return true if current_user&.admin?

      log&.resource&.authored_by?(current_user)
    end
  end
end
