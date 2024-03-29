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
    delegate :questions, to: :questionnaire

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
    def answer_tags(user = nil)
      @answer_tags ||= Hash.new do |h, key|
        answer_tags = []
        relation = answers
        relation = relation.where(decidim_user_id: key) if key
        relation.find_each do |answer|
          answer.choices.each do |choice|
            choice.body.gsub(HASHTAG_REGEX) do |match|
              answer_tags << match[1..]
            end
          end
        end
        h[key] = answer_tags.tally
      end
      @answer_tags[user.try(:id)]
    end

    # tags used across all the options
    def question_tags
      return @question_tags if @question_tags

      @question_tags = []
      questions.find_each do |question|
        next if question.answer_options.blank?

        question.answer_options.each do |choice|
          translated_attribute(choice.body).gsub(HASHTAG_REGEX) do |match|
            @question_tags << match[1..]
          end
        end
      end
      @question_tags = @question_tags.tally
    end

    # tags used across all feedbacks
    def result_tags
      return @result_tags if @result_tags

      @result_tags = {}
      feedbacks.find_each do |feedback|
        feedback.hashtags.each do |tag|
          @result_tags[tag["tag"]] = 0 if @result_tags[tag["tag"]].blank?
          @result_tags[tag["tag"]] += tag["weight"].to_i
        end
      end

      @result_tags
    end

    def matching_feedbacks(user)
      feedbacks.all.select { |f| answer_tags(user).keys.include?(f.hashtags[0]["tag"]) }
    end

    def results(user)
      @results ||= matching_feedbacks(user).sort_by do |feedback|
        tags = feedback.score_for(answer_tags(user)).filter { |_k, v| v != 0 }
        feedback.matching = (100 * (tags.keys & answer_tags(user).keys).size) / answer_tags(user).size unless answer_tags(user).empty?
        feedback.score = tags.values.sum
      end.reverse
    end
  end
end
