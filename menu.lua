local composer = require( "composer") 
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
local function start_game(event)
    print("The game is about to begin")
    local options = {effect = "fade", time = 200}
    composer.gotoScene("game", options)
end
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --Start button rectange
    local button_rect = display.newRoundedRect( sceneGroup, swidth/2, sheight/2, 120, 45, 15)
    button_rect:setFillColor(0.1, 0.2, 0.9)
    button_rect:addEventListener("tap", start_game)
    --Start button text
    local start_text = display.newText( sceneGroup, "PLAY", swidth/2, sheight/2-3, native.systemFontBold, 25)
    start_text:setFillColor(0.8, 0.8, 0.8)
    --Team member names
    local member_one = display.newText( sceneGroup, "Bid Sharma", swidth/5, sheight/1.05, native.systemFontBold, 15)
    member_one:setFillColor(0.9, 0.8, 0.4)
    --Shooting Game Name
    local game_name = display.newText( sceneGroup, "Shooting Game", swidth/2, sheight/4, native.systemFontBold, 25)
    game_name:setFillColor(0.9, 0.8, 0.4)
end
 
 
-- show()
function scene:show( event )
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
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