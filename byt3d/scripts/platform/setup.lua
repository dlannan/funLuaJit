
BYT3D_VERSION		= release.."."..subversion

------------------------------------------------------------------------------------------------------------
-- Setup the root file path to use.
ffi     = require( "ffi" )
print("ffi.os : "..ffi.os)
if ffi.os == "OSX" then
    package.path 		= package.path..";clibs/?.lua"
    package.path 		= package.path..";lua/?.lua"
    package.path 		= package.path..";byt3d/?.raw"
    package.path 		= package.path..";?.raw"

    package.cpath       = package.cpath..";./bin/OSX/?.dylib"
    print(package.path)

    lfs   = require("lfs")
end

------------------------------------------------------------------------------------------------------------
-- Linux
if ffi.os == "Linux" then
    package.path 		= package.path..";clibs/?.lua"
    package.path 		= package.path..";lua/?.lua"

--    package.path 		= package.path..";byt3d\\?.raw"
--    package.path 		= package.path..";?.raw"
    package.path 		= package.path..";byt3d/?.lua"
    package.path 		= package.path..";?.lua"
--
--    kernel32 	= ffi.load( "kernel32.dll" )
--    user32 	    = ffi.load( "user32.dll" )
--    comdlg32    = ffi.load( "Comdlg32.dll" )
--    gdi32       = ffi.load( "gdi32.dll" )
--
--     require("byt3d/ffi/win32")

--    lfs   = require("lfs")
end

------------------------------------------------------------------------------------------------------------
-- Windows direct access - mainly for keys ( TODO: will reduce this later on )
if ffi.os == "Windows" then
    package.path 		= package.path..";clibs/?.lua"
    package.path 		= package.path..";lua/?.lua"

--    package.path 		= package.path..";byt3d\\?.raw"
--    package.path 		= package.path..";?.raw"
    package.path 		= package.path..";byt3d\\?.lua"
    package.path 		= package.path..";?.lua"
--
--    kernel32 	= ffi.load( "kernel32.dll" )
--    user32 	    = ffi.load( "user32.dll" )
--    comdlg32    = ffi.load( "Comdlg32.dll" )
--    gdi32       = ffi.load( "gdi32.dll" )
--
    require("byt3d/ffi/win32")

--    lfs   = require("lfs")
end

------------------------------------------------------------------------------------------------------------
-- Setup OpenGLES2
gl      = require( "ffi/OpenGLES2" )

------------------------------------------------------------------------------------------------------------