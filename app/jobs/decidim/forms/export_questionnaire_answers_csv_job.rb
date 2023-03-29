# frozen_string_literal: true

module Decidim
  module Forms
    class ExportQuestionnaireAnswersCSVJob < ApplicationJob
      queue_as :exports

      def perform(user, title, answers)
        return if user&.email.blank?
        return if answers.blank?

        serializer = ExportQuestionnaireAnswersSerializer
        export_data = Decidim::Exporters::CSV.new(answers, serializer).export

        ExportMailer.export(user, title, export_data).deliver_now
      end
    end

    class ExportQuestionnaireAnswersSerializer < UserAnswersSerializer
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
