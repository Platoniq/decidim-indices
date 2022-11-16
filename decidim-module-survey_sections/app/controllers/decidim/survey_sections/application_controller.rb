# frozen_string_literal: true

module Decidim
  module SurveySections
    # This controller is the abstract class from which all other controllers of
    # this engine inherit.
    #
    # Note that it inherits from `Decidim::Components::BaseController`, which
    # override its layout and provide all kinds of useful methods.
    class ApplicationController < Decidim::Components::BaseController
      def show
        @survey_section_component = current_component
      end
    end
  end
end
