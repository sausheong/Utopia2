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


class Graph
  def initialize
    
  end
  

def take_snapshot
  alfs = $alfs.sort {|x,y| y.food <=> x.food }
  @line_dataset = JFreeChart::DefaultCategoryDataset.new
  @bar_dataset = JFreeChart::DefaultCategoryDataset.new
 
  length = alfs.first.food - alfs.last.food
  period = (length/10).to_i
  range = Array.new(13).fill(0)
  alfs.each { |alf|
    bracket = alf.food/period
    range[bracket] = range[bracket] + 1     
  }

  alfs.each { |alf|
    @line_dataset.setValue(alf.food, "Food level", "#{alf.num}")
  }   
  
  count = 1
  range.each { |item|
    @bar_dataset.setValue(item, "Food level", "#{count*period}")
    count = count + 1    
  }
  
end

def show_population_distribution(t=0)
  $chartFrame.dispose if $chartFrame != nil
  chart = JFreeChart::ChartFactory.createLineChart("Population distribution at at t=#{t}",
    "Population range", "Food level", @line_dataset, JFreeChart::PlotOrientation::VERTICAL , false,true, false);
  chart.setBackgroundPaint(Swing::Color.white);
  chart.getTitle().setPaint(Swing::Color.black); 
  $chartFrame =  JFreeChart::ChartFrame.new("Population distribution chart", chart)
  $chartFrame.setSize(500,295)
  $chartFrame.setLocation($WORLD_SIZE + 10, $utopia.getLocation.getY )
  $chartFrame.setVisible(true) 

end

def show_food_distribution(t=0)
  $barChartFrame.dispose if $barChartFrame != nil
  chart = JFreeChart::ChartFactory.createBarChart("Food distribution at at t=#{t}",
    "Food level", "No of agents",  @bar_dataset, JFreeChart::PlotOrientation::VERTICAL , false,true, false);
  chart.setBackgroundPaint(Swing::Color.white);
  chart.getTitle().setPaint(Swing::Color.black); 
  $barChartFrame =  JFreeChart::ChartFrame.new("Food distribution chart", chart)
  $barChartFrame.setSize(500,295)
  $barChartFrame.setLocation($WORLD_SIZE + 10, $utopia.getLocation.getY + 305 )
  $barChartFrame.setVisible(true) 

end

end


