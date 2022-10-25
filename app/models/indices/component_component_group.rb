# frozen_string_literal: true

module Indices
  class ComponentComponentGroup < ApplicationRecord
    include WeightSortable
    WEIGHT_SCOPE = :indices_component_group_id
    self.table_name = "indices_component_component_groups"
    belongs_to :component_group, class_name: "Indices::ComponentGroup", foreign_key: "indices_component_group_id"
    belongs_to :component, class_name: "Decidim::Component", foreign_key: "decidim_component_id"

    def previous_component_for(user)
      self.class.where("weight < ? AND indices_component_group_id = ?", weight, component_group.id)&.find { |s| s.component.answered_by?(user.id) == false }
    end

    def next_component_for(user)
      self.class.where("weight > ? AND indices_component_group_id = ?", weight, component_group.id)&.find { |s| s.component.answered_by?(user.id) == false }
    end
  end
end
