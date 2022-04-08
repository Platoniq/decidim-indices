# frozen_string_literal: true

module Decidim
  module Overwrites
    module Forms
      module SatCellHelper
        def sat_set
          @sat_set ||= Indices::SatSet.find_by(questionnaire: model.question.questionnaire)
        end

        def remove_hashtags(text)
          text.gsub(Indices::SatSet::HASHTAG_REGEX, "")
        end
      end
    end
  end
end
