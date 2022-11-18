# frozen_string_literal: true

module Decidim
  module Admin
    class IndicesSatLiteFeedbacksController < IndicesFeedbacksController
      helper_method :sat_lite

      def index; end

      def new
        @form = form(SatFeedbackForm).instance
      end

      def create
        @form = form(SatFeedbackForm).from_params(params[:indices_sat_feedback])
        CreateIndicesSatFeedback.call(@form, sat_lite) do
          on(:ok) do
            flash[:notice] = "New SAT lite feedback created successfully"
            redirect_to admin_indices_sat_lite_feedbacks_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error creating the SAT lite feedback: #{error}"
            render :new
          end
        end
      end

      def update
        @form = form(SatFeedbackForm).from_params(params[:indices_sat_feedback])
        UpdateIndicesSatFeedback.call(@form, sat_lite, sat_feedback) do
          on(:ok) do
            flash[:notice] = "SAT lite feedback updated successfully"
            redirect_to admin_indices_sat_lite_feedbacks_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error updating the SAT lite feedback: #{error}"
            render :edit
          end
        end
      end

      def destroy
        sat_feedback.destroy!

        flash[:notice] = "SAT feedback deleted successfully"

        redirect_to admin_indices_sat_lite_feedbacks_path
      end

      private

      def feedbacks_list
        paginate(Indices::SatFeedback.where(sat_set: sat_lite))
      end

      # list of hashtags used in the survey that are not present in any evaluation
      def missing_hashtags
        sat_lite.question_tags.keys - sat_lite.result_tags.keys
      end

      def unused_hashtags
        sat_lite.result_tags.keys - sat_lite.question_tags.keys
      end

      def sat_lite
        Indices::SatLite.find(params[:admin_indices_sat_lite_id])
      end
    end
  end
end
