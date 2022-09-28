# frozen_string_literal: true

require "rails_helper"

describe "Visit a survey", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:component) { create :surveys_component, manifest_name: :surveys, participatory_space: participatory_process }
  let!(:survey) { create :survey, component: component }
  let(:questionnaire) { survey.questionnaire }

  let!(:user) { create :user, :confirmed, organization: organization }

  before do
    switch_to_host(organization.host)
    sign_in user, scope: :user
    page.visit main_component_path(component)

    component.update!(
      step_settings: {
        component.participatory_space.active_step.id => {
          allow_answers: true
        }
      },
      settings: { starts_at: 1.week.ago, ends_at: 1.day.from_now }
    )
  end

  it "renders the survey title" do
    expect(page).to have_content(survey.title["en"].upcase)
    expect(page).to have_content(questionnaire.title["en"])
  end

  context "when survey has been answered" do
    let!(:answers) do
      questionnaire.questions.with_body.map { |question| create(:answer, question: question, questionnaire: questionnaire, user: user) }
    end

    before do
      page.visit main_component_path(component)
    end

    it "allows to download answers" do
      expect(page).to have_content "export"
    end
  end
end
