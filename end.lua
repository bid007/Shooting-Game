local composer = require( "composer") 
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
local function gotomenu(event)
    local options = {effect = "fade", time = 200}
    composer.gotoScene("menu", options)
end
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    local params = event.params
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --Congratulations text
    local end_text = display.newText( sceneGroup, "", swidth/2, sheight/2-3, native.systemFontBold, 25)
    if(params.win) then
        end_text.text = "Congratulations!!!"
    else
        end_text.text = "Game Over!!!"
    end
    end_text:setFillColor(0.9, 0.8, 0.4)
end
 
 
-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        timer.performWithDelay(500, 
            function()
            -- body
                gotomenu()
            end,1)
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
        composer.removeHidden()
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