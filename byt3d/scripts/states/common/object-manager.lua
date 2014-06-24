--
-- Created by David Lannan
-- User: grover
-- Date: 17/06/13
-- Time: 11:25 PM
-- Copyright 2013  Developed for use with the byt3d engine.
--
------------------------------------------------------------------------------------------------------------
-- State - Object Manager
--
-- Decription: Managers all objects in the byt3d system - same as a GameObject in Unity3D
--			    Object structure:
--                  - transform -> children
--                  - components
--                          Any types and multiple sets. Mesh, Anim, Light, Camera etc.
--                  - name
--                  - uid
------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------

local SGOmanager	= NewState()

------------------------------------------------------------------------------------------------------------
-- All game objects are here - will have filters for components and such.
SGOmanager.allobjects   = {}

local mm = require("scripts/states/common/mesh-manager")
SGOmanager.MgrMesh      = mm
local am = require("scripts/states/common/anim-manager")
SGOmanager.MgrAnim      = am
local pm = require("scripts/states/common/physics-manager")
SGOmanager.MgrPhysics   = pm
local cm = require("scripts/states/common/camera-manager")
SGOmanager.MgrCameras   = cm
local lm = require("scripts/states/common/light-manager")
SGOmanager.MgrLights    = lm
local em = require("scripts/states/common/emitter-manager")
SGOmanager.MgrEmitters  = em
local sm = require("scripts/states/common/sound-manager")
SGOmanager.MgrSounds    = sm
local tm = require("scripts/states/common/control-manager")
SGOmanager.MgrControls  = tm
local gm = require("scripts/states/common/gui-manager")
SGOmanager.MgrGui       = gm

------------------------------------------------------------------------------------------------------------
-- GameObject meta table - so we can do some nice things with gameobjects.
SGOmanager.GOmt         = {}

-- When gameobjects have their component names set, they are added to the
--   larger collections. This allows the manager to do appropriate updates and renders
--   on the right sort of collections.
--   The gameobject ends up with a "shortcut" property to use as well. go.mesh will return the gameobjects mesh

SGOmanager.GOmt.__newindex   = function(t, k, v)
    if k == "mesh" then
        SGOmanager.MgrMesh:Add(v)
    elseif k == "anim" then
        SGOmanager.MgrAnim:Add(v)
    elseif k == "phsyics" then
        SGOmanager.MgrPhysics:Add(v)
    elseif k == "camera" then
        SGOmanager.MgrCameras:Add(v)
    elseif k == "light" then
        SGOmanager.MgrLights:Add(v)
    elseif k == "emitter" then
        SGOmanager.MgrEmitters:Add(v)
    elseif k == "sound" then
        SGOmanager.MgrSounds:Add(v)
    elseif k == "control" then
        SGOmanager.MgrControls:Add(v)
    elseif k == "gui" then
        SGOmanager.MgrGui:Add(v)
    end

    -- Common to any component that is added
    table.insert(t.components, v)
    t[k] = v
end

------------------------------------------------------------------------------------------------------------
-- GameObjects are created and destroyed here.

function SGOmanager:CreateGameObject(name)

    local new_go = {
        name        = name,
        uid         = os.time(),
        transform   = Matrix44:New(),
        components  = {},
        children    = {},
        parent      = nil       -- default root GO
    }

    setmetatable(new_go, SGOmanager.GOmt)

    this.allobjects[new_go.uid] = new_go
    return new_go
end

------------------------------------------------------------------------------------------------------------
-- Need serialise and deserialise functions here  - Xml preferably.

function SGOmanager:ReadScene( filename )
end

function SGOmanager:WriteScene( filename )
end

------------------------------------------------------------------------------------------------------------

function SGOmanager:Begin()
    -- Clear all gameobjects at start - empty slate
    self.allobjects   = {}

    self.MgrMesh:Begin()
    self.MgrAnim:Begin()
    self.MgrPhysics:Begin()
    self.MgrCameras:Begin()
    self.MgrLights:Begin()
    self.MgrEmitters:Begin()
    self.MgrControls:Begin()
    self.MgrGui:Begin()
end

------------------------------------------------------------------------------------------------------------

function SGOmanager:Update(mxi, myi, buttons)

    -- All components that need updates are called upon
    self.MgrCameras:Update(mxi, myi, buttons) -- Cameras should be first. Most transforms are dependant on this.
    self.MgrControls:Update(mxi, myi, buttons)
    self.MgrPhysics:Update(mxi, myi, buttons)
    self.MgrLights:Update(mxi, myi, buttons)

    self.MgrAnim:Update(mxi, myi, buttons)
    self.MgrMesh:Update(mxi, myi, buttons)
    self.MgrEmitters:Update(mxi, myi, buttons)

    self.MgrGui:Update(mxi, myi, buttons)
end

------------------------------------------------------------------------------------------------------------

function SGOmanager:Render()

    self.MgrCameras:Render()   -- Cameras should be first. Most transforms are dependant on this.
    self.MgrControls:Render()  -- visualisation?
    self.MgrPhysics:Render()   -- May not be needed
    self.MgrLights:Render()    -- May not be needed (dont technically render lights)
    self.MgrMesh:Render()
    self.MgrAnim:Render()
    self.MgrEmitters:Render()
    self.MgrGui:Render()
end

------------------------------------------------------------------------------------------------------------

function SGOmanager:Finish()

    self.MgrMesh:Finish()
    self.MgrAnim:Finish()
    self.MgrPhysics:Finish()
    self.MgrCameras:Finish()
    self.MgrLights:Finish()
    self.MgrEmitters:Finish()
    self.MgrControls:Finish()
    self.MgrGui:Finish()
end

------------------------------------------------------------------------------------------------------------

return SGOmanager

------------------------------------------------------------------------------------------------------------
