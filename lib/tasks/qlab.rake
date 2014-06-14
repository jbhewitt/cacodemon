require_relative "/vagrant/cacodemon/lib/qlab_access.rb"
#require_relative 'lib/terminal_fun.rb'
#
namespace :qlab do
  task loop: :environment do
    attractpnumber = 1 #the variable which controls which screen we're changing in attract mode, consecutive counting to 10    
    screen = OutputScreen.new      
#BEGIN THE DOOM LOOP
    loop do
  #  mode = File.read('mode.txt')

      current_mode = Mode.first.state
      if current_mode == 0 ## 1 = attract 
        puts "ATTRACT MODE #{attractpnumber}"              
        screen.change_player((Splash.order("RANDOM()").first.filename),attractpnumber)
        attractpnumber = attractpnumber + 1
        if attractpnumber == 11 then attractpnumber = 1 end
      elsif current_mode == 1
        puts "TOURNAMENT MODE"
        job = Jobqueue.next
        if !job.nil?
          screen.change_player(job.screen.splash.filename,job.screen.id)
          job.completed = true
          job.save
        else
          sleep(0.5)
        end      
          
      end    
    end

    sleep(0.1)
    puts "."
  end
end


=begin


@daterminal = TerminalFun.new
@champion_screens = get_champion_screens(configatron.champion.sourcefiles)
attractpnumber = 1 
screen = OutputScreen.new
#screen.start(1)
#screen.start(2)
#screen.start(3)




def update_champion(champ_name,number)
  ### unfinished - might do one day, stores current champions in database
    player_champion = player_champions.where(:player_number => number).update(:champ_name => champ_name)
end






def tournament_mode(qtable,screen)
  q = qtable.where(:processed=>nil).first
  if !q.nil?
    if !q[:champ_name].nil?
#### champion update!      
      screen.change_player(q[:champ_name],q[:player_number])
#####  save to database
   #   update_champion(q[:champ_name],q[:player_number])
      qtable.where(:id => q[:id]).delete
### any dead or alive people?  
    elsif !q[:dead].nil?
      if q[:dead] == true 
        screen.dead_player(q[:player_number])
        print red { bold { " killing player #{q[:player_number]}"} }, "\n"
      elsif q[:dead] == false
        screen.alive_player(q[:player_number])
        print magenta { bold { " reviving player #{q[:player_number]}"} }, "\n"
      end
#### mode changes?
    elsif !q[:mode].nil?
        print green { bold { " MODE CHANGE - #{q[:mode]}"} }, "\n"
    end
#### erase from database
    qtable.where(:id => q[:id]).delete
  end
end

#################### THE DOOM LOOP
=end
