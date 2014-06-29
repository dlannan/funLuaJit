------------------------------------------------------------------------------------------------------------
--/*
-- * Created by David Lannan
-- * User: David Lannan
-- * Date: 5/31/2012
-- * Time: 9:57 PM
-- *
-- */
------------------------------------------------------------------------------------------------------------
-- Texture has to be pool managed.. TODO!!!
------------------------------------------------------------------------------------------------------------

local ffi 	= require( "ffi" )

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
require("shaders/liquid_blue")
------------------------------------------------------------------------------------------------------------
--	/// <summary>
--	/// Description of byt3dSprite.
--	/// </summary>
byt3dSprite =
{
	x				= 0,
	y 				= 0,
	xsize			= 1.0,
	ysize			= 1.0,
	zdepth			= -0.1,
	mesh 			= nil,
	
	name			= "",
	imageFile		= ""
}

------------------------------------------------------------------------------------------------------------

function byt3dSprite:New(name, imageFile)

	local newSpr = deepcopy(byt3dSprite)
	newSpr.name = name
	newSpr.imageFile = imageFile
	
	-- Load and build the shader for GUI 2D Rendering
	newSpr.uiShader = byt3dShader:NewProgram( colour_shader, gui_shader )
	newSpr.uiShader.name = "Shader_Sprite"

    -- Find the shader parameters we will use
	newSpr.loc_position = newSpr.uiShader.vertexArray
	newSpr.loc_texture  = newSpr.uiShader.texCoordArray[0]

	newSpr.loc_res      = newSpr.uiShader.loc_res
	newSpr.loc_time     = newSpr.uiShader.loc_time
		
	local tex0 = byt3dTexture:New()
	tex0:FromSDLImage(newSpr.name, newSpr.imageFile)
	
    newSpr.mesh = byt3dMesh:New()
    newSpr.mesh:SetShader(newSpr.uiShader)
    newSpr.mesh:SetTexture(tex0)
    newSpr.mesh.alpha = 1.0

	newSpr.xscale = tex0.w / gSdisp.WINwidth
	newSpr.yscale = tex0.h / gSdisp.WINheight
	return newSpr
end

------------------------------------------------------------------------------------------------------------
-- BROKEN?? Need to fix
function byt3dSprite:Copy()

	local newSpr = deepcopy(self)
	return newSpr
end

------------------------------------------------------------------------------------------------------------

function byt3dSprite:Destroy()

	self.mesh.tex0 = nil
	self.mesh = nil
end

------------------------------------------------------------------------------------------------------------

function byt3dSprite:CheckPool()

	-- Add the texture into the texture pool
	local tpool = byt3dPool:GetPool(byt3dPool.SPRITES_NAME)
	if TexExtension.texIdCache ~= tpool or tpool == nil then

		if tpool == nil then 
			tpool = poolm:New(byt3dPool.SPRITES_NAME)
		end
		TexExtension.texIdCache = tpool
	end
end

------------------------------------------------------------------------------------------------------------

function byt3dSprite:GenTexName(tex)

	local tname = string.gsub( self.textureName, "[%p%/%\\]", "_")
	local tctx = tostring(gSdisp.eglInfo.ctx)
	local ctxname = string.gsub( tctx , "cdata%<void %*%>%:% ", "")
	local texid = string.format("%s_%s", tname, ctxname)
	return texid
end

------------------------------------------------------------------------------------------------------------
--    /// <summary>
--    /// Draw the sprite on the current display
--    /// </summary>
--    /// <param name="x">position of the sprite</param>
--    /// <param name="y">Position of the sprite</param>
------------------------------------------------------------------------------------------------------------

function byt3dSprite:Prepare()

	byt3dRender:ChangeShader(self.uiShader)
	gl.glDisable ( gl.GL_DEPTH_TEST )
	gl.glBlendFunc ( gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)

	gl.glUniform2f(self.loc_res, gSdisp.WINwidth, gSdisp.WINheight )
	gl.glUniform1f(self.loc_time, os.clock())

	gl.glActiveTexture(gl.GL_TEXTURE0)
	gl.glBindTexture(gl.GL_TEXTURE_2D, self.mesh.tex0.textureId)
	gl.glUniform1i(self.uiShader.samplerTex[0], 0)
end

------------------------------------------------------------------------------------------------------------
--    /// <summary>
--    /// Draw the sprite on the current display
--    /// </summary>
--    /// <param name="x">position of the sprite</param>
--    /// <param name="y">Position of the sprite</param>
------------------------------------------------------------------------------------------------------------

function byt3dSprite:Draw(x, y)

	self.x = x
	self.y = y
	self.mesh:RenderTextureRect(self.x, self.y, self.xscale, self.yscale, self.zdepth )
end

------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------