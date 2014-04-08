require "mechanize"
require "nokogiri"

# Helper functions for Scraping ESPN
module EspnScraperHelper

  # Randomizes the User Agent String and the Sleep for each page request.
  # Helps prevent 503 errors
  def randomize_user_agent(agent)  
    sleep Random.rand(30)

    numUA =  Mechanize::AGENT_ALIASES.count
    randomNumber = Random.rand(numUA)
    #These are mobile user agent strings, return different information
    if(!(randomNumber == 14 or randomNumber == 15 or randomNumber == 16))
      agent.user_agent_alias = Mechanize::AGENT_ALIASES.keys[randomNumber]
    end
  end

  # Wrapper function that gets all conferences and then gets all teams / team stats
  def scrapeESPN()
    # Delete databases
    Conference.delete_all
    Team.delete_all 
    Game.delete_all

    puts "Getting Conferences"
    # Gets all the Conferences
    get_confs()

    puts "Getting Teams"
    # Gets teams and team stats for each conference
    Conference.find_each do |conf|
      puts "--" + conf.name
      get_teams_from_conf(conf)
      get_conference_standings(conf)
      get_team_scoring_stats(conf)
      get_team_adv_scoring_stats(conf)
      get_team_assists_stats(conf) 
      get_team_rebounds_stats(conf)
      get_team_steals_stats(conf)
      get_team_blocks_stats(conf)
    end

    puts "Getting Team Logos and Games"
    Team.find_each do |team|
      puts "--" + team.name
      get_team_logo(team)
      get_team_games(team)
    end
  end

  # Scrapes ESPN college basketball conference page for all conferences and information about conference
  def get_confs()
    # Get the html
    url = "http://espn.go.com/mens-college-basketball/conferences"
    agent = Mechanize.new
    #randomize_user_agent(agent)  
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)
 
    # Gets the list containing the information
    list = doc.xpath("//ul[@class='medium-logos']")
    list.css("li").each { |li|
      # Conference Name
      name = li.css("h5").text

      # Conference Web Extension
      webExt = doc.at_xpath('//a[text()="'+name+'"]')['href']

      # Conference Logo
      logo = li.at_css("img")['src']

      # Creates Database Entry
      if(name != "NCAA Tournament")
        conf = Conference.create(name: name, webExt: webExt, logo: logo)   
      end
    }
  end

  # Scrapes ESPN's specific conference page for all of the teams in the conference
  def get_teams_from_conf(conf)
    # Gets the html
    url = "http://espn.com#{conf.webExt}"
    agent = Mechanize.new
    html = agent.get(url).body
    #randomize_user_agent(agent)  
    doc = Nokogiri::HTML(html)

    # Gets the table with the information
    table = doc.xpath('//table[@class = "mod-data"]')
    rows = table.css('tr')
    rows.each  do |row|
      col = row.css("td")
      # Most valid conferences have 4 columns
      if(col.count > 2)
        # Gets name and rank combination, then parses for appropiate information
        nameRank = col[0].text.scan((/(#)*(\d+ )*(.*)/))
        name = nameRank[0][2]
        if(nameRank[0][1] != nil)
          rank = nameRank[0][1]
        else
          rank = -1
        end

        # Gets team web extension
        webpage = doc.at_xpath('//a[text()="'+name+'"]')['href']
        webExt = webpage.scan(/(\d+).*/)[0][0]
        #webExt = webpage.scan(/\d+.*/)[0]
       
        if(col.count == 4)
          # Gets team conference win/loss
          confWL = col[1].text.scan((/(\d+)-(\d+)/))
          confW = confWL[0][0].to_i
          confL = confWL[0][1].to_i
        
          # Gets overall conference win/loss
          ovrWL = col[3].text.scan((/(\d+)-(\d+)/))
          ovrW = ovrWL[0][0].to_i
          ovrL = ovrWL[0][1].to_i

          # Creates Team Entry
          Team.create(name: name, rank: rank, webExt: webExt, conferenceWins: confW, conferenceLosses: confL, wins: ovrW, losses: ovrL, conference: conf)
        # Independent (No conference) teams only have 3 columns
        elsif(col.count == 3)
          # Gets overall conference win/loss
          ovrWL = col[2].text.scan((/(\d+)-(\d+)/))
          ovrW = ovrWL[0][0].to_i
          ovrL = ovrWL[0][1].to_i

          # Creates Team Entry
          Team.create(name: name, rank: rank, webExt: webExt, wins: ovrW, losses: ovrL, conference: conf)
        end
      end
    end
  end

  # Scrapes ESPN scoring page for a conference to get scoring data for teams in the conference
  def get_team_scoring_stats(conf)
    #refactor later
    # Gets the html
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/scoring-per-game/" 
    agent = Mechanize.new
    #randomize_user_agent(agent)
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 10)

        name = col[1].text   

        ppg = col[3].text

        fg = col[4].text.scan((/(\d+.\d+)-(\d+\d+)/))   
        fgm = fg[0][0].to_i
        fga = fg[0][1].to_i
        fgPer = col[5].text

        threeP = col[6].text.scan((/(\d+.\d+)-(\d+.\d+)/))
        threePM = threeP[0][0].to_i
        threePA = threeP[0][1].to_i
        threePer = col[7].text

        twoPM = fgm - threePM
        twoPA = fga - threePA

        ft = col[8].text.scan((/(\d+.\d+)-(\d+.\d+)/))
        ftm = ft[0][0].to_i
        fta = ft[0][1].to_i
        ftPer = col[9].text

        # Updates specific teams entry with newly scraped data
        team = Team.find_by! name: name 
        team.update(points: ppg, fgm: fgm, fga: fga, fgPer: fgPer, threeMade: threePM, threeAtt: threePA, threePer: threePer, twoMade: twoPM, twoAtt: twoPA, ftm: ftm, fta: fta, ftPer: ftPer)
      end
    end 
  end

  # Scrapes ESPN scoring page for a conference to get advanced scoring data for teams in the conference
  def get_team_adv_scoring_stats(conf)
    #refactor later
    # Gets the html
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/field-goals/"
    agent = Mechanize.new
    #randomize_user_agent(agent)  
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 14)
        name = col[1].text
        twoPer = col[11].text
        pps = col[12].text
        adjFG = col[13].text

        # Updates specific teams entry with newly scraped data
        team = Team.find_by! name: name 
        team.update(twoPer: twoPer, pps: pps, adjFG: adjFG)
      end
    end 
  end

  # Scrapes ESPN scoring page for a conference to get assists data for teams in the conference
  def get_team_assists_stats(conf)
    #refactor later
    # Gets the html
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/assists/"

    agent = Mechanize.new
    #randomize_user_agent(agent)  
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 8)
        name = col[1].text
        assists = col[4].text
        to = col[6].text
        apto = col[7].text

        # Updates specific teams entry with newly scraped data
        team = Team.find_by! name: name 
        team.update(assist: assists, to: to, apto: apto)
      end
    end 
  end

  # Scrapes ESPN scoring page for a conference to get rebounding data for teams in the conference
  def get_team_rebounds_stats(conf)
    #refactor later
    # Gets the html
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/rebounds/"

    agent = Mechanize.new
    #randomize_user_agent(agent)  
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 9)
        name = col[1].text
        offReb = col[4].text
        defReb = col[6].text
        totalReb = col[8].text

        # Updates specific teams entry with newly scraped data
        team = Team.find_by! name: name 
        team.update(offReb: offReb, defReb: defReb, totalReb: totalReb)
      end
    end 
  end

  # Scrapes ESPN scoring page for a conference to get steals data for teams in the conference
  def get_team_steals_stats(conf)
    #refactor later
    # Gets the html
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/steals/"

    agent = Mechanize.new
    #randomize_user_agent(agent)  
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 10)
        name = col[1].text
        steals = col[4].text
        fouls = col[7].text.to_f / col[2].text.to_f
        stealPerTO = col[8].text
        stealPerFoul = col[9].text

        # Updates specific teams entry with newly scraped data
        team = Team.find_by! name: name 
        team.update(steals: steals, fouls: fouls, stealPerTO: stealPerTO, stealPerFoul: stealPerFoul)
      end
    end 
  end

  # Scrapes ESPN scoring page for a conference to get block data for teams in the conference
  def get_team_blocks_stats(conf)
    #refactor later
    # Gets the html
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/blocks/"

    agent = Mechanize.new
    #randomize_user_agent(agent)  
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 7)
        name = col[1].text
        blocks = col[5].text
        blocksPerFoul = col[6].text

        # Updates specific teams entry with newly scraped data
        team = Team.find_by! name: name 
        team.update(blocks: blocks, blocksPerFoul: blocksPerFoul)
      end
    end 
  end

  # Gets all games for a specific team
  def get_team_games(team)
    # Set Up
    url = "http://espn.go.com/mens-college-basketball/team/schedule/_/id/#{team.webExt}"
    agent = Mechanize.new
    #randomize_user_agent(agent)  
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr')

    # Loop through each row
    rows.each  do |row|
      if(row.css('li').count > 3)
        linkHref = row.css('li[@class ="score"]')[0].css('a[href]')[0]
        if(linkHref != nil)
          link = linkHref["href"].scan(/(.*=)(\d+)/)
          gameID = link[0][1] 
          if(Game.where(gameID: gameID).empty?)
            # get Date
            date = row.css("td")[0].text
            # get opp
            opp = row.css('li[@class ="team-name"]').text
            # get HOME/away (vs/@)
            loc = row.css('li[@class ="game-status"]').text
            if(loc == "@")
              homeTeam = team.name
              awayTeam = opp
            else
              homeTeam = opp
              awayTeam = team.name
            end
            
            # Creates Game Entry
            game = Game.create(gameID: gameID, date: date, homeTeam: homeTeam, awayTeam: awayTeam)
            # Gets more game stats
            get_game_stats(game)
          end
        end
      end
    end
  end

  # Gets specific stats for a given game
  def get_game_stats(game)
    # Get the html
    url = "http://espn.go.com/ncb/boxscore?gameId=#{game.gameID}"
    agent = Mechanize.new
    #randomize_user_agent(agent)  
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    awayRecs = doc.xpath("//div[@class = 'team-info']").css("p")[0].text
    awayOvrRaw = awayRecs.scan(/(\d+)-(\d+),.*/)
    if(awayOvrRaw != [] )
      awayOvrPer = awayOvrRaw[0][0].to_f / (awayOvrRaw[0][1].to_f + awayOvrRaw[0][0].to_f)
    else
      awayOvrPer = 0.05
    end
    awayRaw = awayRecs.scan(/.*, (\d+)-(\d+)/)
    if(awayRaw != [])
      awayPer = awayRaw[0][0].to_f / (awayRaw[0][1].to_f + awayRaw[0][0].to_f)
    else
      awayPer = 0.05  
    end
    homeRecs = doc.xpath("//div[@class = 'team-info']").css("p")[1].text
    homeOvrRaw = homeRecs.scan(/(\d+)-(\d+),.*/)
    if(homeOvrRaw != [])
      homeOvrPer = homeOvrRaw[0][0].to_f / (homeOvrRaw[0][1].to_f + homeOvrRaw[0][0].to_f) 
    else
      homeOvrPer = 0.05
    end
    homeRaw = homeRecs.scan(/.*, (\d+)-(\d+)/)
    if(homeRaw != [])
      homePer = homeRaw[0][0].to_f / (homeRaw[0][1].to_f + homeRaw[0][0].to_f)
    else
      homePer = 0.05
    end
    # Find the table with information
    table = doc.xpath('//table[@class = "mod-data"]')
    rows = table.css('tbody')

    # Declare variables
    isHome = false
    homePoints = 0
    awayPoints = 0

    # Get data for game
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 18)
        fg = col[1].text.scan((/(\d+)-(\d+)/))   
        fgm = fg[0][0].to_f
        fga = fg[0][1].to_f
        fgPer = fgm / fga

        threeP = col[2].text.scan((/(\d+)-(\d+)/))
        threePM = threeP[0][0].to_f
        threePA = threeP[0][1].to_f
        threePer = threePM / threePA

        twoPM = fgm - threePM
        twoPA = fga - threePA
        twoPer = twoPM.to_f / twoPA.to_f

        ft = col[3].text.scan((/(\d+)-(\d+)/))
        ftm = ft[0][0].to_f
        fta = ft[0][1].to_f
        ftPer = ftm / fta

        offReb = col[4].text.to_f
        defReb = col[5].text.to_f
        totReb = col[6].text.to_f
        assists = col[7].text.to_f
        steals = col[8].text.to_f
        blocks = col[9].text.to_f
        to = col[10].text.to_f
        pf = col[11].text.to_f

        points = col[12].text.to_f
        pps = points / fga
        adjFG = ((points - ftm)/ fga)/ 2

        apto = assists / to
        spto = steals / to
        spf = steals / pf
        bpf = blocks / pf
  
        # Updates specific game entry with newly scraped data
        if(isHome)
          game.update(homePoints: points, homefgm: fgm, homefga: fga, homefgPer: fgPer, hometwoMade: twoPM, hometwoAtt: twoPA, hometwoPer: twoPer, homethreeMade: threePM, homethreeAtt: threePA, homethreePer: threePer, homeftm: ftm, homefta: fta, homeftPer: ftPer, homeoffReb: offReb, homedefReb: defReb, hometotalReb: totReb, homepps: pps, homeadjFG: adjFG, homeassist: assists, hometo: to, homeapto: apto, homesteals: steals, homefouls: pf, homestealPerTO: spto, homestealPerFoul: spf, homeblocks: blocks, homeblocksPerFoul: bpf, homeOvrWL: homeOvrPer, homeHomeWL: homePer)
        elsif
          game.update(awaypoints: points, awayfgm: fgm, awayfga: fga, awayfgPer: fgPer, awaytwoMade: twoPM, awaytwoAtt: twoPA, awaytwoPer: twoPer, awaythreeMade: threePM, awaythreeAtt: threePA, awaythreePer: threePer, awayftm: ftm, awayfta: fta, awayftPer: ftPer, awayoffReb: offReb, awaydefReb: defReb, awaytotalReb: totReb, awaypps: pps, awayadjFG: adjFG, awayassist: assists, awayto: to, awayapto: apto, awaysteals: steals, awayfouls: pf, awaystealPerTO: spto, awaystealPerFoul: spf, awayblocks: blocks, awayblocksPerFoul: bpf, awayOvrWL: homeOvrPer, awayAwayWL: awayPer)
        end

        # Always two rows, first is away, second is home
        isHome = true
      end
    end  
  end
  
  def get_team_logo(team) 
    url = "http://espn.go.com/mens-college-basketball/team/_/id/#{team.webExt}"
    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)
 
    logo = doc.xpath("//meta[@property='og:image']/@content").text
    team.update(logo: logo)
  end

