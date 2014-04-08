module BracketHelper
  def team_tag(team)
    logo = team.logo.gsub(/w=\d+&h=\d+/, 'w=20&h=20')
    ('<img src="' + logo + '" /> ' + map_name(team.name)).html_safe
  end

  NAMES = {
    'Virginia Commonwealth' => 'VCU',
    'Stephen F. Austin' => 'SF Austin',
    'George Washington' => 'G Wash',
    'North Carolina Central' => 'NC Central',
    'New Mexico State' => 'NM State',
    'North Dakota State' => 'ND State',
    'American University' => 'American',
    'Louisiana-Lafayette' => 'LA-Lafayette',
    'North Carolina State' => 'NC State',
    'Eastern Kentucky' => 'E Kentucky',
    'Western Michigan' => 'W Michigan',
    'Coastal Carolina' => 'Coastal Car',
    'Brigham Young' => 'BYU'
  }
  def map_name(name)
    return NAMES[name] if NAMES.has_key?(name)
    name
  end
end
