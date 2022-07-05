require "decidim/core/test/factories"
require "decidim/forms/test/factories"

FactoryBot.define do
  factory :indices_sat_set, class: "Indices::SatSet" do
    name { Faker::Lorem.sentence }
    organization
    questionnaire

    trait :with_feedbacks do
      feedbacks do
        1.upto(3).to_a.map do
          build(:indices_sat_feedback)
        end
      end
    end
  end

  factory :indices_sat_feedback, class: "Indices::SatFeedback" do
    sat_set factory: :indices_sat_set

    title { Decidim::Faker::Localized.sentence(word_count: 5) }
    description { Decidim::Faker::Localized.paragraph(sentence_count: 1) }
    hashtags { Decidim::Faker::Localized.words(number: 1) }
  end
end
