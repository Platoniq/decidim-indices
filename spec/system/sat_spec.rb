# frozen_string_literal: true

require "rails_helper"

describe "Visit a Self-Assessment Tool comoponent", type: :system, perform_enqueued: true do
  let!(:user) { create(:user, :confirmed, organization: organization) }

  let(:organization) { component.participatory_space.organization }
  let(:component) { create :surveys_component }
  let!(:questionnaire) { create :questionnaire, questionnaire_for: component }
  let!(:survey) { create :survey, questionnaire: questionnaire, component: component }

  let!(:sat_set) { create :indices_sat_set, :with_feedbacks, questionnaire: questionnaire, organization: organization }

  let!(:display_condition) { create :display_condition, question: questionnaire.questions.last, condition_question: questionnaire.questions.first }

  before do
    switch_to_host(organization.host)
    sign_in user, scope: :user

    component.update!(
      step_settings: {
        component.participatory_space.active_step.id => {
          allow_answers: true
        }
      },
      settings: { starts_at: 1.week.ago, ends_at: 1.day.from_now }
    )

    page.visit main_component_path(component)
  end

  it "allows answering the survey" do
    expect(page).to have_content(/#{questionnaire.title["en"]}/i)
    byebug
  end
end
