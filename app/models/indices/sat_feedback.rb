# frozen_string_literal: true

module Indices
  # The data store for the self assessment tool set
  class SatFeedback < ApplicationRecord
    self.table_name = "indices_sat_feedbacks"

    belongs_to :sat_set,
               class_name: "Indices::SatSet"

    attr_accessor :score, :matching # used for tap methods

    def hashtags_list
      hashtags.map do |tag|
        "##{tag["tag"]}"
      end
    end

    # total computed score for a set of tags and weights (extracted from one answer)
    # answer_tags: {tag1: 2, tag2: 1, tag3: 5, ...}
    def score_for(answer_tags)
      answer_tags.filter_map do |name, freq|
        score = hashtags.filter_map { |tag| tag["tag"] == name ? tag["weight"].to_i : false }.sum
        [name, score * freq] if score
      end.to_h
    end
  end
end
