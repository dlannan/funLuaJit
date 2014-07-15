------------------------------------------------------------------------------------------------------------
-- State - Render the Star field (clips for client)
--
-- Decription: 	Render the star field
--				Clips the starfield to the viewport
--				Renders info about the stars (exploder for stars)

------------------------------------------------------------------------------------------------------------

-- Do not assign a camera, a default one is created.
require("framework/byt3dSprite")

tween = require("scripts/utils/tween")

------------------------------------------------------------------------------------------------------------

--local csv = require("scripts/utils/csv")
	
local Ssample1	= NewState()

------------------------------------------------------------------------------------------------------------

Ssample1.WIDTH			= 1280
Ssample1.HEIGHT			= 720

Ssample1.image 			= nil
Ssample1.particleId		= 1
Ssample1.all_particles = {}

------------------------------------------------------------------------------------------------------------

local particleType 	= {
	id = 0,
	age = 0.0,
	color={1, 1, 1, 1},
	size_tween 	= nil,
	move_tween	= nil,
	color_tween = nil,
	life_tween 	= nil
}

------------------------------------------------------------------------------------------------------------

function RemoveParticle( p )

	Ssample1.all_particles[p.id] = nil
	local startx = math.random()  - 0.5
	local end_color = { math.random(), math.random(), math.random(), 0.0 }
	Ssample1:CreateParticle(Ssample1.star, math.random() * 2.0, startx, -0.8, startx, 0.5, end_color)
end

------------------------------------------------------------------------------------------------------------

function Ssample1:CreateSprite(imgid, imgfile)
	local spr = byt3dSprite:New(imgid, imgfile)
	spr.mesh.alpha 	= 0.5	
	spr.alpha_src 	= gl.GL_ONE
	spr.alpha_dst 	= gl.GL_DST_COLOR
	spr.color = ffi.new("Colorf", { 1, 0, 1, 1 })
	return spr
end

------------------------------------------------------------------------------------------------------------

function Ssample1:CreateParticle(stype, lifetime, x, y, maxx, maxy, end_color)
	
	local part = deepcopy(particleType)
	part.id = Ssample1.particleId
	Ssample1.particleId = Ssample1.particleId + 1
	
	part.sprite = stype
	part.posx = x
	part.posy = y
	
	part.color_tween = tween( lifetime, part, { color=end_color }, 'inQuad', nil, nil )
	part.x_tween = tween( lifetime, part, { posx=maxx }, 'inQuad', nil, nil )
	part.y_tween = tween( lifetime, part, { posy=maxy }, 'inQuad', nil, nil )
	part.life_tween = tween( lifetime, part, { age=1.0 }, 'inQuad', RemoveParticle, part )
	Ssample1.all_particles[part.id] = part
end

------------------------------------------------------------------------------------------------------------

function Ssample1:Begin()

	byt3dRender:Init()
	
	Ssample1.star = self:CreateSprite("img1", "byt3d/data/images/galaxy/star.png")
	for i=0, 500 do 
		local startx = math.random()  - 0.5
		local end_color = { math.random(), math.random(), math.random(), 0.0 }
		self:CreateParticle(Ssample1.star, math.random() * 2.0, startx, -0.8, startx, 0.5, end_color)
	end
	
	self.timeLast = 0.0
end

------------------------------------------------------------------------------------------------------------

function Ssample1:Update(mxi, myi, buttons)

	-- Update the tweening 
	local timeNow = os.clock()
	local timeDiff = timeNow - self.timeLast
	self.timeLast = timeNow
	tween.update(timeDiff)
	
end

------------------------------------------------------------------------------------------------------------

function Ssample1:Render()

	Ssample1.star:Prepare()
	for k,v in pairs(self.all_particles) do
		v.sprite.color.r = v.color[1]
		v.sprite.color.g = v.color[2]
		v.sprite.color.b = v.color[3]
		v.sprite.color.a = v.color[4]
		v.sprite:SetColor()
		v.sprite:Draw(v.posx, v.posy)
	end
end

------------------------------------------------------------------------------------------------------------

function Ssample1:Finish()

end
	
------------------------------------------------------------------------------------------------------------

return Ssample1

------------------------------------------------------------------------------------------------------------
	