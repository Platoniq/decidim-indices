# frozen_string_literal: true

module Decidim
  module Admin
    # The controller to handle indices self assessment feedbacks
    class IndicesFeedbacksController < Decidim::Admin::IndicesApplicationController
      include Paginable
      include TranslatableAttributes

      helper_method :feedbacks_list, :sat_set, :sat_feedback, :missing_hashtags, :unused_hashtags

      def index; end

      def new
        @form = form(SatFeedbackForm).instance
      end

      def edit
        @form = form(SatFeedbackForm).from_model(sat_feedback)
      end

      def create
        @form = form(SatFeedbackForm).from_params(params[:indices_sat_feedback])
        CreateIndicesSatFeedback.call(@form, sat_set) do
          on(:ok) do
            flash[:notice] = "New SAT set created successfully"
            redirect_to admin_indices_sat_feedbacks_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error creating the SAT set: #{error}"
            render :new
          end
        end
      end

      def update
        @form = form(SatFeedbackForm).from_params(params[:indices_sat_feedback])
        UpdateIndicesSatFeedback.call(@form, sat_set, sat_feedback) do
          on(:ok) do
            flash[:notice] = "SAT set updated successfully"
            redirect_to admin_indices_sat_feedbacks_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error updating the SAT set: #{error}"
            render :edit
          end
        end
      end

      def destroy
        sat_feedback.destroy!

        flash[:notice] = "SAT feedback deleted successfully"

        redirect_to admin_indices_sat_feedbacks_path
      end

      private

      def sat_set
        Indices::SatSet.find(params[:admin_indices_sat_id])
      end

      def sat_feedback
        Indices::SatFeedback.find(params[:id])
      end

      def feedbacks_list
        paginate(Indices::SatFeedback)
      end

      # list of hashtags used in the survey that are not present in any evaluation
      def missing_hashtags
        sat_set.answer_tags.keys - sat_set.result_tags.keys
      end

      def unused_hashtags
        sat_set.result_tags.keys - sat_set.answer_tags.keys
      end
    end
  end
end
