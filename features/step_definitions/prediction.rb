Given(/^the test teams are loaded$/) do
  conf = Conference.create(name: 'Big 10')
  conf.teams.create(name: 'IU')
  conf.teams.create(name: 'UIUC')
end

Given(/^I am on the prediction page$/) do
  visit '/'
end

When(/^I select "(.*?)" for team (\d+)$/) do |team_name, team_number|
  select(team_name, from: "Team #{team_number}: ")
end

When(/^I ask for a prediction$/) do
  page.save_screenshot('/Users/Brendan/test.png', full: true)
  click_button('Get Prediction')
end

Then(/^it should show an error$/) do
  expect(page).to have_content('You must select different teams!')
end

Then(/^it should show that "(.*?)" wins$/) do |team_name|
  expect(page).to have_content("Predicted winner: #{team_name}")
end

Then(/^it should not show a prediction$/) do
  expect(find('#prediction').text).to eq('')
end

Then(/^it should have the error css class$/) do
  expect(page).to have_css('div#prediction.error')
end

Then(/^it should not have the error css class$/) do
  expect(page).to have_no_css('div#prediction.error')
end
