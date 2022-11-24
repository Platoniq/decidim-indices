# frozen_string_literal: true

module Decidim
  module Overrides
    module Forms
      module UserAnswersSerializer
        # Public: Exports a hash with the serialized data for the user answers.
        def serialize
          answers_hash = questions_hash

          @answers.each do |answer|
            answers_hash[translated_question_key(answer.question.position, answer.question.body)] = normalize_body(answer)
          end

          answers_hash
        end
      end
    end
  end
end
