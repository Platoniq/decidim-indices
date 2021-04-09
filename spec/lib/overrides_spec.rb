# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-admin",
    files: {
      "/app/views/decidim/admin/organization_appearance/form/_colors.html.erb" => "725fc77b4c80f885b7b4191a75a06949"
    }
  },
  {
    package: "decidim-core",
    files: {
      # layouts
      "/app/views/layouts/decidim/_application.html.erb" => "3bd5852193832d35634ede6966c49b10",
      "/app/views/layouts/decidim/_head_extra.html.erb" => "1b8237357754cf519f4e418135f78440",
      "/app/views/layouts/decidim/_mailer_logo.html.erb" => "8abb593b786423070101ded4ea8140b4",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "55a9ca723b65b8d9eadb714818a89bb3",
      "/app/views/layouts/decidim/mailer.html.erb" => "5bbe335c1dfd02f8448af287328a49dc",
      # assets
      "/app/assets/stylesheets/decidim/email.scss" => "e77ab30914437227443dd3c714b8534b",
      "/app/assets/stylesheets/decidim/utils/_settings.scss" => "cc65c749bff68ff08f3971fa8e53de6c"
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
