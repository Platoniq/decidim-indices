# frozen_string_literal: true

module Indices
  # The data store for the self assessment tool set
  class SatSet < ApplicationRecord
    include Decidim::TranslatableAttributes
    HASHTAG_REGEX = /\B#([[:alnum:]](?:[[:alnum:]]|_)*)\b/i.freeze

    self.table_name = "indices_sat_sets"

    belongs_to :organization,
               class_name: "Decidim::Organization"

    belongs_to :questionnaire,
               class_name: "Decidim::Forms::Questionnaire"

    has_many :feedbacks, class_name: "Indices::SatFeedback", inverse_of: :sat_set, dependent: :destroy

    validates :name, presence: true
    validates :questionnaire, uniqueness: { scope: :organization }

    delegate :answers, to: :questionnaire

    def survey_name
      return @survey_name if @survey_name

      component = questionnaire.questionnaire_for.component
      @survey_name = "#{translated_attribute(component.participatory_space.title)} :: #{translated_attribute(component.name)}"
    end

    def component
      questionnaire.questionnaire_for.component
    end

    ##########
    # SAT helpers
    ##########

    # Score for the current set of answers
    def answer_tags
      return @answer_tags if @answer_tags

      @answer_tags = []
      answers.find_each do |answer|
        answer.choices.each do |choice|
          choice.body.gsub(HASHTAG_REGEX) do |match|
            @answer_tags << match[1..]
          end
        end
      end
      @answer_tags = @answer_tags.tally
    end

    # TODO: sql search for results having implicated tags only
    def matching_feedbacks
      feedbacks.all
    end

    def results
      @results ||= matching_feedbacks.sort_by do |feedback|
        tags = feedback.score_for(answer_tags)
        feedback.matching = ((tags.keys & answer_tags.keys).size / answer_tags.size)
        feedback.score = tags.values.sum
      end.reverse
    end
  end
end
