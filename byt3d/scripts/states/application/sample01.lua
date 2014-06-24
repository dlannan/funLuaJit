------------------------------------------------------------------------------------------------------------
-- State - Render the Star field (clips for client)
--
-- Decription: 	Render the star field
--				Clips the starfield to the viewport
--				Renders info about the stars (exploder for stars)

------------------------------------------------------------------------------------------------------------

-- Do not assign a camera, a default one is created.
require("framework/byt3dCamera")
byt3dRender 		= require("framework/byt3dRender")
require("framework/byt3dShader")
require("framework/byt3dTexture")
require("framework/byt3dMesh")

------------------------------------------------------------------------------------------------------------

require("scripts/utils/geometry")
require("shaders/base")
local csv = require("scripts/utils/csv")
	
local SstarsBG	= NewState()

------------------------------------------------------------------------------------------------------------

SstarsBG.RA				= 0.0		-- Right Ascension (Yaw.. is another way to describe it :) )
SstarsBG.Dec			= 0.0		-- Declination (Pitch is similar..)

SstarsBG.HFOV			= 360.0		-- These can be dynamically set - clipping and scaling is done using these fovs
SstarsBG.VFOV			= 180.0

SstarsBG.minRA			= SstarsBG.RA
SstarsBG.maxRA			= SstarsBG.RA + SstarsBG.HFOV 
SstarsBG.minDec			= SstarsBG.Dec
SstarsBG.maxDec			= SstarsBG.Dec + SstarsBG.VFOV 


local star_image		= nil
local star_catalog 		= {}

SstarsBG.HEIGHT			= 720
SstarsBG.WIDTH				= 1280
SstarsBG.V_HEIGHT			= 720
SstarsBG.V_WIDTH				= 1280

------------------------------------------------------------------------------------------------------------

local function ConvertData( ra1, ra2, dec1, dec2)
	local decsec = (dec2 - math.floor(dec2)) 
	dec_deg = dec1 + (math.floor(dec2) / 60) + decsec
	local rasec = (ra2 - math.floor(ra2)) 
	ra_deg = 360 * (ra1 + (math.floor(ra2) / 60) + rasec) / 24
	
	return ra_deg, dec_deg  
end

------------------------------------------------------------------------------------------------------------

local function RecalcMinMax()

	SstarsBG.minRA			= SstarsBG.RA
	SstarsBG.maxRA			= SstarsBG.RA + SstarsBG.HFOV 
	SstarsBG.minDec			= SstarsBG.Dec
	SstarsBG.maxDec			= SstarsBG.Dec + SstarsBG.VFOV 
end

------------------------------------------------------------------------------------------------------------

function SstarsBG:DrawStar(name, ra, dec)

	-- Work out the X/Y (this is real simple.. no space curvature.. will do that later..)
	star_image.x = (ra - SstarsBG.minRA) / (SstarsBG.maxRA - SstarsBG.minRA) * 2.0 - 1.0
	star_image.y = (dec - SstarsBG.minDec) / (SstarsBG.maxDec - SstarsBG.minDec) * 2.0 - 1.0
	--Gcairo:RenderImage(star_image.enableImage, star_image.x, star_image.y, 0.0)
	local sw = star_image.mesh.tex0.w/self.V_WIDTH
	local sh = star_image.mesh.tex0.h/self.V_HEIGHT
	star_image.mesh:RenderTextureRect(star_image.x, star_image.y, sw, sh, -0.1 )
	--print(star_image.src.x, star_image.src.y)
	--local tw, th = Gcairo:GetTextSize(name, 20.0)
	-- Need valid vertical and horizontal values
	if (tw ~= 0) and (th ~= 0) then 
		--Gcairo:RenderText(name, star_image.x - tw * 0.5 + 32.0, star_image.y - th, 20.0)
	end
end

------------------------------------------------------------------------------------------------------------

function SstarsBG:Begin()

	byt3dRender:Init()
	local render = sdl.SDL_GetRenderer(gSdisp.wm.display)
		
	print(gSdisp.wm.display)
	
	-- Load and build the shader for cairo
	-- self.uiShader = MakeShader( colour_shader, gui_shader )
	self.uiShader = byt3dShader:NewProgram( colour_shader, gui_shader )
	self.uiShader.name = "Shader_Gui"

    -- Find the shader parameters we will use
	self.loc_position = self.uiShader.vertexArray
	self.loc_texture  = self.uiShader.texCoordArray[0]

	self.loc_res      = self.uiShader.loc_res
	self.loc_time     = self.uiShader.loc_time
	
	
	local newtex = byt3dTexture:New()
	newtex:FromSDLImage("star1", "byt3d/data/images/galaxy/star.png")
	
    local newmesh = byt3dMesh:New()
    newmesh:SetShader(self.uiShader)
    newmesh:SetTexture(newtex)
    newmesh.alpha = 1.0

	star_image = { 
			x=0, y=0, enabled=1, angle = 0.0, scalex = 1.0, scaley = 1.0,
			--enableImage=Gcairo:LoadImage("starImage", "byt3d/data/images/galaxy/star.png")
			mesh = newmesh
	}	

	local star_file = csv.open("byt3d/data/csv/stars-50lyr.csv")
	-- TODO: This is a little slow.. meh! Will fix later.
	star_catalog = {}
	local line_count = 1
	for ln in star_file:lines() do

		ln[1] = utf2lat(ln[1])
		local tbl = {}
		for i, v in ipairs(ln) do 
			tbl[i] = v
			if i > 1 and i < 6 then tbl[i] = tonumber(v) end
		end
		star_catalog[line_count] = tbl
		line_count = line_count + 1
	end
end

------------------------------------------------------------------------------------------------------------

function SstarsBG:Update(mxi, myi, buttons)

	--Gcairo:Begin()
	local decHeight = self.HEIGHT * 0.5
	SstarsBG.RA = (mxi / self.WIDTH) * 360.0
	SstarsBG.Dec = (myi - decHeight) / self.HEIGHT * SstarsBG.VFOV
	if(SstarsBG.RA > 360.0) then SstarsBG.RA = 0.0 end
	if(SstarsBG.RA < 0.0) then SstarsBG.RA = 360.0 end
	
	RecalcMinMax()
end

------------------------------------------------------------------------------------------------------------

function SstarsBG:Render()
	
	byt3dRender:ChangeShader(self.uiShader)
	gl.glDisable ( gl.GL_DEPTH_TEST )
	gl.glBlendFunc ( gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)

	gl.glUniform2f(self.loc_res, self.WIDTH, self.HEIGHT )
	gl.glUniform1f(self.loc_time, os.clock())

	gl.glActiveTexture(gl.GL_TEXTURE0)
	gl.glBindTexture(gl.GL_TEXTURE_2D, star_image.mesh.tex0.textureId)
	gl.glUniform1i(self.uiShader.samplerTex[0], 0)

	-- If it falls within the min/max then render it!
	for k, v in ipairs(star_catalog) do
		if(v[1] ~= "Sun") then
			-- Star data is in column format: 1-Name  2+3-RA  4+5-Dec
			local ra, dec = ConvertData( v[2], v[3], v[4], v[5] )
--			if ra > SstarsBG.minRA and ra < SstarsBG.maxRA and dec > SstarsBG.minDec and dec < SstarsBG.maxDec then
				-- Draw Icon 
				self:DrawStar( v[1], ra, dec)
--			end
		end
	end	  
end

------------------------------------------------------------------------------------------------------------

function SstarsBG:Finish()
end
	
------------------------------------------------------------------------------------------------------------

return SstarsBG

------------------------------------------------------------------------------------------------------------
	