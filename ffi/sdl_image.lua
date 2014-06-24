local ffi = require("ffi")

local libs = ffi_luajit_libs or {
   OSX     = { x86 = "bin/OSX/sdl_image.dylib", x64 = "bin/OSX/sdl_image.dylib" },
   Windows = { x86 = "bin/Windows/x86/sdl_image.dll", x64 = "bin/Windows/x64/sdl_image.dll" },
   Linux   = { x86 = "SDL", x64 = "bin/Linux/x64/libSDL_image.so", arm = "bin/Linux/arm/libSDL_image.so" },
   BSD     = { x86 = "bin/luajit32_image.so",  x64 = "bin/luajit64_image.so" },
   POSIX   = { x86 = "bin/luajit32_image.so",  x64 = "bin/luajit64_image.so" },
   Other   = { x86 = "bin/luajit32_image.so",  x64 = "bin/luajit64_image.so" },
}

local sdl_image  = ffi.load( ffi_SDL_image_lib or ffi_sdl_image_lib or libs[ ffi.os ][ ffi.arch ]  or "sdl_image" )

ffi.cdef[[

enum
{
    IMG_INIT_JPG = 0x00000001,
    IMG_INIT_PNG = 0x00000002,
    IMG_INIT_TIF = 0x00000004,
    IMG_INIT_WEBP = 0x00000008
};

/* Loads dynamic libraries and prepares them for use.  Flags should be
   one or more flags from IMG_InitFlags OR'd together.
   It returns the flags successfully initialized, or 0 on failure.
 */
int  IMG_Init(int flags);

/* Unloads libraries loaded with IMG_Init */
void  IMG_Quit(void);

/* Load an image from an SDL data source.
   The 'type' may be one of: "BMP", "GIF", "PNG", etc.

   If the image format supports a transparent pixel, SDL will set the
   colorkey for the surface.  You can enable RLE acceleration on the
   surface afterwards by calling:
	SDL_SetColorKey(image, SDL_RLEACCEL, image->format->colorkey);
 */
SDL_Surface *  IMG_LoadTyped_RW(SDL_RWops *src, int freesrc, char *type);
/* Convenience functions */
SDL_Surface *  IMG_Load(const char *file);
SDL_Surface *  IMG_Load_RW(SDL_RWops *src, int freesrc);

/* Invert the alpha of a surface for use with OpenGL
   This function is now a no-op, and only provided for backwards compatibility.
*/
int  IMG_InvertAlpha(int on);

/* Functions to detect a file type, given a seekable source */
int  IMG_isICO(SDL_RWops *src);
int  IMG_isCUR(SDL_RWops *src);
int  IMG_isBMP(SDL_RWops *src);
int  IMG_isGIF(SDL_RWops *src);
int  IMG_isJPG(SDL_RWops *src);
int  IMG_isLBM(SDL_RWops *src);
int  IMG_isPCX(SDL_RWops *src);
int  IMG_isPNG(SDL_RWops *src);
int  IMG_isPNM(SDL_RWops *src);
int  IMG_isTIF(SDL_RWops *src);
int  IMG_isXCF(SDL_RWops *src);
int  IMG_isXPM(SDL_RWops *src);
int  IMG_isXV(SDL_RWops *src);
int  IMG_isWEBP(SDL_RWops *src);

/* Individual loading functions */
SDL_Surface *  IMG_LoadICO_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadCUR_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadBMP_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadGIF_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadJPG_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadLBM_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadPCX_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadPNG_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadPNM_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadTGA_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadTIF_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadXCF_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadXPM_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadXV_RW(SDL_RWops *src);
SDL_Surface *  IMG_LoadWEBP_RW(SDL_RWops *src);

SDL_Surface *  IMG_ReadXPMFromArray(char **xpm);

]]

return sdl_image

