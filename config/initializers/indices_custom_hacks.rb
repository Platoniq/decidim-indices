# frozen_string_literal: true

# Configurable menus
Decidim.menu :menu do |menu|
  if Rails.application.secrets.menu[current_organization.host.to_sym].respond_to? :each
    Rails.application.secrets.menu[current_organization.host.to_sym].each do |_tenant, item|
      options = {}
      options[:position] = item[:position].to_i if item[:position]
      options[:active] = item[:active].to_sym if item[:active]
      options[:icon_name] = item[:icon_name].to_s if item[:icon_name]
      menu.item I18n.t(item[:key]), item[:url], options
    end
  end
end

# Admin menu
Decidim.menu :admin_menu do |menu|
  menu.item "InDICEs",
            "/admin/indices",
            icon_name: "dial",
            position: 1.2,
            active: :inclusive
end
