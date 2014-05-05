Given(/^the bracket test teams are loaded$/) do
    ['Florida', 'Kansas', 'Syracuse', 'UCLA', 'Virginia Commonwealth', 'Ohio State',
     'New Mexico', 'Colorado', 'Pittsburgh', 'Stanford', 'Dayton', 'Stephen F. Austin',
     'Tulsa', 'Western Michigan', 'Eastern Kentucky', 'Albany',
     'Virginia', 'Villanova', 'Iowa State', 'Michigan State', 'Cincinnati', 'North Carolina',
     'Connecticut', 'Memphis', 'George Washington', 'Saint Joseph\'s', 'Providence', 'Harvard',
     'Delaware', 'North Carolina Central', 'Milwaukee', 'Coastal Carolina',
     'Arizona', 'Wisconsin', 'Creighton', 'San Diego State', 'Oklahoma', 'Baylor', 'Oregon',
     'Gonzaga', 'Oklahoma State', 'Brigham Young', 'Nebraska', 'North Dakota State',
     'New Mexico State', 'Louisiana-Lafayette', 'American University', 'Weber State',
     'Wichita State', 'Michigan', 'Duke', 'Louisville', 'Saint Louis', 'Massachusetts',
     'Texas', 'Kentucky', 'Kansas State', 'Arizona State', 'Tennessee', 'North Carolina State',
     'Manhattan', 'Mercer', 'Wofford', 'Cal Poly'].each do |team|
       Team.create(name: team, logo: 'http://example.com/')
     end
end

Given(/^I'm on the bracket page$/) do
  visit '/bracket'
end

Given(/^the team rank test teams are loaded$/) do
  ['Florida', 'Illinois', 'Mercer'].each do |team|
    Team.create(name: team, logo: 'http://example.com/')
  end
end

Given(/^I'm on the rank page$/) do
  visit '/rank'
end

Then(/^all predictions should be there$/) do
  within '#group-FF' do
    expect(page.find('div.round3-top')).to have_content 'Florida'

    within '.round2-topwrap' do
      expect(page.find('div.round1-top')).to have_content 'Florida'
      expect(page.find('div.round1-bottom')).to have_content 'Virginia'
      expect(page.find('div.round2-top')).to have_content 'Florida'
    end

    within '.round2-bottomwrap' do
      expect(page.find('div.round1-top')).to have_content 'Arizona'
      expect(page.find('div.round1-bottom')).to have_content 'Wichita State'
      expect(page.find('div.round2-bottom')).to have_content 'Arizona'
    end
  end
end

Then(/^(.+) should be ranked (\d)$/) do |team, rank|
  expect(page).to have_content(rank.to_s + ' ' + team)
end
