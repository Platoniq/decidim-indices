# frozen_string_literal: true

module Decidim
  module Overrides
    module Forms
      # This cell renders a possible answer of a question (readonly)
      module AnswerReadonlyCell
        include SatCellHelper

        def text
          if sat_set
            remove_hashtags(translated_attribute(model.body))
          else
            translated_attribute(model.body)
          end
        end
      end
    end
  end
end
