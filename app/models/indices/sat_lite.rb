# frozen_string_literal: true

module Indices
  class SatLite < SatSet
    include Decidim::HasUploadValidations

    has_one_attached :image
    has_one_attached :feedback_image
    validates_upload :image, uploader: Decidim::SatLiteImageUploader
    validates_upload :feedback_image, uploader: Decidim::SatLiteImageUploader
  end
end
