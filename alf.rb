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

class Alf

  MAX_SPEED = 10
  MAX_SCOPE = 150
  LIFESPAN = 200
  MIN_START_FOOD = 10
  COLOR = java.awt.Color.red
  
  attr_reader :num, :food
  
  def initialize(num,opt={})
    @num = num
    @status = :alive
    @life = LIFESPAN + rand(1000)
    @food = MIN_START_FOOD + rand(100)
    
    @color = opt[:color].nil? ? COLOR : opt[:color]
    
    @location = opt[:location].nil? ? [10,10] : opt[:location]
    @tail = @location
    
    # scope is how far the alf can see
    @scope = opt[:scope].nil? ?  MAX_SCOPE.to_i : opt[:scope].to_f 
    # speed is how fast the alf can move in a single turn
    @speed = opt[:speed].nil? ? MAX_SPEED.to_i : opt[:speed].to_f 
    
    # digestion rate is the rate the alf eats up its stored food
    @digestion_rate = opt[:digestion_rate].nil? ? rand(4) + 1 : opt[:digestion_rate]
    # consumption rate is how much the alf eats the food at every bite
    @consumption_rate = opt[:consumption_rate].nil? ? rand(4) + 1 : opt[:consumption_rate]
    # starvation rate is how fast the alf will reduce its lifespan due to lack
    # of food
    @starvation_rate = 1
        
  end
  
  # randomly generate an alf
  # default world size is 400 x 400
  def Alf.generate_randomly(num, size=[400,400])
    alf = Alf.new(num, :location => [rand(size[0]), rand(size[1])],
    :speed => rand(MAX_SPEED - 1) + 1)
  end
  
  # move to the next location
  def move
    @tail = @location
    closest_food = detect_closest_food
    @location = calculate_next_location(closest_food)

  end
  
  # find the nearest food available
  def detect_closest_food
    @food_within_scope = []
    $food.each { |food|
      @food_within_scope << food if (distance_from(food.location) <= @scope and !food.exhausted)
    }
    if @food_within_scope.empty?
      xrand = rand(10) * (rand(2) == 0? -1 : 1)
      yrand = rand(10) * (rand(2) == 0? -1 : 1)      
      return [@location[0] + xrand, @location[1] + yrand]
    else
      @food_within_scope.sort!{|x,y| distance_from(x.location) <=> distance_from(y.location)}
      return @food_within_scope.first.location
    end
    
  end
  
  
  def distance_from(another_point)
    return ((another_point[0] - @location[0])**2 + 
            (another_point[1] - @location[1])**2) ** 0.5    
  end
  
  # calculate where the alf will go next based on the location of the closest
  # available food
  def calculate_next_location(food)

    x =  food[0] - @location[0]
    y = food[1] - @location[1] 

    distance = (x**2 + y**2) ** 0.5
    next_location = [@location[0] + x*@speed/distance, @location[1] + y*@speed/distance]

    return next_location
  end
  
  # life ticking away, speeds up if the alf runs out of food
  def reduce_life
    if @life > 0 
      @life = @life - (1 * @starvation_rate)
    else
      @status = :dead
    end
  end
  
  # need to eat to live, alfs with bigger appetites will digest more, alfs with
  # bigger 'bites' will eat faster
  def consume_food
    if @status == :alive
      # eat the food if it is within my scope
      @food = @food + @food_within_scope.first.eat(@consumption_rate) if !@food_within_scope.empty?

      # if I have a storage of food, I'll digest it
      if @food > 0
        @food = @food - (1 * @digestion_rate)
        @food = 0 if @food < 0
      else
        # if i run out of food, i'll starve i.e. die faster
        @starvation_rate = @starvation_rate + 1
      end    
         
    end    
  end
  
  def alive?
    return @status == :alive
  end
  
  
  def tick(g)
    move
    consume_food    
    reduce_life
    render(g)
  end
  
  def render(g)
    g.setColor(@color)
    if distance_from(@tail) < 15
      g.drawLine(@tail[0], @tail[1],@location[0],@location[1])    
    end
    g.fillOval(@location[0],@location[1], 4, 4)    
  
  end

    
end


