local soundTable=require("soundTable");

local Enemy = {tag="enemy", HP=1, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT	=500, sceneGroup={}};

function Enemy:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;  
  return o;
end

function Enemy:spawn()
 self.shape=display.newCircle(self.xPos, self.yPos,15);
 self.shape.pp = self;  -- parent object
 self.shape.tag = self.tag; -- “enemy”
 self.shape:setFillColor (1,1,0);
 physics.addBody(self.shape, "kinematic"); 
end

function Enemy:handle_collision()
  -- body
  function on_collision(event)
    -- body
    if (event.phase == "began") then

        if(event.other.tag == "player") then
          event.other.pp:hit()
        end

        if(event.other.tag == "control_box") then
          print("collision with control_box")
        end

    end
  end
  self.shape:addEventListener("collision", on_collision)
end


function Enemy:back ()
  transition.to(self.shape, {x=self.shape.x+100, y=150,  
  time=self.fB, rotation=self.bR, 
  onComplete=function (obj) self:forward() end} );
end

function Enemy:side ()   
   transition.to(self.shape, {x=self.shape.x-200, 
   time=self.fS, rotation=self.sR, 
   onComplete=function (obj) self:back() end } );
end

function Enemy:forward ()   
   transition.to(self.shape, {x=self.shape.x+100, y=800, 
   time=self.fT, rotation=self.fR, 
   onComplete= function (obj) self:side() end } );
end

function Enemy:move ()	
	self:forward();
end

function Enemy:hit () 
	self.HP = self.HP - 1;
	if (self.HP > 0) then 
		audio.play( soundTable["hitSound"] );
		self.shape:setFillColor(0.5,0.5,0.5);
	
	else 
		audio.play( soundTable["explodeSound"] );
		transition.cancel( self.shape );
		
		if (self.timerRef ~= nil) then
			timer.cancel ( self.timerRef );
		end

		-- die
		self.shape:removeSelf();
		self.shape=nil;	
		self = nil;  
	end		
end


function Enemy:shoot (interval)
  interval = interval or 1500;
  local function createShot(obj)

    if(obj.shape == nil) then
 
      timer.cancel(self.timerRef)
      return
    end
    local p = display.newRect (obj.shape.x, obj.shape.y+50 , 
                               10,10);
    self.sceneGroup:insert(p)
    p:setFillColor(1,0,0);
    p.anchorY=0;
    physics.addBody (p, "dynamic");
    p:applyForce(0, 0.2, p.x, p.y);
		
    local function shotHandler (event)
      if (event.phase == "began") then
	        event.target:removeSelf();
   	      event.target = nil;

          if(event.other.tag == "player") then
              event.other.pp:hit();
              self.player_hp.text = self.player_hp.text - 1;
          end
      end
    end
    p:addEventListener("collision", shotHandler);		
  end

  if(self ~= nil and self.shape ~= nil) then
    self.timerRef = timer.performWithDelay(interval, 
  	function (event) createShot(self) end, -1);
  end
end

return Enemy

