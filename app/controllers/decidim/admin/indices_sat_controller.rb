# frozen_string_literal: true

module Decidim
  module Admin
    # The controller to handle indices self assessment tool and other customizations
    class IndicesSatController < Decidim::Admin::IndicesApplicationController
      include Paginable
      include TranslatableAttributes

      helper_method :sat_list, :sat_set, :questionnaires

      def index; end

      def new
        @form = form(SatSetForm).instance
      end

      def edit
        @form = form(SatSetForm).from_model(sat_set)
      end

      def create
        @form = form(SatSetForm).from_params(params[:indices_sat_set])
        CreateIndicesSatSet.call(@form) do
          on(:ok) do
            flash[:notice] = "New SAT set created successfully"
            redirect_to admin_indices_sat_index_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error creating the SAT set: #{error}"
            render :new
          end
        end
      end

      def update
        @form = form(SatSetForm).from_params(params[:indices_sat_set])
        UpdateIndicesSatSet.call(@form, sat_set) do
          on(:ok) do
            flash[:notice] = "SAT set updated successfully"
            redirect_to admin_indices_sat_index_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error updating the SAT set: #{error}"
            render :edit
          end
        end
      end

      def destroy
        sat_set.destroy!

        flash[:notice] = "SAT set deleted successfully"

        redirect_to admin_indices_sat_index_path
      end

      private

      def sat_set
        Indices::SatSet.find(params[:id])
      end

      def questionnaires
        return @questionnaires if @questionnaires

        classes = Decidim.participatory_space_manifests.pluck :model_class_name
        components = []
        classes.each do |klass|
          spaces = klass.safe_constantize.where(organization: current_organization)
          spaces.each do |space|
            components.concat Decidim::Component.where(participatory_space: space).pluck(:id)
          end
        end
        surveys = Decidim::Surveys::Survey.where(decidim_component_id: components)
        @questionnaires = Decidim::Forms::Questionnaire.where(questionnaire_for: surveys).map do |questionnaire|
          component = questionnaire.questionnaire_for.component
          [
            "#{translated_attribute(component.participatory_space.title)} :: #{translated_attribute(component.name)}",
            questionnaire.id
          ]
        end
      end

      def sat_list
        paginate(Indices::SatSet).where(type: nil)
      end
    end
  end
end
