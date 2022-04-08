# frozen_string_literal: true

module Decidim
  module Overwrites
    module Forms
      # This cell renders a possible answer of a question (readonly)
      module AnswerReadonlyCell
        include SatCellHelper

        def show
          return super unless sat_set

          text = remove_hashtags(translated_attribute(model.body))
          content_tag :li, text, class: "questionnaire-question_readonly-answer"
        end
      end
    end
  end
end