# 
#  def get_bpi_rankings
#    url = "http://espn.go.com/mens-college-basketball/bpi"
#    agent = Mechanize.new
#    html = agent.get(url).body
#    doc = Nokogiri::HTML(html)
#  
#    table = doc.xpath('//table[@class = "tablehead"]')
#    rows = table.css('tr[@class != "colhead"]')
#    rows.each  do |row|
#      col = row.css('td')
#      if(col.count == 13)
#        name = col[1].text
#        bpi = col[3].text
#     
#        # Gets team web extension
#        webpage = doc.at_xpath('//a[text()="'+name+'"]')['href']
#        webExt = webpage.scan(/\d+.*/)[0]
# 
#        team = Team.find_by! webExt: webExt 
#        team.update(bpi: bpi)
#      end
#    end
#  end

  def get_conference_standings(conf)
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/standings/_/id/#{id[0][1]}"
    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)
  
    table = doc.xpath('//table[@class = "tablehead"]')[1]
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 7)
        name = col[0].text

        home = col[3].text.scan((/(\d+)-(\d+)/))
        homeWin = home[0][0].to_i
        homeLoss = home[0][1].to_i

        away = col[3].text.scan((/(\d+)-(\d+)/))
        awayWin = away[0][0].to_i
        awayLoss = away[0][1].to_i

        pointsAllowed = col[6].text

        # Updates specific teams entry with newly scraped data
        team = Team.find_by! name: name 
        team.update(homeWins: homeWin, homeLosses: homeLoss, awayWins:awayWin, awayLosses: awayLoss, defPoints: pointsAllowed)
      end
    end
  end

end
