require 'RMagick'


namespace :import do
  
  task test: :environment do
    screengrab_img = Magick::Image.read("#{configatron.champion.sourcefiles}/Hecarim_Splash_5.jpg").first
  end

  task champions: :environment do
    #lol_rev_dir = Dir.entries('/Applications/League of Legends.app/Contents/LOL/RADS/projects/lol_air_client/releases/').select {|entry| File.directory? File.join('/Applications/League of Legends.app/Contents/LOL/RADS/projects/lol_air_client/releases/',entry) and !(entry =='.' || entry == '..') }[0]
    #splash_source_location = "/Applications/League of Legends.app/Contents/LOL/RADS/projects/lol_air_client/releases/#{lol_rev_dir}/deploy/bin/assets/images/champions"

    puts "DELETING MODES"
    m  = Mode.all
    m.destroy_all
    m = Mode.new
    m.name = "attract-tournament"
    m.state = 0
    m.save
    m = Mode.new
    m.name = "teams-swapped"
    m.state = 0
    m.save

    puts "DELETING OLD JOBS"
    j = Jobqueue.all
    j.destroy_all

    puts "DELETING OLD SPLASHES"
    s = Splash.all
    s.destroy_all

    puts "DELETING OLD CHAMPS"
    c = Champion.all
    c.destroy_all

    puts "DELETING OLD SCREENS"
    screens = Screen.all
    screens.destroy_all

    1.upto(10) do |x|
      screen = Screen.find_or_create_by(id: x)
      screen.save
    end


    champion_splash_jpgs = Dir.glob("#{configatron.champion.sourcefiles}/*Splash*.jpg")
    for splash_jpg in champion_splash_jpgs 

      #see if it's gray
      test_img = Magick::Image.read(splash_jpg).first
      if test_img.crop(2,2,400,400).number_colors > 1

        #system ("cp #{splash_jpg .shellescape} ")
        champion_name = splash_jpg.match(/.*\/(.*)_Splash_\d.jpg/)[1].downcase
        splash_number = splash_jpg.match(/(\d).jpg/)[1]
        filename = Pathname.new("#{configatron.champion.sourcefiles}/#{champion_name}_#{splash_number}.jpg").basename.to_s

        champ = Champion.find_or_create_by(name: champion_name)

        splash = Splash.find_or_create_by(filename: filename, champion_id: champ.id, number: splash_number)
        
     #   puts filename
      else
        puts "--- IGNORING #{splash_jpg}"
      end
    end
  end

end
