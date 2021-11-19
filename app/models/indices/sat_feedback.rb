# frozen_string_literal: true

module Indices
  # The data store for the self assessment tool set
  class SatFeedback < ApplicationRecord
    self.table_name = "indices_sat_feedbacks"

    belongs_to :sat_set,
               class_name: "Indices::SatSet"

    def hashtags_list
      hashtags.map do |tag|
        "##{tag["tag"]}"
      end
    end
  end
end
