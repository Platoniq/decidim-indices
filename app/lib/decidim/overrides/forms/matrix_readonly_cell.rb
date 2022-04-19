# frozen_string_literal: true

module Decidim
  module Overrides
    module Forms
      # This cell renders a possible matrix answer of a question (readonly)
      module MatrixReadonlyCell
        include SatCellHelper

        def answer_options
          return super unless sat_set

          model.question.answer_options.map do |option|
            remove_hashtags(translated_attribute(option.body))
          end.join(" / ")
        end
      end
    end
  end
end
