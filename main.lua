-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Import composer
local composer = require("composer")
display.setStatusBar( display.HiddenStatusBar )

--Global variables for display height and width
sheight = display.contentHeight
swidth = display.contentWidth
--Global xpos and ypos of the player
--Go to menu scene
composer.gotoScene("menu")