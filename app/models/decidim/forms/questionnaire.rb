# frozen_string_literal: true

module Decidim
  module Forms
    # The data store for a Questionnaire in the Decidim::Forms component.
    class Questionnaire < Forms::ApplicationRecord
      include Decidim::Templates::Templatable if defined? Decidim::Templates::Templatable
      include Decidim::Publicable
      include Decidim::TranslatableResource

      translatable_fields :title, :description, :tos
      belongs_to :questionnaire_for, polymorphic: true
      has_one :sat_lite, class_name: "Indices::SatLite", dependent: :destroy
      has_many :questions, -> { order(:position) }, class_name: "Question", foreign_key: "decidim_questionnaire_id", dependent: :destroy
      has_many :answers, class_name: "Answer", foreign_key: "decidim_questionnaire_id", dependent: :destroy

      after_initialize :set_default_salt

      # Public: returns whether the questionnaire questions can be modified or not.
      def questions_editable?
        has_component = questionnaire_for.respond_to? :component
        (has_component && !questionnaire_for.component.published?) || answers.empty?
      end

      # Public: returns whether the questionnaire is answered by the user or not.
      def answered_by?(user)
        query = user.is_a?(String) ? { session_token: user } : { user: user }
        answers.where(query).any? if questions.present?
      end

      def pristine?
        created_at.to_i == updated_at.to_i && questions.empty?
      end

      private

      # salt is used to generate secure hash in anonymous answers
      def set_default_salt
        return unless defined?(salt)

        self.salt ||= Tokenizer.random_salt
      end
    end
  end
end
