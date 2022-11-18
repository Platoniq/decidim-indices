# frozen_string_literal: true

module Decidim
  # This class deals with uploading images to SatLite.
  class SatLiteImageUploader < RecordImageUploader
    set_variants do
      { default: { resize_to_fit: [1000, 1000] } }
    end
  end
end
