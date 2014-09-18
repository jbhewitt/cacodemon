require 'qlab-ruby'

class OutputScreen
  MACHINE = QLab.connect configatron.qlab.ip, configatron.qlab.port # defaults to ('localhost', 53000)
  QLAB = MACHINE.workspaces.first

  def initialize

    1.upto(10) do |n|
      QLAB.cues[n].opacity = 1
      sleep 0.05
      QLAB.cues[n].start
      sleep 0.05
      #self.pause(n)
    end
  end

  def dead_player(player_number)  
 #   self.fadeout_player(player_number)  
    amount = 1
    while amount > 0.3 do
      amount = amount - 0.3
      QLAB.cues[player_number].opacity = amount
      sleep 0.1
    end 
    #QLAB.cues[player_number].stop
  end

  def alive_player(player_number)
    self.fadein_player(player_number)
  #      amount = 0.1
  #  QLAB.cues[player_number].start
  #  while amount < 1.05  do
  #    amount = amount + 0.10
  #    QLAB.cues[player_number].opacity = amount
  #    sleep 0.1
  #  end 
  #  self.pause(player_number)
  end

  def fadeout_player(player_number)
    amount = 1
    while amount > 0.1 do
      amount = amount - 0.05
      QLAB.cues[player_number].opacity = amount
      sleep 0.05
    end 
    QLAB.cues[player_number].stop
  end

  def fadein_player(player_number)
   amount = 0.1
#   self.stop(player_number)
   sleep 0.05
   self.start(player_number)
   #QLAB.cues[player_number].start
   while amount < 1.05  do
     amount = amount + 0.05
     QLAB.cues[player_number].opacity = amount
     sleep 0.1
   end 
    QLAB.cues[player_number].opacity = 1
    #self.pause(player_number)
  end

  def change_player(splash_jpg, player_number, how_long=1)
    filetarget = "#{configatron.qlab.sourcefiles}/#{splash_jpg}"
    puts "Changing #{player_number} TO #{filetarget}"
    self.fadeout_player(player_number)    
    sleep 0.05    
    QLAB.cues[player_number].fileTarget = filetarget
    sleep 0.05
    QLAB.cues[player_number].stop
    sleep 0.05
    self.fadein_player(player_number)
    #self.pause(player_number)
    #sleep 4
  # QLAB.cues[player_number].pause
  end

  def start ( player_number )
    QLAB.cues[player_number].start
  end
 
  def stop ( player_number )
    QLAB.cues[player_number].stop
  end

  def pause ( player_number )
    QLAB.cues[player_number].pause
  end
end
