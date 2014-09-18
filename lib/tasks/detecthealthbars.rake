require_relative 'healthbars.rb'

namespace :detect do
  task healthbars: :environment do    
    detectHealthbars = DetectHealthbars.new
    loop do   
      puts "trying"
      screen = grab_screen
      puts screen
      
      detectHealthbars.screen = screen
      changes = detectHealthbars.report
      changes.each do |change|
        playernumber = check_player_screen(change[:number])
        puts playernumber        
      end      
      
      
      #  if screen.is_a?(Magick::ImageList)
      #    screen.destroy! #not sure might help with RAM?
      #  end
     # end
    end

    #end task
  end
end
