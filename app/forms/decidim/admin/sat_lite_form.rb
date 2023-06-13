# frozen_string_literal: true

module Decidim
  module Admin
    class SatLiteForm < SatSetForm
      include Decidim::HasUploadValidations
      mimic "indices/sat_lite"

      alias organization current_organization

      attribute :image
      attribute :remove_image, Boolean, default: false
      attribute :feedback_image
      attribute :remove_feedback_image, Boolean, default: false
      attribute :iframe

      validates :image,
                :feedback_image,
                passthru: { to: Indices::SatLite }
    end
  end
end
