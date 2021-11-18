# frozen_string_literal: true

module Decidim
  module Admin
    class SatSetForm < Form
      mimic "indices/sat_set"

      attribute :name, String
      attribute :questionnaire_id, Integer

      validates :name, :questionnaire_id, presence: true
    end
  end
end
