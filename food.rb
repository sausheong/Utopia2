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


class Food
  COLOR = java.awt.Color.green
  FOODPILE_RADIUS = 100
  
  attr_reader :location, :current_amount
  
  def initialize(opt = {})
    @location = opt[:location]    
    @max_amount = opt[:max]
    @current_amount = @max_amount
    @growth_rate = rand(10) + 1
  end
  
  def Food.generate_randomly(foodpile = [], radius = FOODPILE_RADIUS)
    
    x = foodpile[0] + (rand(radius)* (rand(2) == 0? -1 : 1))
    y = foodpile[1] + (rand(radius)* (rand(2) == 0? -1 : 1))
    food = Food.new(:location => [x,y], :max => rand(100))
    return food
    
  end
  
  def eat(amount)
    eaten = amount
    @current_amount = @current_amount - amount
    if @current_amount < 0 
      eaten = amount - @current_amount
      # random growth rate of food
      @current_amount = 0 - rand(150)     
    end
    return eaten
  end
  
  def exhausted
    return @current_amount <= 0
  end
  
  def tick(g)
    (@current_amount = @current_amount + @growth_rate unless @current_amount > @max_amount) if @current_amount <= 0
    render(g)
  end
  
  def render(g)
    if exhausted
      g.clearRect(@location[0],@location[1], 6,6)
    else
      g.setColor(COLOR)
      g.fillOval(@location[0],@location[1], 6, 6)
    end
  end
  
  end


