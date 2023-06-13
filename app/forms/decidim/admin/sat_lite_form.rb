# frozen_string_literal: true

module Decidim
  module Admin
    class SatLiteForm < SatSetForm
      include Decidim::HasUploadValidations
      mimic "indices/sat_lite"
      attribute :image
      attribute :feedback_image
      attribute :iframe
    end
  end
end
