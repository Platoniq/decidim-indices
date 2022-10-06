# frozen_string_literal: true

module Indices
  class ComponentComponentGroup < ApplicationRecord
    self.table_name = "indices_component_component_groups"
    belongs_to :component_group, class_name: "Indices::ComponentGroup", foreign_key: "indices_component_group_id"
    belongs_to :component, class_name: "Decidim::Component", foreign_key: "decidim_component_id"
  end
end
