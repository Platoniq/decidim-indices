# frozen_string_literal: true

module ApplicationHelper
  def weblyzard_widgets_for(document)
    render partial: "indices/widgets/all", locals: { document: document }
  end

  # @type tagcloud, keywordgraph, geomap
  # @keywords
  #    if action=similarto: torandom text to generate graphs from
  #    if action=topic: one of "digital-culture", "cultural-heritage", "creative-industries"
  # @action similarto, topic
  # @sources Array, one or more of [decidim, facebook, news, twitter, web]
  # @begindate Initial Date (iso8601, default 6 month ago)
  # @enddate End Date (iso8601, default today)
  # @languages Array, one or more of [en, de, fr, nl, es, it]
  # rubocop:disable Metrics/ParameterLists
  # rubocop:disable Metrics/LineLength
  def weblyzard_iframe(type, keywords, action = :similarto,
                       sources = [:decidim, :facebook, :news, :twitter, :web],
                       begindate = (Date.current - 6.months).iso8601,
                       enddate = Date.current.iso8601,
                       languages = [:en])
    content_tag :iframe, "",
                class: "weblyzard-widget",
                src: "https://api.indices.weblyzard.com/embed/ayBVrdTaUoabsUQ6fPp9zkxK8WrTV2Fg/#{type}/#{action}=#{u keywords}/date=#{u begindate},#{u enddate}/source=#{sources.join(",")}/language=#{languages.join(",")}",
                width: "100%",
                height: "400",
                frameborder: "0",
                scrolling: "no"
  end
  # rubocop:enable Metrics/ParameterLists
  # rubocop:enable Metrics/LineLength
end
