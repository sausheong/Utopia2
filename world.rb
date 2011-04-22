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



class World < java.awt.Canvas

  def initialize(opt = {})
    @size = opt[:size]
  
  end
  
  def paint(g)
    g.setColor(Swing::Color.black)
    g.drawString("#{$COUNTER}", 10, 15)
    
    $food.each { |food|
      food.tick(g)   
    }
    
    $alfs.each { |alf|
      alf.tick(g) 
    }
    
    
    
  end
end
