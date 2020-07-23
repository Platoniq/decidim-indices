# frozen_string_literal: true

require 'rails_helper'

describe 'Visit a proposal', type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:proposals_component) { create :component, manifest_name: :proposals, participatory_space: participatory_process }
  let!(:proposal) { create :proposal, component: proposals_component }

  before do
    switch_to_host(organization.host)
    page.visit main_component_path(proposals_component)
    click_link proposal.title
  end

  it "allows viewing a single proposal" do
    expect(page).to have_content(proposal.title)
    expect(page).to have_content(strip_tags(proposal.body).strip)
  end

  context "when has markdown" do
	  let!(:proposal) { create :proposal, :official, body: "## title\n\n**bold**", component: proposals_component }

	  it "is a official proposal" do
	  	expect(proposal.official?).to eq(true)
	  end
  end
end

