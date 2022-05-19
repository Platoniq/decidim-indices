# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-admin",
    files: {
      "/app/views/decidim/admin/organization_appearance/form/_colors.html.erb" => "7fe00e740523bb0caca4bfb60f9f3d68"
    }
  },
  {
    package: "decidim-core",
    files: {
      # layouts
      "/app/views/layouts/decidim/_application.html.erb" => "034f77bdb61fce97e6173fd398f05bf2",
      "/app/views/layouts/decidim/_head_extra.html.erb" => "1b8237357754cf519f4e418135f78440",
      "/app/views/layouts/decidim/_mailer_logo.html.erb" => "7fe70aeb7eb6241107d37b12bd8b5876",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "5a842f3e880f24f49789ee2f72d96f60",
      "/app/views/layouts/decidim/mailer.html.erb" => "0c7804de08649c8d3c55c117005e51c9",
      # assets
      "/app/packs/stylesheets/decidim/email.scss" => "912d93e2242526cc0a75603737b454d6"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/views/decidim/proposals/proposals/show.html.erb" => "f27bbec257eb6da28dbdd07ac0a224a5"
    }
  },
  {
    package: "decidim-forms",
    files: {
      "/app/views/decidim/forms/questionnaires/show.html.erb" => "9edf99eda246f8a276732d3b7544877c",
      "/app/views/decidim/forms/questionnaires/_answer.html.erb" => "6b9d226d7b726e8e25549331870cc2b7",
      "/app/views/decidim/forms/questionnaires/answers/_single_option.html.erb" => "9b1ad5fc7081c769897fbd0e8aaf02fe",
      "/app/views/decidim/forms/questionnaires/answers/_multiple_option.html.erb" => "41c8057d69e5bb8b0a10246cb37a4979",
      "/app/views/decidim/forms/questionnaires/answers/_matrix_single.html.erb" => "4672d9d8edecea6e31da418d5b3050da",
      "/app/views/decidim/forms/questionnaires/answers/_matrix_multiple.html.erb" => "cdb610e7d40f36780da543b49be039d4",
      # cells
      "/app/cells/decidim/forms/answer_readonly_cell.rb" => "da6233059b0557043cc57a9fb5a6830b",
      "/app/cells/decidim/forms/answer_readonly/show.erb" => "9cfca6f9434843d8acf75ef27ebfcda2",
      "/app/cells/decidim/forms/matrix_readonly_cell.rb" => "d658f3adcb71cf2c3e097ff10a2b46c3",
      "/app/cells/decidim/forms/step_navigation_cell.rb" => "8b9e56ff2ab04160bff91f408d38ba82",
      "/app/cells/decidim/forms/step_navigation/show.erb" => "228e2fa97ae251d0179ccc28de5326f8"
    }
  },
  {
    package: "decidim-surveys",
    files: {
      "/app/controllers/decidim/surveys/surveys_controller.rb" => "f443ed19838d251fd9d9b960e5908418"
    }
  }
]

describe "Overriden files", type: :view do
  # rubocop:disable Rails/DynamicFindBy
  checksums.each do |item|
    spec = ::Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end
  # rubocop:enable Rails/DynamicFindBy

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
