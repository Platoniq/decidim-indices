# frozen_string_literal: true

module Decidim
  module Admin
    # The controller to handle indices multisurveys
    class MultisurveysController < Decidim::Admin::IndicesApplicationController
      include Paginable
      include TranslatableAttributes

      helper_method :multisurvey

      def index; end

      def new
        @form = form(MultisurveyForm).instance
      end

      def edit
        @form = form(MultisurveyForm).from_model(multisurvey)
      end

      def create
        @form = form(MultisurveyForm).from_params(params[:indices_multisurvey])
        CreateMultisurvey.call(@form, sat_set) do
          on(:ok) do
            flash[:notice] = "New multisurvey created successfully"
            redirect_to admin_indices_multisurveys_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error creating the multisurvey: #{error}"
            render :new
          end
        end
      end

      def update
        @form = form(MultisurveyForm).from_params(params[:indices_multisurvey])
        UpdateMultisurvey.call(@form, multisurvey) do
          on(:ok) do
            flash[:notice] = "multisurvey updated successfully"
            redirect_to admin_indices_multisurveys_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error updating the multisurvey: #{error}"
            render :edit
          end
        end
      end

      def destroy
        multisurvey.destroy!

        flash[:notice] = "Multisurvey deleted successfully"

        redirect_to admin_indices_multisurveys_path
      end

      private

      def multisurvey
        Indices::Multisurvey.find(params[:id]) if params[:id]
      end
  end
end
