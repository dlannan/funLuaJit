------------------------------------------------------------------------------------------------------------

release       = "0"
subversion    = "001"

------------------------------------------------------------------------------------------------------------

require("byt3d/scripts/platform/setup")

------------------------------------------------------------------------------------------------------------
-- Window width
local WINwidth, WINheight, WINFullscreen = 1280, 720, 0

------------------------------------------------------------------------------------------------------------
-- Global because states need to use it themselves

gSmgr = require("scripts/platform/statemanager")

------------------------------------------------------------------------------------------------------------
-- Require all the states we will use for the game

gSdisp 			= require("scripts/states/common/display")
local Smain 	= require("scripts/states/application/sample01")
--local Smain 	= require("scripts/states/application/sample02")

------------------------------------------------------------------------------------------------------------

gDir            = require("scripts/utils/directory")

---- States
SobjMgr         = require("scripts/states/common/object-manager")

------------------------------------------------------------------------------------------------------------
-- Register every state with the statemanager.

gSmgr:Init()
gSmgr:CreateState("Display", 		gSdisp)     -- This technically doesnt need to go to the statemanager
gSmgr:CreateState("MainApp",		Smain)

------------------------------------------------------------------------------------------------------------
-- Execute the statemanager loop
-- Exit only when all states have exited or expired.

-- Init folder system
gDir:Init()

-- Init display first
gSdisp:Init(WINwidth, WINheight, WINFullscreen)
gSdisp:Begin()

SobjMgr:Begin()

gSmgr:ChangeState("MainApp")
------------------------------------------------------------------------------------------------------------
-- Enter state manager loop
while gSdisp:GetRunApp() and gSmgr:Run() do

	local buttons 	= gSdisp:GetMouseButtons()
	local move 		= gSdisp:GetMouseMove()

	gSdisp:PreRender()
    gSmgr:Update(move.x, move.y, buttons)

    SobjMgr:Render()
	gSmgr:Render()
	
	-- This does a buffer flip.
	gSdisp:Flip()
end

------------------------------------------------------------------------------------------------------------

SobjMgr:Finish()

gSdisp:Finish()
gDir:Finalize()

------------------------------------------------------------------------------------------------------------
