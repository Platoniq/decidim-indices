# frozen_string_literal: true

module Decidim
  module Overrides
    module Forms
      module UserAnswersSerializer
        def hash_for(answer)
          {
            answer_translated_attribute_name(:user_identifier) => answer&.decidim_user_id.present? ? Digest::MD5.hexdigest(answer&.decidim_user_id.to_s) : "Unknown",
            answer_translated_attribute_name(:id) => answer&.session_token,
            answer_translated_attribute_name(:created_at) => answer&.created_at&.to_s(:db),
            answer_translated_attribute_name(:ip_hash) => answer&.ip_hash,
            answer_translated_attribute_name(:user_status) => answer_translated_attribute_name(answer&.decidim_user_id.present? ? "registered" : "unregistered")
          }
        end
      end
    end
  end
end
