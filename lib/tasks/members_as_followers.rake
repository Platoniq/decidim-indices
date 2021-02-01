# frozen_string_literal: true

# lib/tasks/members_as_followers.rake
namespace :indices do
  desc "Ensures locales in organizations are in sync with Decidim configuration"
  task members_as_followers: :environment do
    Decidim::Assembly.all.each do |assembly|
      followers = assembly.followers.pluck :decidim_user_id
      puts "Assembly [#{assembly.slug}] has  #{followers.count} followers and #{assembly.members.count} members"
      assembly.members.all.each do |member|
        next unless member.decidim_user_id

        puts "Processing #{member.user.name} <#{member.user.email}>"
        if followers.include? member.decidim_user_id
          puts "Already a follower, skipping..."
          next
        end
        Decidim::Follow.create!(
          followable: assembly,
          user: member.user
        )
        puts "Created as new follower"
      end
    end
  end
end
