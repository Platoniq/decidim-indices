# frozen_string_literal: true

module ApplicationHelper
  def weblyzard_widgets_for(document)
    return unless document.active? || current_user&.admin?
    return unless current_component.settings.automated_data_analysis

    render partial: "indices/widgets/all", locals: { document: document }
  end

  # @type tagcloud, keywordgraph, geomap
  # @keywords
  #    if action=similarto: torandom text to generate graphs from
  #    if action=topic: one of "digital-culture", "cultural-heritage", "creative-industries"
  # @action similarto, topic
  # @source Array, one or more of [decidim, facebook, news, twitter, web]
  # @begindate Initial Date (iso8601, default 6 month ago)
  # @enddate End Date (iso8601, default today)
  # @languages Array, one or more of [en, de, fr, nl, es, it]
  # rubocop:disable Metrics/ParameterLists
  # rubocop:disable Metrics/LineLength
  def weblyzard_iframe(type, keywords, action: :similarto,
                       source: [:decidim, :facebook, :news, :twitter, :web],
                       begindate: (Date.current - 6.months).iso8601,
                       enddate: Date.current.iso8601,
                       languages: [:en])
    content_tag :iframe, "",
                class: "weblyzard-widget loading",
                src: "https://api.indices.weblyzard.com/embed/ayBVrdTaUoabsUQ6fPp9zkxK8WrTV2Fg/#{type}/#{action}=#{u keywords}/date=#{u begindate},#{u enddate}/source=#{source.join(",")}/language=#{languages.join(",")}",
                width: "100%",
                height: "400",
                frameborder: "0",
                scrolling: "no",
                onload: "loadedWeblyzardIframe(this)"
  end
  # rubocop:enable Metrics/ParameterLists
  # rubocop:enable Metrics/LineLength

  def iframe_from_document(type, document)
    weblyzard_iframe(type, document.keywords, document.filter_defaults)
  end

  def document_editable?(document)
    return true if current_user&.admin?

    document.authored_by?(current_user)
  end

  def sat_questionnaire(questionnaire)
    Indices::SatSet.find_by(questionnaire: questionnaire)
  end
end
