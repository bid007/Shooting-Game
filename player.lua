local soundTable = require("soundTable");

local Player = {tag="player", HP=1, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT	=500};

function Player:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;  
  return o;
end

function Player:spawn()
 self.shape = display.newCircle(self.xPos, self.yPos,15);
 self.shape.pp = self;  -- parent object
 self.shape.tag = self.tag; -- “Player”
 self.shape:setFillColor (1,0,0);
 physics.addBody(self.shape, "kinematic"); 
end

function Player:move (event)	

  if event.phase == "began" then    
    -- cube.markX = cube.x 
    if(self ~= nil and self.shape ~= nil) then
      self.markX = self.shape.x
    end

  elseif event.phase == "moved" then   
      if(self ~= nil and self.shape ~= nil) then
          local x = (event.x - event.xStart) + self.markX  

          if (x <= 20 + self.shape.width/2) then
             self.shape.x = 20+self.shape.width/2;
          elseif (x >= display.contentWidth-20-self.shape.width/2) then
             self.shape.x = display.contentWidth-20-self.shape.width/2;
          else
             self.shape.x = x;    
          end
      end
  end
end

function Player:fire (event) 

  if(self.shape == nil) then
    return 
  end

  local p = display.newCircle (self.shape.x, self.shape.y-16, 5);
  p.anchorY = 1;
  p:setFillColor(0,1,1);
  physics.addBody (p, "dynamic", {radius=5} );
  p:applyForce(0, -0.9, p.x, p.y);

  audio.play( soundTable["shootSound"] );

  local function removeProjectile (event)
      if (event.phase=="began") then
        event.target:removeSelf();
        event.target=nil;
        if (event.other.tag == "enemy") then
          event.other.pp:hit();
        end
      end
    end
  p:addEventListener("collision", removeProjectile);
end

function Player:hit () 
  self.HP = self.HP - 1;
  self.shape:setFillColor(0.5,0.5,0.5);
  if (self.HP > 0) then 
    audio.play( soundTable["hitSound"] );
  else 
    audio.play( soundTable["explodeSound"] );
    -- die
    self.shape:removeSelf();
    self.shape=nil; 
    self = nil;  
  end   
end

function Player:getHP()
  -- body
  return self.HP
end

return Player

