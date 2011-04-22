# Copyright 2007 Chang Sau Sheong 
#Licensed under the Apache License, Version 2.0 (the "License"); 
#you may not use this file except in compliance with the License. 
#You may obtain a copy of the License at
#
#http://www.apache.org/licenses/LICENSE-2.0 
#
#Unless required by applicable law or agreed to in writing, software 
#distributed under the License is distributed on an "AS IS" BASIS, 
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#See the License for the specific language governing permissions and 
#limitations under the License.


require 'java'
require 'world'
require 'alf'
require 'food'
require 'date'
require 'graphs'

module Swing
  include_package 'java.awt'
  include_package 'javax.swing'
end
module JFreeChart
  include_package 'org.jfree.chart'
  include_package 'org.jfree.chart.plot'
  include_package 'org.jfree.data'
  include_package 'org.jfree.data.category'
end

NO_OF_ALFS = 200
END_OF_THE_WORLD = $COUNTER = 1000
$WORLD_SIZE = 600

$utopia = Swing::JFrame.new("Utopia2")


# generate alf population
$alfs = Array.new
alf_count = 1
NO_OF_ALFS.times {
  $alfs << Alf.generate_randomly(alf_count, [$WORLD_SIZE, $WORLD_SIZE])
  alf_count = alf_count + 1
}

# generate 2 mountains of food
$food = Array.new
FOODPILE_1 = [150,150]
FOODPILE_2 = [350,350]
20.times {
  $food << Food.generate_randomly(FOODPILE_1,30)
  $food << Food.generate_randomly(FOODPILE_2,30)
}


40.times {
  $food << Food.generate_randomly(FOODPILE_1, 100)
  $food << Food.generate_randomly(FOODPILE_2, 100)
}

world = World.new
$utopia.add("Center",world)
$utopia.setSize($WORLD_SIZE, $WORLD_SIZE)
$utopia.setVisible(true)


 
# take a snapshot of the current running system and save it to a
# comma separated value (CSV) file
#$log = File.new("utopia_#{Time.now.to_i}.csv", "w+")
def log_snapshot_to_file
  $log << "\n"
  $alfs.each { |alf|
    $log << alf.food << ','
  } 
end

graph = Graph.new

# run until th end of the world is reached

END_OF_THE_WORLD.times {
  sleep 0.2
  world.repaint
  
  # log the raw data to a csv file. uncomment to activate
  #log_snapshot_to_file
  
  # display the charts
  if (($COUNTER == END_OF_THE_WORLD) or ($COUNTER % 50 == 0)) 
    graph.take_snapshot
    graph.show_population_distribution(END_OF_THE_WORLD - $COUNTER) 
    graph.show_food_distribution(END_OF_THE_WORLD - $COUNTER)
  end
  $COUNTER = $COUNTER - 1
}

Swing::JOptionPane.showMessageDialog($utopia, "Utopia simulation complete. Click OK to exit.")
exit


