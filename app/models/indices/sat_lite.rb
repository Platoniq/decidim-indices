# frozen_string_literal: true

module Indices
  class SatLite < SatSet
    include Decidim::HasUploadValidations

    has_one_attached :image
    validates_upload :image, uploader: Decidim::SatLiteImageUploader
  end
end
