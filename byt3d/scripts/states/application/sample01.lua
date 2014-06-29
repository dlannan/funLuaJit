------------------------------------------------------------------------------------------------------------
-- State - Render the Star field (clips for client)
--
-- Decription: 	Render the star field
--				Clips the starfield to the viewport
--				Renders info about the stars (exploder for stars)

------------------------------------------------------------------------------------------------------------

-- Do not assign a camera, a default one is created.
require("framework/byt3dSprite")

------------------------------------------------------------------------------------------------------------

--local csv = require("scripts/utils/csv")
	
local Ssample1	= NewState()

------------------------------------------------------------------------------------------------------------

Ssample1.WIDTH			= 1280
Ssample1.HEIGHT			= 720

Ssample1.image 			= nil

------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------

function Ssample1:Begin()

	byt3dRender:Init()
	
	self.sprite = byt3dSprite:New("img1", "byt3d/data/images/galaxy/star.png")
	self.bg = byt3dSprite:New("img2", "byt3d/data/images/galaxy/star.png")
	
	-- Reassign the size and uishader to something a little different :)
	self.bg.xscale = 2.0
	self.bg.yscale = 2.0
	self.bg.uiShader = byt3dShader:NewProgram( colour_shader, liquid_blue_shader_frag )
end

------------------------------------------------------------------------------------------------------------

function Ssample1:Update(mxi, myi, buttons)

	posx = mxi / gSdisp.WINwidth * 2.0 - 1.0
	posy = 1.0 - (myi / gSdisp.WINheight * 2.0) 
end

------------------------------------------------------------------------------------------------------------

function Ssample1:Render()

	self.bg:Prepare()
	self.bg:Draw(-1, -1)
	
	self.sprite:Prepare()
	self.sprite:Draw(posx, posy)
end

------------------------------------------------------------------------------------------------------------

function Ssample1:Finish()
end
	
------------------------------------------------------------------------------------------------------------

return Ssample1

------------------------------------------------------------------------------------------------------------
	