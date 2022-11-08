# frozen_string_literal: true

module Decidim
  module Overrides
    module Forms
      # This command is executed when the user answers a Questionnaire.
      module AnswerQuestionnaire
        def call
          super unless sat_set

          return broadcast(:invalid) if @form.invalid? || user_already_answered?

          answer_questionnaire

          if @errors
            reset_form_attachments
            broadcast(:invalid)
          else
            broadcast(:ok)
          end
        end

        def sat_set
          @sat_set ||= Indices::SatSet.find_by(questionnaire: questionnaire)
        end
      end
    end
  end
end
