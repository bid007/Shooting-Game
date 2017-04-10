local composer = require( "composer") 
local physics = require("physics")
local player = require("player")
local enemy = require("enemy")
local scene = composer.newScene()
physics.start()
physics.setGravity(0, 0)
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 function gotomenu(win_value)
     -- body
    local options = {effect = "fade", time = 200, params = {win = win_value}}
    composer.gotoScene("end", options)
 end

--------------------------------------------------------------------------------------
--Extending enemy class for our purpose
local blue = enemy:new({HP=2, fT=700})

function blue:spawn()
    -- body
    local vertices = {20, 0, 0, -40, 40, -40}
    self.shape = display.newPolygon(self.xPos, self.yPos, vertices )
    self.sceneGroup:insert(self.shape)
    self.shape.pp = self;  -- parent object
    self.shape.tag = self.tag; -- “enemy”
    self.shape:setFillColor (0,0,1);
    physics.addBody(self.shape, "dynamic"); 
    self:handle_collision()
end

function blue:move()
    -- body
    if(self.player_obj ~=nil and self.player_obj.shape ~= nil and self ~=nil and self.shape ~= nil) then
        --move only if player is alive   and enemy is also alive
        local x2 = self.shape.x
        local y2 = self.shape.y
        local x1 = self.player_obj.shape.x
        local y1 = self.player_obj.shape.y

        local delX = x2 - x1
        local delY = y2 - y1

        local newXpos = x2 - delX/10
        local newYpos = y2 - delY/10

        transition.to(self.shape, 
            {
                x = newXpos, 
                y = newYpos,
                time = 500,
                onComplete = function ()
                    -- body
                    self:move()
                end
            }
        )    

    end
end

function blue:shoot (interval)
  interval = interval or 1500;
  local function createShot(obj)

    if(obj.shape == nil or obj.player_obj == nil or obj.player_obj.shape == nil) then
      timer.cancel(self.timerRef)
      return
    end

    local x1 = self.shape.x
    local y1 = self.shape.y
    local x2 = self.player_obj.shape.x
    local y2 = self.player_obj.shape.y

    local delX = x2 - x1
    local delY = y2 - y1

    
    local p = display.newRect (obj.shape.x, obj.shape.y+50 , 
                               10,10);
    self.sceneGroup:insert(p)
    p:setFillColor(1,0,0);
    p.anchorY=0;
    physics.addBody (p, "dynamic");
    p:applyForce(delX/600, delY/600, p.x, p.y);
        
    local function shotHandler (event)
      if (event.phase == "began") then
            event.target:removeSelf();
          event.target = nil;

          if(event.other.tag == "player") then
              event.other.pp:hit()
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

-- -----------------------------------------------------------------------------------
-- Scene event functions
local game_time = 180000 -- 3mins = 180000 ms
local rep_interval = 2000 -- milliseconds
local num_of_rep = math.floor(game_time / rep_interval)
local game_scope = {}
game_scope.enemy = {}
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --Load the background sky image

    local background = display.newImage("sky.png")
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)
    game_scope.background = background

    --Create a control box
    local control_box = display.newRect( sceneGroup, swidth/2, sheight, swidth, 70)
    control_box:setFillColor(0.9, 0.8, 0.4)
    control_box.tag = "control_box"
    -- control_box:addEventListener("touch", box_event_controller)
    game_scope.control_box = control_box
    physics.addBody( control_box, "static")

    --Wall to remove objects out of screen on collision
    local wall_top = display.newRect( sceneGroup, swidth/2, sheight/60-100, swidth+50, 70)
    physics.addBody(wall_top, "static")

    --Player objects
    local player = player:new({HP=5, xPos=swidth/2, yPos=sheight/1.12})
    game_scope.player = player
    player:spawn()
    sceneGroup:insert(player.shape)
    --listeners
    function control_box_listener(event)
        -- body
        if(player ~= nil) then
            player:move(event)
        end
    end
    --fire listeners
    function fire_listener(event)
        -- body
        if(player ~= nil) then
            player:fire(event)
        end
    end

    game_scope.control_box_listener = control_box_listener
    game_scope.fire_listener = fire_listener
    game_scope.player_collision = player_collision
    game_scope.control_box_collision = control_box_collision

    game_scope.control_box:addEventListener("touch", game_scope.control_box_listener)
    game_scope.background:addEventListener("tap", game_scope.fire_listener)
end
 

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    local game_loop_counter = 0

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local game_timer = timer.performWithDelay(rep_interval ,

            --Main game Function
            function()
                game_loop_counter = game_loop_counter + 1
                --Place to create enemies and perform actions
                local x_origin = math.random( 0, swidth)
                local blue_em_obj = blue:new({xPos=x_origin, yPos=20, sceneGroup=sceneGroup, player_obj = game_scope.player})
                blue_em_obj:spawn()
                blue_em_obj:shoot()
                blue_em_obj:move()
                table.insert( game_scope.enemy, blue_em_obj)

                -- sceneGroup:insert(blue_em_obj.shape)

                if(game_scope.player:getHP() < 1) then
                --Player dies and player loss and game over
                    timer.cancel(game_scope.game_timer)
                    gotomenu(false)
                end

                if(game_loop_counter == num_of_rep) then
                    gotomenu(true)
                end

            end --End of the main game function 

        , num_of_rep)
        game_scope.game_timer = game_timer
    end
end
 
 
-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        game_scope.control_box:removeEventListener("touch", game_scope.control_box_listener)
        game_scope.background:removeEventListener("tap", game_scope.fire_listener)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        local enemies = game_scope.enemy

        for key, enemy in pairs(enemies) do 
            if(enemy ~= nil and enemy.shape ~= nil) then 
                enemy.shape:removeSelf();
                enemy.shape=nil; 
                enemy = nil; 
            end
        end
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene