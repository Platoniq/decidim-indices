# frozen_string_literal: true

module Indices
  class ComponentGroup < ApplicationRecord
    include Decidim::TranslatableResource
    include Indices::WeightSortable
    WEIGHT_SCOPE = :decidim_component_id
    translatable_fields :name, :description

    self.table_name = "indices_component_groups"
    validates :name, :description, :weight, presence: true
    has_many :indices_component_component_groups,
             class_name: "Indices::ComponentComponentGroup",
             foreign_key: "indices_component_group_id", dependent: :destroy
    has_many :components, through: :indices_component_component_groups,
             foreign_key: "decidim_component_id"
    belongs_to :component, class_name: "Decidim::Component",
               foreign_key: "decidim_component_id"

    def ordered_components
      indices_component_component_groups.map {|iccg| iccg.component }
    end
  end
end
