# frozen_string_literal: true

module Decidim
  module Admin
    class IndicesSatLiteController < IndicesSatController
      helper_method :sat_lite_list, :sat_lite
      def index; end

      def new
        @form = form(SatLiteForm).instance
      end

      def create
        @form = form(SatLiteForm).from_params(params[:indices_sat_lite])
        CreateIndicesSatLite.call(@form) do
          on(:ok) do
            flash[:notice] = "New SAT Lite created successfully"
            redirect_to admin_indices_sat_lite_index_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error creating the SAT Lite: #{error}"
            render :new
          end
        end
      end

      def edit
        @form = form(SatLiteForm).from_model(sat_lite)
      end

      def update
        @form = form(SatLiteForm).from_params(params[:indices_sat_lite])
        UpdateIndicesSatLite.call(@form, sat_lite) do
          on(:ok) do
            flash[:notice] = "SAT Lite updated successfully"
            redirect_to admin_indices_sat_lite_index_path
          end

          on(:invalid) do |error|
            flash.now[:alert] = "Error updating the SAT Lite: #{error}"
            render :edit
          end
        end
      end

      def destroy
        sat_lite.destroy!

        flash[:notice] = "SAT Lite deleted successfully"

        redirect_to admin_indices_sat_lite_index_path
      end

      def sat_lite
        Indices::SatLite.find(params[:id])
      end

      def sat_lite_list
        paginate(Indices::SatLite)
      end
    end
  end
end
