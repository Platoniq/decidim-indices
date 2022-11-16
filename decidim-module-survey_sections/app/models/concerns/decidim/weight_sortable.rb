# frozen_string_literal: true

module Decidim
  module WeightSortable
    extend ActiveSupport::Concern
    included do
      after_save :sort_weights
      default_scope { order(weight: :asc) }
    end

    private

    def sort_weights
      objects = self.class.where("weight = ? AND id != ? AND #{self.class::WEIGHT_SCOPE} = ?", weight, id, send(self.class::WEIGHT_SCOPE))
      return if objects.blank?

      objects.each { |object| object.update(weight: weight + 1) }
    end
  end
end
