# frozen_string_literal: true

class ExportAllSurveyAnswersJob < ApplicationJob
  queue_as :default

  def perform(user, survey_sections_group_id)

    survey_sections_group = Decidim::Component.find(survey_sections_group_id)
    data = []
    survey_sections_group.survey_sections.each do |survey_section|
      survey_section.surveys.each do |survey|
        data << { survey: survey, data: data_for_survey(user, survey, "survey_user_answers") }
      end
    end
    export(data)
  end

  def data_for_survey(user, component, name, resource_id = nil)
    export_manifest = component.manifest.export_manifests.find do |manifest|
      manifest.name == name.to_sym
    end
    { collection: export_manifest.collection.call(component, user, resource_id), serializer: export_manifest.serializer }
  end

  def export(data)
    workbook = RubyXL::Workbook.new
    data.each_with_index do |datum, index|
      processed_collection = datum[:data][:collection].map do |resource|
        flatten(datum[:data][:serializer].new(resource).run).deep_dup
      end
      headers = begin
                  return [] if processed_collection.empty?
                  processed_collection.inject([]) do |keys, resource|
                    keys | resource.keys
                  end
                end
      workbook.add_worksheet if index > 0
      worksheet = workbook[index]
      worksheet.sheet_name = datum[:survey].name["en"]

      headers.each_with_index.map do |header, index|
        worksheet.change_column_width(index, 20)
        worksheet.add_cell(0, index, header)
      end

      worksheet.change_row_fill(0, "c0c0c0")
      worksheet.change_row_bold(0, true)
      worksheet.change_row_horizontal_alignment(0, "center")

      processed_collection.each_with_index do |resource, index|
        headers.each_with_index do |header, j|
          if resource[header].respond_to?(:strftime)
            cell = worksheet.add_cell(index + 1, j, custom_sanitize(resource[header]))
            resource[header].is_a?(Date) ? cell.set_number_format("dd.mm.yyyy") : cell.set_number_format("dd.mm.yyyy HH:MM:SS")
            next
          end
          worksheet.add_cell(index + 1, j, custom_sanitize(resource[header]))
        end
      end
    end
    export_data = Decidim::Exporters::ExportData.new(workbook.stream.string, "xlsx")
    workbook.write(export_data.filename)
  end

  def flatten(object, key = nil)
    case object
    when Hash
      object.inject({}) do |result, (subkey, value)|
        new_key = key ? "#{key}/#{subkey}" : subkey.to_s
        result.merge(flatten(value, new_key))
      end
    when Array
      { key.to_s => object.compact.map(&:to_s).join(", ") }
    else
      { key.to_s => object }
    end
  end

  def custom_sanitize(value)
    # rubocop:disable Style/AndOr
    return value unless value.instance_of?(String) and invalid_first_chars.include?(value.first)

    # rubocop:enable Style/AndOr
    value.dup.prepend("'")
  end

  def invalid_first_chars
    %w(= + - @)
  end
end
