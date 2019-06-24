library gfxcore;

{ timcseee graphix library made by proof in 2006-2007 }
{ minden kívülrõl elérhetõ azonosító prefixe tmcs }

uses
  SysUtils,
  Classes,
  Windows,
  Dialogs,
  Math,
  OpenGL,
  cwnd in 'cwnd.pas' {frm_c},
  u_loading in 'u_loading.pas' {frm_loading};

function gluBuild2DMipmaps(Target: GLenum; Components, Width, Height: GLint; Format, atype: GLenum; Data: Pointer): GLint; stdcall; external glu32;
procedure glGenTextures(n: GLsizei; var textures: GLuint); stdcall; external opengl32;
procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;
procedure glDeleteTextures(n: GLsizei; textures: PGLuint); stdcall; external opengl32;
procedure glCopyTexImage2D(target : GLenum; level : GLint; internalformat : GLenum; x : GLint; y : GLint; width : GLsizei; height : GLsizei; border : GLint); stdcall; external opengl32;

const
  { OGL konstansok, amik nincsenek benne az OpenGL-pas-ban }
  GL_CLAMP_TO_BORDER = $812D;
  GL_CLAMP_TO_EDGE = $812F;

  GL_CONSTANT_ALPHA_EXT = $8003;
  GL_ONE_MINUS_CONSTANT_ALPHA_EXT = $8004;
  GL_CLIP_VOLUME_CLIPPING_HINT_EXT = $80F0;
  GL_CULL_VERTEX_EXT = $81AA;

  GL_ACTIVE_TEXTURE_ARB               = $84E0;
  GL_CLIENT_ACTIVE_TEXTURE_ARB        = $84E1;
  GL_MAX_TEXTURE_UNITS_ARB            = $84E2;
  GL_TEXTURE0_ARB                     = $84C0;
  GL_TEXTURE1_ARB                     = $84C1;
  GL_TEXTURE2_ARB                     = $84C2;
  GL_TEXTURE3_ARB                     = $84C3;
  GL_TEXTURE4_ARB                     = $84C4;
  GL_TEXTURE5_ARB                     = $84C5;
  GL_TEXTURE6_ARB                     = $84C6;
  GL_TEXTURE7_ARB                     = $84C7;
  GL_TEXTURE8_ARB                     = $84C8;
  GL_TEXTURE9_ARB                     = $84C9;

  GL_COMBINE_EXT                                    = $8570;
  GL_COMBINE_RGB_EXT                                = $8571;
  GL_COMBINE_ALPHA_EXT                              = $8572;
  GL_RGB_SCALE_EXT                                  = $8573;
  GL_ADD_SIGNED_EXT                                 = $8574;
  GL_INTERPOLATE_EXT                                = $8575;
  GL_CONSTANT_EXT                                   = $8576;
  GL_PRIMARY_COLOR_EXT                              = $8577;
  GL_PREVIOUS_EXT                                   = $8578;
  GL_SOURCE0_RGB_EXT                                = $8580;
  GL_SOURCE1_RGB_EXT                                = $8581;
  GL_SOURCE2_RGB_EXT                                = $8582;
  GL_SOURCE0_ALPHA_EXT                              = $8588;
  GL_SOURCE1_ALPHA_EXT                              = $8589;
  GL_SOURCE2_ALPHA_EXT                              = $858A;
  GL_OPERAND0_RGB_EXT                               = $8590;
  GL_OPERAND1_RGB_EXT                               = $8591;
  GL_OPERAND2_RGB_EXT                               = $8592;
  GL_OPERAND0_ALPHA_EXT                             = $8598;
  GL_OPERAND1_ALPHA_EXT                             = $8599;
  GL_OPERAND2_ALPHA_EXT                             = $859A;

  GL_COMBINE_RGB_ARB             =   $8571;
  GL_COMBINE_ALPHA_ARB           =   $8572;
  GL_SOURCE0_RGB_ARB             =   $8580;
  GL_SOURCE1_RGB_ARB             =   $8581;
  GL_SOURCE2_RGB_ARB             =   $8582;
  GL_SOURCE0_ALPHA_ARB           =   $8588;
  GL_SOURCE1_ALPHA_ARB           =   $8589;
  GL_SOURCE2_ALPHA_ARB           =   $858A;
  GL_OPERAND0_RGB_ARB            =   $8590;
  GL_OPERAND1_RGB_ARB            =   $8591;
  GL_OPERAND2_RGB_ARB            =   $8592;
  GL_OPERAND0_ALPHA_ARB          =   $8598;
  GL_OPERAND1_ALPHA_ARB          =   $8599;
  GL_OPERAND2_ALPHA_ARB          =   $859A;
  GL_RGB_SCALE_ARB               =   $8573;
  GL_ADD_SIGNED_ARB              =   $8574;
  GL_COMBINE_ARB                 =   $8570;

  GL_INTERPOLATE_ARB               = $8575;
  GL_SUBTRACT_ARB                  = $84E7;
  GL_CONSTANT_ARB                  = $8576;
  GL_PRIMARY_COLOR_ARB             = $8577;
  GL_PREVIOUS_ARB                  = $8578;

  COMPRESSED_RGB_S3TC_DXT1_EXT     = $83F0;
  COMPRESSED_RGBA_S3TC_DXT1_EXT    = $83F1;
  COMPRESSED_RGBA_S3TC_DXT3_EXT    = $83F2;
  COMPRESSED_RGBA_S3TC_DXT5_EXT    = $83F3;

  GL_COMPRESSED_ALPHA_ARB               = $84E9;
  GL_COMPRESSED_LUMINANCE_ARB           = $84EA;
  GL_COMPRESSED_LUMINANCE_ALPHA_ARB     = $84EB;
  GL_COMPRESSED_INTENSITY_ARB           = $84EC;
  GL_COMPRESSED_RGB_ARB                 = $84ED;
  GL_COMPRESSED_RGBA_ARB                = $84EE;

  GL_TEXTURE_COMPRESSION_HINT_ARB       = $84EF;

  GL_TEXTURE_COMPRESSED_IMAGE_SIZE_ARB  = $86A0;
  GL_TEXTURE_COMPRESSED_ARB             = $86A1;

  GL_NUM_COMPRESSED_TEXTURE_FORMATS_ARB = $86A2;
  GL_COMPRESSED_TEXTURE_FORMATS_ARB     = $86A3;

  { motion blur-rel kapcsolatos konstansok }
  MOTIONBLUR_DEF_RED = 255;          // motion blur alapszínének vörös összetevõje
  MOTIONBLUR_DEF_GREEN = 255;        // motion blur alapszínének zöld összetevõje
  MOTIONBLUR_DEF_BLUE = 255;         // motion blur alapszínének kék összetevõje
  MOTIONBLUR_DEF_ALPHA = 178;        // minél kisebb, annál kisebb az objektumok elmosása
  MOTIONBLUR_DEF_RATE = 1;           // = n. Minden n. képkocka rajzolásnál másolja ki a frame buffer tartalmát

  FONT_PLANE_HEIGHT = 32;            // ekkora magas lapon lesznek az egyek karakterek


type
  { OGL multitextúrázással kapcsolatos extension-függõ függvényei }
  PFNGLMULTITEXCOORD1DARBPROC = procedure(target: GLenum; s: GLdouble); stdcall;
  PFNGLMULTITEXCOORD1DVARBPROC = procedure(target: GLenum; const v: PGLdouble); stdcall;
  PFNGLMULTITEXCOORD1FARBPROC = procedure(target: GLenum; s: GLfloat); stdcall;
  PFNGLMULTITEXCOORD1FVARBPROC = procedure(target: GLenum; const v: PGLfloat); stdcall;
  PFNGLMULTITEXCOORD1IARBPROC = procedure(target: GLenum; s: GLint); stdcall;
  PFNGLMULTITEXCOORD1IVARBPROC = procedure(target: GLenum; const v: PGLint); stdcall;
  PFNGLMULTITEXCOORD1SARBPROC = procedure(target: GLenum; s: GLshort); stdcall;
  PFNGLMULTITEXCOORD1SVARBPROC = procedure(target: GLenum; const v: PGLshort); stdcall;
  PFNGLMULTITEXCOORD2DARBPROC = procedure(target: GLenum; s: GLdouble; t: GLdouble); stdcall;
  PFNGLMULTITEXCOORD2DVARBPROC = procedure(target: GLenum; const v: GLdouble); stdcall;
  PFNGLMULTITEXCOORD2FARBPROC = procedure(target: GLenum; s: GLfloat; t: GLfloat); stdcall;
  PFNGLMULTITEXCOORD2FVARBPROC = procedure(target: GLenum; const v: PGLfloat); stdcall;
  PFNGLMULTITEXCOORD2IARBPROC = procedure(target: GLenum; s: GLint; t: GLint); stdcall;
  PFNGLMULTITEXCOORD2IVARBPROC = procedure(target: GLenum; const v: PGLint); stdcall;
  PFNGLMULTITEXCOORD2SARBPROC = procedure(target: GLenum; s: GLshort; t: GLshort); stdcall;
  PFNGLMULTITEXCOORD2SVARBPROC = procedure(target: GLenum; const v: PGLshort); stdcall;
  PFNGLMULTITEXCOORD3DARBPROC = procedure(target: GLenum; s: GLdouble; t: GLdouble; r: GLdouble); stdcall;
  PFNGLMULTITEXCOORD3DVARBPROC = procedure(target: GLenum; const v: GLdouble); stdcall;
  PFNGLMULTITEXCOORD3FARBPROC = procedure(target: GLenum; s: GLfloat; t: GLfloat; r: GLfloat); stdcall;
  PFNGLMULTITEXCOORD3FVARBPROC = procedure(target: GLenum; const v: PGLfloat); stdcall;
  PFNGLMULTITEXCOORD3IARBPROC = procedure(target: GLenum; s: GLint; t: GLint; r: GLint); stdcall;
  PFNGLMULTITEXCOORD3IVARBPROC = procedure(target: GLenum; const v: PGLint); stdcall;
  PFNGLMULTITEXCOORD3SARBPROC = procedure(target: GLenum; s: GLshort; t: GLshort; r: GLshort); stdcall;
  PFNGLMULTITEXCOORD3SVARBPROC = procedure(target: GLenum; const v: PGLshort); stdcall;
  PFNGLMULTITEXCOORD4DARBPROC = procedure(target: GLenum; s: GLdouble; t: GLdouble; r: GLdouble; q: GLdouble); stdcall;
  PFNGLMULTITEXCOORD4DVARBPROC = procedure(target: GLenum; const v: GLdouble); stdcall;
  PFNGLMULTITEXCOORD4FARBPROC = procedure(target: GLenum; s: GLfloat; t: GLfloat; r: GLfloat; q: GLfloat); stdcall;
  PFNGLMULTITEXCOORD4FVARBPROC = procedure(target: GLenum; const v: PGLfloat); stdcall;
  PFNGLMULTITEXCOORD4IARBPROC = procedure(target: GLenum; s: GLint; t: GLint; r: GLint; q: GLint); stdcall;
  PFNGLMULTITEXCOORD4IVARBPROC = procedure(target: GLenum; const v: PGLint); stdcall;
  PFNGLMULTITEXCOORD4SARBPROC = procedure(target: GLenum; s: GLshort; t: GLshort; r: GLshort; q: GLshort); stdcall;
  PFNGLMULTITEXCOORD4SVARBPROC = procedure(target: GLenum; const v: PGLshort); stdcall;
  PFNGLACTIVETEXTUREARBPROC = procedure(target: GLenum); stdcall;
  PFNGLCLIENTACTIVETEXTUREARBPROC = procedure(target: GLenum); stdcall;

  TSTR40 = string[40];
  TSTR255 = string[255];
  TFileName = TSTR255;
  HWND = THandle;
  HDC = LongWord;
  TGLConst = 0..32767;
  TBlendMode = record
                 sfactor,dfactor: GLenum;
               end;
  TRGB = record
           r: byte;
           g: byte;
           b: byte;
         end;
  TRGBA = record
            r: byte;
            g: byte;
            b: byte;
            a: byte;
          end;
  PVertex = ^TVertex;
  TVertex = record
              x,y,z: GLfloat;
              nx,ny,nz: GLfloat;
              color: TRGBA;
              u,v: GLfloat;
            end;
  PFace = ^TFace;
  TFace = record
            vertices: array[0..3] of Word;
            uvcoords: array[0..3] of word;
            tex: GLuint;
          end;
  PUVW = ^TUVW;
  TUVW = record
           u,v,w: GLfloat;
         end;
  PSubmodel = ^TSubmodel;
  TSubmodel = record
                name: TSTR40;
                vertices: TList;
                uvwcoords: TList;
                faces: TList;
                textured: boolean;
                posx,posy,posz: GLfloat;
                sizex,sizey,sizez: GLfloat;
                visible: boolean;
                displaylist: GLuint;
              end;
  PModel = ^TModel;
  TModel = record
             name: TSTR40;
             posx,posy,posz: GLfloat;
             sizex,sizey,sizez: GLfloat;
             anglex,angley,anglez: GLfloat;
             scaling: GLfloat;
             textured,blended,affectedbylights,doublesided: boolean;
             blendmode: TBlendMode;
             wireframe,visible,tessellated: boolean;
             zbuffered: boolean;
             submodels: tlist;
             compiled: boolean;
             sticked: boolean;
             colorkey: TRGBA;
             multitextured: boolean;
             multitexassigned: integer;
             rotationxzy: boolean;
             reference: integer;
           end;
  PTexture = ^TTexture;
  TTexture = record
               filename: TFilename;
               width,height: word;
               mipmapped: boolean;
               internalnum: GLuint;
             end;
  TCamera = record
              posx,posy,posz: GLfloat;
              anglex,angley,anglez: GLfloat;
              fov: GLdouble;
              aspect: GLdouble;
              zFar,zNear: GLdouble;
              targettex_w, targettex_h: integer;
            end;
  TLights = record
              light_ambient: array[0..3] of GLfloat;
            end;
  TTexMode = record
               mipmapping,compression: boolean;
               filtering,envmode: TGLConst;
               border: byte;
               wrap_s,wrap_t: TGLConst;
             end;
  TWorld = record
             Objects: TList;
             Textures: TList;
             Camera: TCamera;
             Lights: TLights;
             extobjectstexmode: TTexMode;
           end;
  TGammaRamp = record
                 red,green,blue: array[0..255] of word;
               end;
  THardwareInfo = record
                    glversion: string;
                    renderer: string;
                    glexts: string;
                    totalmemory,freememory: longint;
                    gammaramp_orig,gammaramp_mod: TGammaRamp;
                    numtmu: integer;
                    hwtc: boolean;
                  end;
  PText = ^TText;
  TText = record
            txt: tstr255;
            x,y: word;
            scaling: word;
            height: word;
            color: TRGBA;
          end;

var
  wglSwapIntervalEXT: function(interval: GLint): Boolean; stdcall;
  glMultiTexCoord1dARB: PFNGLMULTITEXCOORD1DARBPROC;
  glMultiTexCoord1dvARB: PFNGLMULTITEXCOORD1DVARBPROC;
  glMultiTexCoord1fARB: PFNGLMULTITEXCOORD1FARBPROC;
  glMultiTexCoord1fvARB: PFNGLMULTITEXCOORD1FVARBPROC;
  glMultiTexCoord1iARB: PFNGLMULTITEXCOORD1IARBPROC;
  glMultiTexCoord1ivARB: PFNGLMULTITEXCOORD1IVARBPROC;
  glMultiTexCoord1sARB: PFNGLMULTITEXCOORD1SARBPROC;
  glMultiTexCoord1svARB: PFNGLMULTITEXCOORD1SVARBPROC;
  glMultiTexCoord2dARB: PFNGLMULTITEXCOORD2DARBPROC;
  glMultiTexCoord2dvARB: PFNGLMULTITEXCOORD2DVARBPROC;
  glMultiTexCoord2fARB: PFNGLMULTITEXCOORD2FARBPROC;
  glMultiTexCoord2fvARB: PFNGLMULTITEXCOORD2FVARBPROC;
  glMultiTexCoord2iARB: PFNGLMULTITEXCOORD2IARBPROC;
  glMultiTexCoord2ivARB: PFNGLMULTITEXCOORD2IVARBPROC;
  glMultiTexCoord2sARB: PFNGLMULTITEXCOORD2SARBPROC;
  glMultiTexCoord2svARB: PFNGLMULTITEXCOORD2SVARBPROC;
  glMultiTexCoord3dARB: PFNGLMULTITEXCOORD3DARBPROC;
  glMultiTexCoord3dvARB: PFNGLMULTITEXCOORD3DVARBPROC;
  glMultiTexCoord3fARB: PFNGLMULTITEXCOORD3FARBPROC;
  glMultiTexCoord3fvARB: PFNGLMULTITEXCOORD3FVARBPROC;
  glMultiTexCoord3iARB: PFNGLMULTITEXCOORD3IARBPROC;
  glMultiTexCoord3ivARB: PFNGLMULTITEXCOORD3IVARBPROC;
  glMultiTexCoord3sARB: PFNGLMULTITEXCOORD3SARBPROC;
  glMultiTexCoord3svARB: PFNGLMULTITEXCOORD3SVARBPROC;
  glMultiTexCoord4dARB: PFNGLMULTITEXCOORD4DARBPROC;
  glMultiTexCoord4dvARB: PFNGLMULTITEXCOORD4DVARBPROC;
  glMultiTexCoord4fARB: PFNGLMULTITEXCOORD4FARBPROC;
  glMultiTexCoord4fvARB: PFNGLMULTITEXCOORD4FVARBPROC;
  glMultiTexCoord4iARB: PFNGLMULTITEXCOORD4IARBPROC;
  glMultiTexCoord4ivARB: PFNGLMULTITEXCOORD4IVARBPROC;
  glMultiTexCoord4sARB: PFNGLMULTITEXCOORD4SARBPROC;
  glMultiTexCoord4svARB: PFNGLMULTITEXCOORD4SVARBPROC;
  glActiveTextureARB: PFNGLACTIVETEXTUREARBPROC;
  glClientActiveTextureARB: PFNGLCLIENTACTIVETEXTUREARBPROC;

  dc: HDC;
  rc: HGLRC;
  tmcsready: boolean = false;
  tmcsdebug: boolean = false;
  tmcslighting: boolean = false;
  tmcscullwired: boolean = true;
  tmcsvsync: boolean = false;
  tmcscd: integer = 16;
  tmcszd: integer = 24;
  tmcsrr: integer;
  tmcsfs: boolean;  // fullscreen
  tmcsbgcolor: TRGBA;
  fonttex: GLuint;
  fontwidths: array[0..255] of word;
  fontdisplists: array[0..255] of GLuint;
  texts: array of ptext;
  tmcstextcolor: TRGBA;
  tmcstextblendingstate: boolean;
  tmcstextblendmode: TBlendMode;
  mblur: boolean;
  mblurrate: byte;
  mblurcounter: byte;
  mblurtex: PTexture;
  mblurtexnum: integer;
  mblurcolor: TRGBA;
  mblurlist: GLuint;
  wndrect: TRECT;
  pfd: pixelformatdescriptor;
  iformat: integer;
  hwinfo: thardwareinfo;
  vertex: PVertex;
  face: PFace;
  uvw: PUVW;
  model: PModel;
  submodel: PSubmodel;
  texture: PTexture;
  world: TWorld;


{$R *.res}

{
   ############################################################################
  ##############################################################################
  <------###----###----###---###- GRAFIKUS MOTOR -###---###----###----###------>
  ##############################################################################
   ############################################################################
}



{ viszaadja, hogy inicializálták-e már a graf. motort }
function tmcsInitialized(): boolean; stdcall;
begin
  result := tmcsready;
end;

{ inicializálja a grafikus motort }
{ ablakleíró, teljes képernyõ, képfrissítési frekvencia, színmélység, z-buffer mélysége, vsync, árnyalás }
function tmcsInitGraphix(wnd: HWND; fs: boolean; freq: integer; cdepth,zdepth: integer; vsyncstate: boolean; shading: integer): byte; stdcall;
var
  dm: DevMode;
  canproceed: boolean;
  ms: tmemorystatus;
  ddev: tdisplaydevice;
  i,numextensions: integer;
  tmpstr: string;
  dispsets: integer;
  l: boolean;
  maxfreq: integer;

{ adott stringben hány space karakter van }
function getnumspaces(str: string): integer;
var
  i, num: integer;
begin
  num := 0;
  for i := 1 to length(str) do
    if ( str[i] = ' ' ) then num := num + 1;
  result := num;
end;

{ megmondja, h adott opengl-extension támogatott-e }
function extSupported(ext: string): boolean; stdcall;
begin
  result := ( pos(ext,hwinfo.glexts) > 0 );
end;

begin
  tmcsready := false;
  frm_loading := Tfrm_loading.Create(nil);
  frm_loading.Show;
  frm_loading.Update;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsInitGraphix('+inttostr(wnd)+','
                                              +booltostr(fs,true)+','+inttostr(freq)+','
                                              +inttostr(cdepth)+','+inttostr(zdepth)+','
                                              +inttostr(shading)+') ...');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > Initializing graphics engine ...');
  world.Objects := TList.Create;
  world.Textures := TList.Create;
  world.Lights.light_ambient[0] := 0.5;
  world.Lights.light_ambient[1] := 0.5;
  world.Lights.light_ambient[2] := 0.5;
  world.Lights.light_ambient[3] := 1.0;
  canproceed := true;
  GetWindowRect(wnd,wndrect);
  frm_loading.pbar.Position := frm_loading.pbar.Position + 2;
  tmcsfs := fs;
  if ( fs ) then
    begin
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > devicemode setting...');
      tmcsrr := freq;
      ZeroMemory(@dm,sizeOf(dm));
      dm.dmSize := sizeOf(dm);
      if ( freq = 255 ) then
        begin
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('   > freq 255, finding greatest available refresh rate ...');
          i := 0;
          enumdisplaysettings(nil,i,dm);
          maxfreq := 60;
          repeat
            i := i+1;
            l := enumdisplaysettings(nil,i,dm);
            if ( (dm.dmPelsWidth = wndrect.Right-wndrect.Left) and (dm.dmPelsHeight = wndrect.Bottom-wndrect.Top) and (dm.dmBitsPerPel = cdepth) ) then
              if ( (dm.dmDisplayFrequency > maxfreq) ) then maxfreq := dm.dmDisplayFrequency;
          until (not(l));
          freq := maxfreq;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('   > the greatest: '+inttostr(maxfreq)+' Hz.');
        end;
      dm.dmPelsWidth := wndrect.Right-wndrect.Left;
      dm.dmPelsHeight := wndrect.Bottom-wndrect.Top;
      dm.dmBitsPerPel := cdepth;
      dm.dmDisplayFrequency := freq;
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > '+inttostr(dm.dmPelsWidth)+'x'+inttostr(dm.dmPelsHeight)+'x'+inttostr(dm.dmBitsPerPel)+'@'+inttostr(dm.dmDisplayFrequency));
      dm.dmFields := DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT or DM_DISPLAYFREQUENCY;
      dispsets := ChangeDisplaySettings(dm,CDS_FULLSCREEN);
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > ChangeDisplaySettings(...) -> '+inttostr(dispsets));
      canproceed := ( dispsets = DISP_CHANGE_SUCCESSFUL );
    end;
  if ( canproceed ) then
    begin
      frm_loading.pbar.Position := frm_loading.pbar.Position + 2;
      dc := GetDC( wnd );
      if ( dc <> 0 ) then
        begin
          ZeroMemory(@pfd, sizeof(pfd));
          pfd.nSize := sizeof(pfd);
          pfd.nVersion := 1;
          pfd.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or
                         PFD_DOUBLEBUFFER or PFD_GENERIC_ACCELERATED;
          pfd.iPixelType := PFD_TYPE_RGBA;
          pfd.cColorBits := cdepth;
          pfd.cDepthBits := zdepth;
          pfd.iLayerType := PFD_MAIN_PLANE;
          tmcscd := cdepth;
          tmcszd := zdepth;
          tmcsvsync := vsyncstate;
          iformat := ChoosePixelFormat(dc, @pfd);
          if ( (iformat = 0) and (tmcszd = 24) ) then
            begin
              if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > could not find suitable pixelformat, trying 16-bit Z-buffer ...');
              pfd.cDepthBits := 16;
              iformat := ChoosePixelFormat(dc, @pfd);
            end;
          frm_loading.pbar.Position := frm_loading.pbar.Position + 2;
          if ( iformat <> 0 ) then
            begin
              if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > iformat was '+inttostr(iformat)+';');
              if ( SetPixelFormat(dc, iFormat, @pfd) ) then
                begin
                  frm_loading.pbar.Position := frm_loading.pbar.Position + 2;
                  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   > SetPixelFormat(...) was true;');
                  rc := wglCreateContext( dc );
                  if ( rc <> 0 ) then
                    begin
                      if ( tmcsdebug ) then frm_c.mm.Lines.Append('    > wglCreateContext('+inttostr(dc)+') was '+inttostr(rc)+';');
                      if ( wglMakeCurrent(dc,rc) ) then
                        begin
                          frm_loading.pbar.Position := frm_loading.pbar.Position + 1;
                          if ( tmcsdebug ) then frm_c.mm.Lines.Append('     > wglMakeCurrent('+inttostr(dc)+','+inttostr(rc)+') was true;');
                          glShadeModel(shading);
                          glClearColor(0.0, 0.0, 0.0, 0.0);
                          glClearDepth(1.0);  glEnable(GL_DEPTH_TEST);  glDepthFunc(GL_LEQUAL);
                          glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
                          glEnable(GL_NORMALIZE);
                          hwinfo.glversion := glgetstring(GL_VERSION);
                          if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > Supported OpenGL version: '+hwinfo.glversion);
                          ddev.cb := sizeof(tdisplaydevice);
                          enumdisplaydevices(nil,0,ddev,0);
                          hwinfo.renderer := string(glgetstring(GL_VENDOR) + ' - ' + glgetstring(GL_RENDERER) + ' - (DeviceString: ' + ddev.DeviceString+')');
                          if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > Rendering HW: ');
                          if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > - ' + hwinfo.renderer);
                          ms.dwLength := sizeof(tmemorystatus);
                          globalmemorystatus(ms);
                          hwinfo.freememory := ms.dwAvailPhys div 1024;
                          hwinfo.totalmemory := ms.dwTotalPhys div 1024;
                          if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > - Free/total RAM: '+inttostr(hwinfo.freememory div 1024)+'/'+
                                                                      inttostr(hwinfo.totalmemory div 1024)+' MByte');
                          hwinfo.glexts := glgetstring(GL_EXTENSIONS);
                          tmpstr := hwinfo.glexts;
                          if ( tmcsdebug ) then
                            begin
                              numextensions := getnumspaces(hwinfo.glexts);
                              frm_c.mm.Lines.Append('      > - Supported extensions ('+inttostr(numextensions)+'):');
                              for i := 1 to numextensions do
                                begin
                                  frm_c.mm.Lines.Append('        > - ' + copy(tmpstr,1,pos(' ',tmpstr)-1));
                                  delete(tmpstr,1,pos(' ',tmpstr));
                                end;
                            end;
                          if ( extSupported('WGL_EXT_swap_control') ) then
                            begin
                              if ( tmcsdebug ) then
                                begin
                                  if ( tmcsvsync ) then
                                    frm_c.mm.Lines.Append('      > VSync supported and set.')
                                   else
                                    frm_c.mm.Lines.Append('      > VSync supported but not set.');
                                end;
                              wglswapintervalext := wglgetprocaddress('wglSwapIntervalEXT');
                              if ( tmcsvsync ) then wglswapintervalext(1) else wglswapintervalext(0);
                            end
                           else
                            begin
                              if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > VSync not supported.');
                              tmcsvsync := false;
                            end;
                          if ( extSupported('GL_ARB_multitexture') ) then
                            begin
                              if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > Multitexturing supported!');
                              glGetIntegerv(GL_MAX_TEXTURE_UNITS_ARB, @hwinfo.numtmu);
                              if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > Texturing units: '+inttostr(hwinfo.numtmu));
                              glMultiTexCoord1dARB := wglGetProcAddress('glMultiTexCoord1dARB');
                              glMultiTexCoord1dvARB := wglGetProcAddress('glMultiTexCoord1dvARB');
                              glMultiTexCoord1fARB := wglGetProcAddress('glMultiTexCoord1fARB');
                              glMultiTexCoord1fvARB := wglGetProcAddress('glMultiTexCoord1fvARB');
                              glMultiTexCoord1iARB := wglGetProcAddress('glMultiTexCoord1iARB');
                              glMultiTexCoord1ivARB := wglGetProcAddress('glMultiTexCoord1ivARB');
                              glMultiTexCoord1sARB := wglGetProcAddress('glMultiTexCoord1sARB');
                              glMultiTexCoord1svARB := wglGetProcAddress('glMultiTexCoord1svARB');
                              glMultiTexCoord2dARB := wglGetProcAddress('glMultiTexCoord2dARB');
                              glMultiTexCoord2dvARB := wglGetProcAddress('glMultiTexCoord2dvARB');
                              glMultiTexCoord2fARB := wglGetProcAddress('glMultiTexCoord2fARB');
                              glMultiTexCoord2fvARB := wglGetProcAddress('glMultiTexCoord2fvARB');
                              glMultiTexCoord2iARB := wglGetProcAddress('glMultiTexCoord2iARB');
                              glMultiTexCoord2ivARB := wglGetProcAddress('glMultiTexCoord2ivARB');
                              glMultiTexCoord2sARB := wglGetProcAddress('glMultiTexCoord2sARB');
                              glMultiTexCoord2svARB := wglGetProcAddress('glMultiTexCoord2svARB');
                              glMultiTexCoord3dARB := wglGetProcAddress('glMultiTexCoord3dARB');
                              glMultiTexCoord3dvARB := wglGetProcAddress('glMultiTexCoord3dvARB');
                              glMultiTexCoord3fARB := wglGetProcAddress('glMultiTexCoord3fARB');
                              glMultiTexCoord3fvARB := wglGetProcAddress('glMultiTexCoord3fvARB');
                              glMultiTexCoord3iARB := wglGetProcAddress('glMultiTexCoord3iARB');
                              glMultiTexCoord3ivARB := wglGetProcAddress('glMultiTexCoord3ivARB');
                              glMultiTexCoord3sARB := wglGetProcAddress('glMultiTexCoord3sARB');
                              glMultiTexCoord3svARB := wglGetProcAddress('glMultiTexCoord3svARB');
                              glMultiTexCoord4dARB := wglGetProcAddress('glMultiTexCoord4dARB');
                              glMultiTexCoord4dvARB := wglGetProcAddress('glMultiTexCoord4dvARB');
                              glMultiTexCoord4fARB := wglGetProcAddress('glMultiTexCoord4fARB');
                              glMultiTexCoord4fvARB := wglGetProcAddress('glMultiTexCoord4fvARB');
                              glMultiTexCoord4iARB := wglGetProcAddress('glMultiTexCoord4iARB');
                              glMultiTexCoord4ivARB := wglGetProcAddress('glMultiTexCoord4ivARB');
                              glMultiTexCoord4sARB := wglGetProcAddress('glMultiTexCoord4sARB');
                              glMultiTexCoord4svARB := wglGetProcAddress('glMultiTexCoord4svARB');
                              glActiveTextureARB := wglGetProcAddress('glActiveTextureARB');
                              glClientActiveTextureARB := wglGetProcAddress('glClientActiveTextureARB');
                            end
                           else
                            begin
                              if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > Multitexturing not supported!');
                            end;
                          if ( extSupported('GL_ARB_texture_compression') ) then
                            begin
                              hwinfo.hwtc := true;
                              if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > Texture compression supported!');
                            end
                           else
                            begin
                              hwinfo.hwtc := false;
                              if ( tmcsdebug ) then frm_c.mm.Lines.Append('      > Texture compression not supported!');
                            end;
                          zeromemory(@tmcsbgcolor,sizeof(TRGBA));
                          world.extobjectstexmode.mipmapping := true;
                          world.extobjectstexmode.filtering := GL_LINEAR_MIPMAP_LINEAR;
                          world.extobjectstexmode.envmode := GL_DECAL;
                          world.extobjectstexmode.border := 0;
                          world.extobjectstexmode.wrap_s := GL_REPEAT;
                          world.extobjectstexmode.wrap_t := GL_REPEAT;
                          zeromemory(@hwinfo.gammaramp_orig,sizeof(TGammaRamp));
                          getdevicegammaramp(dc,hwinfo.gammaramp_orig);
                          hwinfo.gammaramp_mod := hwinfo.gammaramp_orig;
                          mblur := false;
                          mblurrate := MOTIONBLUR_DEF_RATE;
                          mblurcolor.r := MOTIONBLUR_DEF_RED;
                          mblurcolor.g := MOTIONBLUR_DEF_BLUE;
                          mblurcolor.b := MOTIONBLUR_DEF_GREEN;
                          mblurcolor.a := MOTIONBLUR_DEF_ALPHA;
                          mblurcounter := mblurrate;
                          tmcstextcolor.r := 255;
                          tmcstextcolor.g := 255;
                          tmcstextcolor.b := 255;
                          tmcstextcolor.a := 255;
                          tmcstextblendmode.sfactor := gl_one;
                          tmcstextblendmode.dfactor := gl_one;
                          tmcstextblendingstate := true;
                          tmcsready := true;
                          frm_loading.pbar.Position := frm_loading.pbar.Position + 1;
                          if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > Done, graphics engine initialized!');
                          frm_loading.Free;
                          result := 0;
                        end
                       else
                        begin
                          if ( tmcsdebug ) then frm_c.mm.Lines.Append('     > wglMakeCurrent('+inttostr(dc)+','+inttostr(rc)+') was false;');
                          result := 1;
                        end;
                    end
                   else
                    begin
                      if ( tmcsdebug ) then frm_c.mm.Lines.Append('    > wglCreateContext('+inttostr(dc)+') was 0;');
                      result := 2;
                    end;
                end
               else
                begin
                  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   > SetPixelFormat(...) was false;');
                  result := 3;
                end;
            end
           else
            begin
              if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > iformat was 0;');
              result := 4;
            end
        end
       else
        begin
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > dc was 0');
          result := 5;
        end;
      end
     else
      begin
        if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > devicemode setting failed!');
        result := 5;
      end;
end;

{ bekapcsolja a debuggolást }
procedure tmcsEnableDebugging(); stdcall;
begin
  if ( not(tmcsdebug) ) then
    begin
      tmcsdebug := true;
      frm_c := Tfrm_c.Create(nil);
      frm_c.Show;
    end;
end;

{ kikapcsolja a debuggolást }
procedure tmcsDisableDebugging(); stdcall;
begin
  if ( tmcsdebug ) then
    begin
      tmcsdebug := false;
      frm_c.Free;
    end;
end;

{ megadja, hogy be van-e kapcsolva a debuggolás }
function tmcsIsDebugging(): boolean; stdcall;
begin
  result := tmcsdebug;
end;

{ a megjelenített kép gamma-értékein változtat }
{ 255 = nem változik a kép }
procedure tmcsSetGamma(r,g,b: integer); stdcall;
var
  i: integer;
  r2,g2,b2: integer;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsSetGamma('+inttostr(r)+','
                                              +inttostr(g)+','+inttostr(b)+')');
  for i := 0 to 255 do
    begin
      r2 := round(255 * power(i/255, r/255));
      g2 := round(255 * power(i/255, g/255));
      b2 := round(255 * power(i/255, b/255));
      if ( r2 > 255 ) then r2 := 255;
      if ( g2 > 255 ) then g2 := 255;
      if ( b2 > 255 ) then b2 := 255;
      hwinfo.gammaramp_mod.red[i] := r2 shl 8;
      hwinfo.gammaramp_mod.green[i] := g2 shl 8;
      hwinfo.gammaramp_mod.blue[i] := b2 shl 8;
    end;
  setdevicegammaramp(dc,hwinfo.gammaramp_mod);
end;

{ átvált perspektivikus megjelenítési módba }
procedure SwitchToPerspective;
begin
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(world.Camera.fov, world.Camera.aspect, world.Camera.zNear, world.Camera.zFar);
  glRotatef(world.Camera.anglex,1,0,0);
  glRotatef(world.Camera.angley,0,1,0);
  glRotatef(world.Camera.anglez,0,0,1);
  glTranslatef(-world.Camera.posx,-world.Camera.posy,world.Camera.posz);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
end;

{ átvált ortografikus megjelenítési módba }
procedure SwitchToOrthographic(width, height: double);
begin
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0,width,0,height,-1,1);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
end;

{ kirajzolja a motion blur lapját }
procedure DrawMBlurPlane(plane_w, plane_h: single; u,v: single);
begin
  glpushmatrix();
  glColor4ub(mblurcolor.r,mblurcolor.g,mblurcolor.b,mblurcolor.a);
  glCallList(mblurlist);
  glpopmatrix();
end;

{ kirajzolja a kívánt képet }
procedure tmcsRender(); stdcall;

{ mindent kirajzol }
procedure RenderAll;
var
  i,j,k,l,i2: integer;
  model2: PModel;
  submodel2: PSubmodel;
  face2: PFace;
  uvw2: PUVW;
  lasttex,lasttex2: GLuint;
  blended: boolean;
begin
  if ( world.Objects.Count > 0 ) then
    begin
      blended := true;
      glpushmatrix;
      for i2 := 1 to 2 do
        begin
          blended := not(blended);
          if ( blended ) then
            begin
              glEnable(GL_BLEND);
              glDepthmask(gl_false);
            end
           else
            begin
              glpushmatrix;
              glDisable(GL_BLEND);
            end;
          for i := 0 to world.Objects.Count-1 do
            begin
              model := world.Objects[i];
              if ( assigned(model) ) then
                begin
                  if ( (model^.blended = blended) and (model^.visible) and not(model^.sticked) ) then
                    begin
                      glPushmatrix();
                      glTranslatef(model^.posx,model^.posy,-model^.posz);

                      if ( model^.rotationxzy ) then
                        begin
                          glRotatef(360-model^.anglex,0,0,1);
                          glRotatef(360-model^.anglez,1,0,0);
                          glRotatef(360-model^.angley,0,1,0);
                        end
                       else
                        begin
                          glRotatef(360-model^.angley,0,1,0);
                          glRotatef(360-model^.anglex,0,0,1);
                          glRotatef(360-model^.anglez,1,0,0);
                        end;

                      glScalef(model^.scaling,model^.scaling,model^.scaling);

                      if ( model^.doublesided ) then
                        begin
                          glDisable(GL_CULL_FACE);
                          if ( model^.affectedbylights and tmcslighting) then glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);
                        end
                       else
                        begin
                          glEnable(GL_CULL_FACE);
                          if ( model^.affectedbylights and tmcslighting) then glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,0);
                        end;
                      if ( model^.wireframe ) then
                        begin
                          glDisable(GL_LIGHTING);
                          if ( not(tmcscullwired) ) then glDisable(GL_CULL_FACE) else glEnable(GL_CULL_FACE);
                          glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
                        end
                       else
                        begin
                          if ( tmcslighting ) then
                            begin
                              glEnable(GL_LIGHTING);
                            end;
                          glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
                        end;
                      glcolor4ub(model^.colorkey.r,model^.colorkey.g,model^.colorkey.b,model^.colorkey.a);
                      if ( model^.blended ) then glBlendFunc(model^.blendmode.sfactor,model^.blendmode.dfactor);
                      if ( model^.zbuffered ) then
                        begin
                          glEnable(GL_DEPTH_TEST);
                        end
                       else
                        begin
                          glDisable(GL_DEPTH_TEST);
                        end;
                      if ( model^.multitextured and assigned(glActiveTextureARB) ) then
                        begin
                          glEnable(GL_BLEND);
                          glBlendFunc(model^.blendmode.sfactor,model^.blendmode.dfactor);
                          if ( model^.textured ) then
                            begin
                              glActiveTextureARB(GL_TEXTURE0_ARB);
                              glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, gl_modulate);
                              glEnable(GL_TEXTURE_2D);
                              glActiveTextureARB(GL_TEXTURE1_ARB);
                              glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, gl_modulate);
                              glEnable(GL_TEXTURE_2D);
                            end;
                        end
                       else
                        begin
                          if ( not(model^.blended) ) then glDisable(GL_BLEND);
                          if ( assigned(glActiveTextureARB) ) then
                            begin
                              glActiveTextureARB(GL_TEXTURE1_ARB);
                              glDisable(GL_TEXTURE_2D);
                              glActiveTextureARB(GL_TEXTURE0_ARB);
                              glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, gl_modulate);
                            end;
                          if ( model^.textured ) then
                            begin
                              glEnable(GL_TEXTURE_2D);
                            end
                           else
                            begin
                              glDisable(GL_TEXTURE_2D);
                            end;
                        end;

                      if ( model^.affectedbylights ) then
                        begin
                          if ( tmcslighting ) then glEnable(GL_LIGHTING) else glDisable(GL_LIGHTING);
                        end
                       else
                        begin
                          glDisable(GL_LIGHTING);
                        end;

                      if ( model^.compiled ) then
                        begin
                          if ( model^.reference = -1 ) then
                            begin
                              for l := 0 to model^.submodels.Count-1 do
                                begin
                                  submodel := model^.submodels[l];
                                  if ( submodel^.visible ) then glCallList(submodel^.displaylist);
                                end;
                            end
                           else
                            begin
                              for l := 0 to pmodel(world.Objects[model^.reference])^.submodels.Count-1 do
                                begin
                                  submodel := pmodel(world.Objects[model^.reference])^.submodels[l];
                                  if ( submodel^.visible ) then glCallList(submodel^.displaylist);
                                end;
                            end;
                        end  // model^.compiled
                       else
                        begin
                          lasttex := 0;
                          lasttex2 := 0;
                          for l := 0 to model^.submodels.Count-1 do
                            begin
                              submodel := model^.submodels[l];
                              if ( submodel^.visible ) then
                                begin
                                  if ( submodel^.textured ) then glEnable(GL_TEXTURE_2D)
                                   else glDisable(GL_TEXTURE_2D);
                                  if (l > 0) then lasttex := face^.tex;
                                  face := submodel^.faces[0]; // magyarázat lentebb...
                                  if ( model^.multitextured ) then
                                    begin
                                      if ( assigned(glActiveTextureARB) ) then
                                        begin  // multitextúrázva van, és van ilyen extensionünk
                                          model2 := world.objects[ model^.multitexassigned ];
                                          submodel2 := model2^.submodels[l];
                                          if (l > 0) then lasttex2 := face2^.tex;
                                          face2 := submodel2^.faces[0];

                                          if ( face^.tex <> lasttex ) then
                                            begin
                                              glActiveTextureARB(GL_TEXTURE0_ARB);
                                              glEnable(GL_TEXTURE_2D);
                                              glBindTexture(GL_TEXTURE_2D, face^.tex);
                                            end;
                                          if ( face2^.tex <> lasttex2 ) then
                                            begin
                                              glActiveTextureARB(GL_TEXTURE1_ARB);
                                              glEnable(GL_TEXTURE_2D);
                                              glBindTexture(GL_TEXTURE_2D, face2^.tex);
                                            end;
                                        end
                                       else
                                        begin // multitextúrázva van, de nincs ilyen extensionünk
                                          glEnable(GL_TEXTURE_2D);
                                          if ( face^.tex <> lasttex ) then glBindTexture(GL_TEXTURE_2D, face^.tex);
                                        end;
                                    end  // model^.multitextured
                                   else
                                    begin
                                      if ( assigned(glActiveTextureARB) ) then
                                        begin // nem multitextúrázott, van extension
                                          glActiveTextureARB(GL_TEXTURE1_ARB);
                                          glDisable(GL_TEXTURE_2D);
                                          glActiveTextureARB(GL_TEXTURE0_ARB);
                                          if ( face^.tex <> lasttex ) then glBindTexture(GL_TEXTURE_2D,face^.tex);
                                        end
                                       else
                                        begin // nem multitextúrázott, és nincs is extension
                                          glEnable(GL_TEXTURE_2D);
                                          if ( face^.tex <> lasttex ) then glBindTexture(GL_TEXTURE_2D, face^.tex);
                                        end;
                                    end;
                                  if ( model^.tessellated ) then glBegin(GL_TRIANGLES)
                                    else glBegin(GL_QUADS);
                                  for j := 0 to submodel^.faces.Count-1 do
                                    begin
                                      face := submodel^.faces[j];
                                      if ( model^.multitextured ) then face2 := submodel2^.faces[j];
                                      // if ( submodel^.textured ) then glBindTexture(GL_TEXTURE_2D,face^.tex);
                                      // performance-hack:elvileg face-enként más-más textúra lehet, de felesleges...
                                      // a glbindtexture idõigényes, ezért csak subobjectenként váltunk...
                                      if ( model^.tessellated ) then
                                        begin
                                          for k := 0 to 2 do
                                            begin
                                              vertex := submodel^.vertices[ face^.vertices[k]-1 ];
                                              if ( submodel^.textured ) then
                                                begin
                                                  if ( model^.multitextured ) then
                                                    begin
                                                      if ( assigned(glMultiTexCoord2fARB) ) then
                                                        begin // multitextúrázott model, van extension
                                                          uvw := submodel^.uvwcoords[ face^.uvcoords[k]-1 ];
                                                          uvw2 := submodel2^.uvwcoords[ face2^.uvcoords[k]-1 ];
                                                          glMultiTexCoord2fARB(GL_TEXTURE0_ARB, uvw^.u, uvw^.v);
                                                          glMultiTexCoord2fARB(GL_TEXTURE1_ARB, uvw2^.u, uvw2^.v);
                                                        end
                                                       else
                                                        begin // multitextúrázott model, de nincs extension
                                                          uvw := submodel^.uvwcoords[ face^.uvcoords[k]-1 ];
                                                          glTexCoord2f(uvw^.u,uvw^.v);
                                                        end;
                                                    end  // model^.multitextured
                                                   else
                                                    begin  // nem multitextúrázott model
                                                      uvw := submodel^.uvwcoords[ face^.uvcoords[k]-1 ];
                                                      glTexCoord2f(uvw^.u,uvw^.v);
                                                    end;
                                                  end  // submodel^.textured
                                                 else
                                                  begin
                                                    glColor4ub(vertex^.color.r,vertex^.color.g,vertex^.color.b,vertex^.color.a);
                                                  end;
                                              if ( model^.affectedbylights ) then glNormal3f(vertex^.nx,vertex^.ny,vertex^.nz);
                                              glVertex3f(vertex^.x,vertex^.y,vertex^.z);
                                            end;  // k ciklus
                                        end  // model^.tessellated
                                       else
                                        begin
                                            for k := 0 to 3 do
                                              begin
                                                vertex := submodel^.vertices[ face^.vertices[k] ];
                                                if ( submodel^.textured ) then
                                                  begin
                                                    glTexCoord2f(vertex^.u,vertex^.v);
                                                  end
                                                 else
                                                  begin
                                                    glColor4ub(vertex^.color.r,vertex^.color.g,vertex^.color.b,vertex^.color.a);
                                                  end;
                                                if ( model^.affectedbylights ) then glNormal3f(vertex^.nx,vertex^.ny,vertex^.nz);
                                                glVertex3f(vertex^.x,vertex^.y,vertex^.z);
                                              end;  // k ciklus
                                        end;  // nem model^.tessellated
                                    end;   // j ciklus
                                  glEnd();
                                end; // endif submodel^.visible
                            end; // l ciklus
                        end;  // nem model^.compiled
                      glpopmatrix();
                    end;  // endif model^.visible
                end;  // assigned
            end;  // i ciklus
          if ( not(blended) ) then glpopmatrix() else glDepthmask(gl_true);
        end;  // i2 ciklus
      glpopmatrix();
    end;  // world.objects.count > 0

  SwitchToOrthographic(world.Camera.targettex_w,world.Camera.targettex_h);
  glDisable(GL_CULL_FACE);
  glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
  glDisable(GL_DEPTH_TEST);
  // sticked objectet nem lehet multitextúrázni, ezért
  // tutira kikapcsoljuk a 2. TMU - t
  if ( assigned(glActiveTextureARB) ) then
    begin // nem multitextúrázott, van extension
      glActiveTextureARB(GL_TEXTURE1_ARB);
      glDisable(GL_TEXTURE_2D);
      glActiveTextureARB(GL_TEXTURE0_ARB);
    end
   else
    begin
      glEnable(GL_TEXTURE_2D);
    end;

  if ( world.Objects.Count > 0 ) then
    begin
      for i := 0 to world.Objects.Count-1 do
        begin
          model := world.Objects[i];
          if ( assigned(model) and (model^.visible) and (model^.sticked) ) then
            begin
              glPushmatrix();
              glRotatef(model^.anglex,1,0,0);
              glRotatef(model^.angley,0,1,0);
              glRotatef(model^.anglez,0,0,1);
              glTranslatef(world.Camera.targettex_w/2,world.Camera.targettex_h/2,0);
              glTranslatef(model^.posx,model^.posy,model^.posz);

              glScalef(model^.scaling,model^.scaling,model^.scaling);

              if ( model^.affectedbylights ) then
                begin
                  if ( tmcslighting ) then glEnable(GL_LIGHTING) else glDisable(GL_LIGHTING);
                end
               else
                begin
                  glDisable(GL_LIGHTING);
                end;

              glcolor4ub(model^.colorkey.r,model^.colorkey.g,model^.colorkey.b,model^.colorkey.a);
              if ( model^.blended ) then
                begin
                  glEnable(GL_BLEND);
                  //glDisable(GL_DEPTH_TEST);
                  glBlendFunc(model^.blendmode.sfactor,model^.blendmode.dfactor);
                end
               else
                begin
                  glDisable(GL_BLEND);
                  //glEnable(GL_DEPTH_TEST);
                end;

              if ( model^.compiled ) then
                begin
                  for l := 0 to model^.submodels.Count-1 do
                    begin
                      submodel := model^.submodels[l];
                      if ( submodel^.visible ) then glCallList(submodel^.displaylist);
                    end
                end    
               else
                begin
                  for l := 0 to model^.submodels.Count-1 do
                    begin
                      submodel := model^.submodels[l];
                      if ( submodel^.visible ) then
                        begin
                          if ( submodel^.textured ) then glEnable(GL_TEXTURE_2D)
                            else glDisable(GL_TEXTURE_2D);
                          for j := 0 to submodel^.faces.Count-1 do
                            begin
                              face := submodel^.faces[j];
                              if ( face^.tex <> lasttex ) then glBindTexture(GL_TEXTURE_2D,face^.tex);
                              glBegin(GL_QUADS);
                              for k := 0 to 3 do
                                begin
                                  vertex := submodel^.vertices[ face^.vertices[k] ];
                                  if ( submodel^.textured ) then
                                    begin
                                      glTexCoord2f(vertex^.u,vertex^.v);
                                    end
                                   else
                                    begin
                                      glColor4ub(vertex^.color.r,vertex^.color.g,vertex^.color.b,vertex^.color.a);
                                    end;
                                  glVertex2f(vertex^.x,vertex^.y);
                                end;  // k ciklus
                              glEnd();
                            end;  // j ciklus
                        end; // endif submodel^.visible
                    end; // l ciklus
                  end;
                glpopmatrix();
            end;  // model^.visible
        end;  // i ciklus
    end;  // world.objects.count > 0

  if ( (fonttex > 0) and (length(texts) > 0) ) then
    begin
      gldisable(gl_lighting);
      if ( tmcstextblendingstate ) then
        begin
          glEnable(GL_BLEND);
          glBlendFunc(tmcstextblendmode.sfactor,tmcstextblendmode.dfactor);
        end
       else
        glDisable(GL_BLEND);
      glBindTexture(GL_TEXTURE_2D, fonttex);
      for i := 0 to length(texts)-1 do
        begin
          glloadidentity();
          glTranslatef(texts[i]^.x,texts[i]^.y-world.Camera.targettex_h/40,0);
          glColor4ub(texts[i]^.color.r,texts[i]^.color.g,texts[i]^.color.b,texts[i]^.color.a);
          for j := 1 to length(texts[i]^.txt) do
            begin
              if ( j > 1 ) then glTranslatef((fontwidths[ ord(texts[i]^.txt[j-1]) ] +fontwidths[ ord(texts[i]^.txt[j]) ]/2 )*(texts[i]^.scaling/100),0,0);
              glpushmatrix();
              glscalef(texts[i]^.scaling/100,texts[i]^.scaling/100,texts[i]^.scaling/100);
              glCallList( fontdisplists[ ord(texts[i]^.txt[j]) ] );
              glpopmatrix();
            end;
        end;
      for i := 0 to length(texts)-1 do
        begin
          dispose(texts[i]);
        end;
      setlength(texts,0);
    end;

end;  // proc. renderall


begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  if ( mblur ) then
    begin
      if ( mblurcounter = mblurrate ) then
        begin
          glViewport(0, 0, world.Camera.targettex_w, world.Camera.targettex_h);
          SwitchToPerspective;
          RenderAll;

          SwitchToOrthographic(world.Camera.targettex_w, world.Camera.targettex_w);
          DrawMBlurPlane(mblurtex.width, world.Camera.targettex_w, mblurtex.width, world.Camera.targettex_h);

          if ( assigned(glActiveTextureARB) ) then
            begin
              glActiveTextureARB(GL_TEXTURE1_ARB);
              glDisable(GL_TEXTURE_2D);
              glActiveTextureARB(GL_TEXTURE0_ARB);
              glBindTexture(GL_TEXTURE_2D, mblurtex.internalnum);
              glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, mblurtex.width, mblurtex.width, 0);
            end
           else
            begin
              glBindTexture(GL_TEXTURE_2D, mblurtex.internalnum);
              glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, mblurtex.width, mblurtex.width, 0);
            end;

          mblurcounter := 0;
        end;  // mblurcounter = mblurrate

      mblurcounter := mblurcounter + 1;
    end  // mblur
   else
    begin
      SwitchToPerspective;
      RenderAll;
    end;

  glFlush();
  SwapBuffers(dc);
end;  // proc. tmcsRender


procedure tmcsDeleteObjects(); stdcall; forward;
procedure tmcsDeleteTextures(); stdcall; forward;


procedure tmcsRestoreOriginalDisplayMode; stdcall;
begin
  if ( tmcsinitialized and tmcsfs ) then
    begin
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > restoring original display settings ...');
      ChangeDisplaySettings(devmode(nil^),0);
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > ok!');
    end;
end;

procedure tmcsRestoreDisplayMode; stdcall;
var
  dm: devmode;
begin
  if ( tmcsinitialized and tmcsfs ) then
    begin
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > restoring set display settings ...');
      ZeroMemory(@dm,sizeOf(dm));
      dm.dmSize := sizeOf(dm);
      dm.dmPelsWidth := world.Camera.targettex_w;
      dm.dmPelsHeight := world.Camera.targettex_h;
      dm.dmBitsPerPel := tmcscd;
      dm.dmDisplayFrequency := tmcsrr;
      dm.dmFields := DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT or DM_DISPLAYFREQUENCY;
      ChangeDisplaySettings(dm,CDS_FULLSCREEN);
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > ok!');
    end;
end;

procedure tmcsFreeMotionBlurResources(); stdcall; forward;

{ leállítja a grafikus motort }
function tmcsShutdownGraphix(): byte; stdcall;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsShutdownGraphix() ...');
  if ( tmcsready ) then
    begin
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > tmcsready was true;');
      tmcsready := false;
      tmcsDeleteObjects();
      tmcsDeleteTextures();
      world.Objects.Free;
      world.Textures.Free;
      tmcsFreeMotionBlurResources;
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > resetting original GammaRamp ...');
      SetDeviceGammaRamp(dc,hwinfo.gammaramp_orig);
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > ok!');
      tmcsRestoreOriginalDisplayMode();
      if ( wglMakeCurrent(0,0) ) then
        begin
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > wglMakeCurrent(0,0) was true;');
          if ( wglDeleteContext(rc) ) then
            begin
              if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > done; wglDeleteContext('+inttostr(rc)+') was true;');
              if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > Successful shutdown!');
              result := 0
            end
           else
            begin
              if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > wglDeleteContext('+inttostr(rc)+') was false;');
              result := 1;
            end;
        end
       else
        begin
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > wglMakeCurrent('+inttostr(rc)+') was false;');
          result := 2;
        end;
    end
   else
     begin
       if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > tmcsready was false;');
       result := 3;
     end;
  if ( tmcsdebug ) then frm_c.Close;
end;

{
  ##############################################################################
  <--------------------------- MOTION BLUR KEZELÉSE --------------------------->
  ##############################################################################
}

{ motion blur bekapcsolása }
procedure tmcsEnableMotionBlur(width, height: word); stdcall;
var
  p: pointer;

{ VRAM-ba rakja a motion blur rajzolását }
procedure compileMBlurPlane;
begin
  mblurlist := glGenLists(1);
  glNewList(mblurlist,GL_COMPILE);
    glDisable(GL_DEPTH_TEST);
    glDisable(gl_LIGHTING);
    if ( assigned(glActiveTextureARB) ) then
      begin
        glActiveTextureARB(GL_TEXTURE1_ARB);
        glDisable(GL_TEXTURE_2D);
        glActiveTextureARB(GL_TEXTURE0_ARB);
      end;
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, mblurtex.internalnum);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
                                    //mblurtex.width, world.Camera.targettex_w, mblurtex.width, world.Camera.targettex_h
    glBegin(GL_QUADS);
      glTexCoord2f(0.0, 0.0);  glVertex2f(0.0, 0);
      glTexCoord2f(1.0, 0.0);  glVertex2f(mblurtex.width, 0);
      glTexCoord2f(1.0, world.Camera.targettex_h/mblurtex.width);  glVertex2f(mblurtex.width, world.Camera.targettex_w);
      glTexCoord2f(0.0, world.Camera.targettex_h/mblurtex.width);  glVertex2f(0, world.Camera.targettex_w);
    glEnd();

    glEnable(GL_DEPTH_TEST);
    glDisable(GL_BLEND);
    glColor4f(1,1,1,1);
  glEndList();
end;

begin
  if ( not(mblur) ) then
    begin
      if ( not(assigned(mblurtex)) ) then
        begin
          new(mblurtex);
          mblurtex.filename := '';
          mblurtex.mipmapped := false;
          mblurtex.width := width;
          mblurtex.height := height;
          mblurtexnum := world.Textures.Add(mblurtex);
          getmem(p,width*height*3);
          zeromemory(p,width*height*3);
          glGenTextures(1, mblurtex.internalnum);
          if ( assigned(glActiveTextureARB) ) then
            begin
              glActiveTextureARB(GL_TEXTURE1_ARB);
              glDisable(GL_TEXTURE_2D);
              glActiveTextureARB(GL_TEXTURE0_ARB);
            end;
          glBindTexture(GL_TEXTURE_2D, mblurtex.internalnum);
          glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
          glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
          glTexImage2D(GL_TEXTURE_2D, 0, 3, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, p);
          freemem( p );
          compileMBlurPlane;
        end;
      SwitchToOrthographic(world.Camera.targettex_w, world.Camera.targettex_w);

      if ( assigned(glActiveTextureARB) ) then
        begin
          glActiveTextureARB(GL_TEXTURE1_ARB);
          glDisable(GL_TEXTURE_2D);
          glActiveTextureARB(GL_TEXTURE0_ARB);
          glBindTexture(GL_TEXTURE_2D, mblurtex.internalnum);
          glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, mblurtex.width, mblurtex.width, 0);
        end
       else
        begin
          glBindTexture(GL_TEXTURE_2D, mblurtex.internalnum);
          glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, mblurtex.width, mblurtex.width, 0);
        end;
      mblur := true;
    end;
end;

{ felszabadítja a motion blur által lefoglalt erõforrásokat }
procedure tmcsFreeMotionBlurResources(); stdcall;
begin
  mblur := false;
  if ( assigned(mblurtex) ) then
    begin
      glDeleteTextures(1,@mblurtex.internalnum);
      world.Textures[mblurtexnum] := nil;
      glDeleteLists(mblurlist,1);
      dispose(mblurtex);
      mblurtex := nil;
    end;
end;

{ motion blur kikapcsolása }
procedure tmcsDisableMotionBlur(); stdcall;
begin
  mblur := false;
end;

{ motion blur frissítési idejének lekérdezése }
function tmcsGetMotionBlurUpdateRate(): byte; stdcall;
begin
  result := mblurrate;
end;

{ motion blur frissítési idejének beállítása }
procedure tmcsSetMotionBlurUpdateRate(rate: byte); stdcall;
begin
  if ( rate > 0 ) then
    begin
      mblurrate := rate;
      mblurcounter := rate;
    end
   else
    begin
      mblurrate := MOTIONBLUR_DEF_RATE;
      mblurcounter := MOTIONBLUR_DEF_RATE;
    end;
end;

{ motion blur színének lekérdezése }
function tmcsGetMotionBlurColor(): TRGBA; stdcall;
begin
  result := mblurcolor;
end;

{ motion blur színének beállítása }
procedure tmcsSetMotionBlurColor(red, green, blue, alpha: byte); stdcall;
begin
  mblurcolor.r := red;
  mblurcolor.g := green;
  mblurcolor.b := blue;
  mblurcolor.a := alpha;
end;

{
  ##############################################################################
  <------------------------------ KAMERA KEZELÉSE ----------------------------->
  ##############################################################################
}

{ visszaadja a kamera pozícióját az X-tengelyen }
function tmcsGetCameraX(): single; stdcall;
begin
  result := world.Camera.posx;
end;

{ visszaadja a kamera pozícióját az Y-tengelyen }
function tmcsGetCameraY(): single; stdcall;
begin
  result := world.Camera.posy;
end;

{ visszaadja a kamera pozícióját az Z-tengelyen }
function tmcsGetCameraZ(): single; stdcall;
begin
  result := world.Camera.posz;
end;

{ visszaadja a kamera forgásszögét az X-tengelyen }
function tmcsGetCameraAngleX(): single; stdcall;
begin
  result := world.Camera.anglex;
end;

{ visszaadja a kamera forgásszögét az Y-tengelyen }
function tmcsGetCameraAngleY(): single; stdcall;
begin
  result := world.Camera.angley;
end;

{ visszaadja a kamera forgásszögét az Z-tengelyen }
function tmcsGetCameraAngleZ(): single; stdcall;
begin
  result := world.Camera.anglez;
end;

{ visszaadja a kamera látószögét }
function tmcsGetCameraFov(): Double; stdcall;
begin
  result := world.Camera.fov;
end;

{ visszaadja a kamera képének oldalarányát}
function tmcsGetCameraAspect(): Double; stdcall;
begin
  result := world.Camera.aspect;
end;

{ visszaadja a közeli vágósík kamerától való távolságát }
function tmcsGetCameraNearPlane(): Double; stdcall;
begin
  result := world.Camera.znear;
end;

{ visszaadja a távoli vágósík kamerától való távolságát }
function tmcsGetCameraFarPlane(): Double; stdcall;
begin
  result := world.Camera.zfar;
end;

{ beállítja a kamera pozícióját az X-tengelyen }
procedure tmcsSetCameraX(posx: single); stdcall;
begin
  world.Camera.posx := posx;
end;

{ beállítja a kamera pozícióját az Y-tengelyen }
procedure tmcsSetCameraY(posy: single); stdcall;
begin
  world.Camera.posy := posy;
end;

{ beállítja a kamera pozícióját az Z-tengelyen }
procedure tmcsSetCameraZ(posz: single); stdcall;
begin
  world.Camera.posz := posz;
end;

{ beállítja a kamera pozícióját a 3 tengelyen }
procedure tmcsSetCameraPos(posx,posy,posz: single); stdcall;
begin
  world.Camera.posx := posx;
  world.Camera.posy := posy;
  world.Camera.posz := posz;
end;

{ beállítja a kamera forgásszögét az X-tengelyen }
procedure tmcsSetCameraAngleX(anglex: single); stdcall;
begin
  world.Camera.anglex := anglex;
end;

{ beállítja a kamera forgásszögét az Y-tengelyen }
procedure tmcsSetCameraAngleY(angley: single); stdcall;
begin
  world.Camera.angley := angley;
end;

{ beállítja a kamera forgásszögét az Z-tengelyen }
procedure tmcsSetCameraAngleZ(anglez: single); stdcall;
begin
  world.Camera.anglez := anglez;
end;

{ elforgatja adott szöggel a kamerát az X-tengelyen }
procedure tmcsXRotateCamera(angle: single); stdcall;
begin
  world.Camera.anglex := world.Camera.anglex+angle;
end;

{ elforgatja adott szöggel a kamerát az Y-tengelyen }
procedure tmcsYRotateCamera(angle: single); stdcall;
begin
  world.Camera.angley := world.Camera.angley+angle;
end;

{ elforgatja adott szöggel a kamerát a Z-tengelyen }
procedure tmcsZRotateCamera(angle: single); stdcall;
begin
  world.Camera.anglez := world.Camera.anglez+angle;
end;

{ beállítja a kamera forgásszögét a 3 tengelyen }
procedure tmcsSetCameraAngle(anglex,angley,anglez: single); stdcall;
begin
  world.Camera.anglex := anglex;
  world.Camera.angley := angley;
  world.Camera.anglez := anglez;
end;

{ visszaadja a kamera látószögét }
procedure tmcsSetCameraFov(fov: Double); stdcall;
begin
  world.Camera.fov := fov;
end;

{ visszaadja a kamera képének oldalarányát}
procedure tmcsSetCameraAspect(aspect: Double); stdcall;
begin
  world.Camera.aspect := aspect;
end;

{ visszaadja a közeli vágósík kamerától való távolságát }
procedure tmcsSetCameraNearPlane(znear: Double); stdcall;
begin
  world.Camera.znear := znear;
end;

{ visszaadja a távoli vágósík kamerától való távolságát }
procedure tmcsSetCameraFarPlane(zfar: Double); stdcall;
begin
  world.Camera.zfar := zfar;
end;

{ beállítja a viewport pozícióját és méretét }
procedure tmcsSetviewport(x,y,w,h: integer); stdcall;
begin
  glViewport(x,y,w,h);
  world.Camera.targettex_w := w;
  world.Camera.targettex_h := h;
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(world.Camera.fov, world.Camera.aspect, world.Camera.zNear, world.Camera.zFar);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
end;

{ beállítja a kamera alap tulajdonságait }
procedure tmcsInitCamera(x,y,z,ax,ay,az: single; fovy,asp,zn,zf: Double); stdcall;
begin
  with world.Camera do
    begin
      posx := x;
      posy := y;
      posz := z;
      anglex := ax;
      angley := ay;
      anglez := az;
      fov := fovy;
      aspect := asp;
      znear := zn;
      zfar := zf;
    end;
end;

{ adott szöget alakít 0 és 359 fok közöttivé }
function tmcsWrapAngle(f: single): single; stdcall;
var
  started: cardinal;
  startvalue: single;
begin
  startvalue := f;
  started := gettickcount();
  if ( (f >= 0.0) and (f < 360.0) ) then
    result := f
   else
    begin
      if ( f < 0.0 ) then
        begin
          while ( f < 0.0 ) do
            begin
              f := f + 360;
              if ( gettickcount()-started >= 2 ) then
                begin
                  f := 0;
                  break;
                end;
            end;
        end
       else
        begin
          while ( f >= 360.0 ) do
            begin
              f := f - 360;
              if ( gettickcount()-started >= 2 ) then
                begin
                  f := 0;
                  break;
                end;
            end;
        end;
      result := f;
    end;
end;

{ forgásszög alapján új koordináta-részletet ad vissza }
function tmcsGetNewX(x: single; angle: single; factor: single): single; stdcall;
begin
  result := x - cos((angle+90)*pi/180)/200*factor;
end;

{ forgásszög alapján új koordináta-részletet ad vissza }
function tmcsGetNewZ(z: single; angle: single; factor: single): single; stdcall;
begin
  result := z + sin((angle+90)*pi/180)/200*factor;
end;

{
  ##############################################################################
  <------------------------------ VILÁG KEZELÉSE ------------------------------>
  ##############################################################################
}

{ beállítja a világ háttérszínét }
procedure tmcsSetBgColor(r,g,b,a: byte); stdcall;
begin
  tmcsbgcolor.r := r;
  tmcsbgcolor.g := g;
  tmcsbgcolor.b := b;
  tmcsbgcolor.a := a;
  glClearColor(r/255,g/255,b/255,a/255);
end;

{ visszaadja az objektumok számát }
function tmcsGetTotalObjects(): word; stdcall;
begin
  result := world.Objects.Count;
end;

{ megmondja, hogy adott objektumnak hány alobjektuma van }
function tmcsGetNumSubObjects(num: word): integer; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.submodels.Count;
    end
   else result := -1;
end;

{ létrehoz egy kockát, és visszaadja a sorszámát }
function tmcsCreateCube(a: single): integer; stdcall;
var i,j: integer;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsCreateCube('+floattostr(a)+') ...');
  new(model);
  model^.posx := 0;
  model^.posy := 0;
  model^.posz := 0;
  model^.sizex := a;
  model^.sizey := a;
  model^.sizez := a;
  model^.anglex := 0;
  model^.angley := 0;
  model^.anglez := 0;
  model^.scaling := 1;
  model^.textured := false;
  model^.affectedbylights := true;
  model^.blended := false;
  model^.doublesided := false;
  model^.visible := true;
  model^.wireframe := false;
  model^.tessellated := false;
  model^.compiled := false;
  model^.sticked := false;
  model^.zbuffered := true;
  model^.colorkey.r := 255;
  model^.colorkey.g := 255;
  model^.colorkey.b := 255;
  model^.colorkey.a := 255;
  model^.multitextured := false;
  model^.multitexassigned := -1;
  model^.reference := -1;
  model^.submodels := TList.Create;
  new(submodel);
  model^.submodels.Add(submodel);
  submodel^.vertices := TList.Create;
  submodel^.faces := TList.Create;
  submodel^.uvwcoords := nil;
  submodel^.textured := false;
  submodel^.visible := true;
  model^.rotationxzy := true;

  // bal szélsõ lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > left plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := -1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('    ('+floattostr(vertex^.x)+';'
                                                     +floattostr(vertex^.y)+';'
                                                     +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('    ('+floattostr(vertex^.nx)+';'
                                                     +floattostr(vertex^.ny)+';'
                                                     +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('    ('+floattostr(vertex^.u)+';'
                                                     +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := -1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := -1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := -1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i;
  face^.tex := 0;
  submodel^.faces.Add(face);

  // jobb szélsõ lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > right plane...');
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+4;
  face^.tex := 0;
  submodel^.faces.Add(face);
  // közép alsó lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > center bottom plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 0;
  vertex^.ny := -1;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 0;
  vertex^.ny := -1;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 0;
  vertex^.ny := -1;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 0;
  vertex^.ny := -1;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+8;
  face^.tex := 0;
  submodel^.faces.Add(face);
  // közép felsõ lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > center upper plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 0;
  vertex^.ny := 1;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 0;
  vertex^.ny := 1;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 0;
  vertex^.ny := 1;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 0;
  vertex^.ny := 1;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+12;
  face^.tex := 0;
  submodel^.faces.Add(face);
  // közép elsõ lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > center front plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz - a/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+16;
  face^.tex := 0;
  submodel^.faces.Add(face);
  // közép hátsó lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > center rear plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := 1;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := 1;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := 1;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + a/2;
  vertex^.z := model^.posz + a/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := 1;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+20;
  face^.tex := 0;
  submodel^.faces.Add(face);
  for i := 0 to submodel^.faces.Count-1 do
    begin
      face := submodel^.faces[i];
      for j := 0 to 3 do
        begin
          vertex := submodel^.vertices[ face^.vertices[j] ];
          vertex^.color.r := 255;
          vertex^.color.g := 255;
          vertex^.color.b := 255;
          vertex^.color.a := 255;
        end;
    end;
  result := world.Objects.Add(model);
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > done, '+inttostr(submodel^.vertices.Count)+' vertex, '+inttostr(submodel^.faces.Count)+' face; '+
          ' list capacity: '+inttostr(world.Objects.Capacity)+', object count: '+inttostr(world.Objects.Count) );
end;

{ létrehoz egy téglatestet, és visszaadja a sorszámát }
function tmcsCreateBox(a,b,c: single): integer; stdcall;
var i,j: integer;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsCreateBox('+floattostr(a)+';'+floattostr(b)+';'+floattostr(c)+') ...');
  new(model);
  model^.posx := 0;
  model^.posy := 0;
  model^.posz := 0;
  model^.sizex := a;
  model^.sizey := b;
  model^.sizez := c;
  model^.anglex := 0;
  model^.angley := 0;
  model^.anglez := 0;
  model^.scaling := 1;
  model^.textured := false;
  model^.affectedbylights := true;
  model^.blended := false;
  model^.doublesided := false;
  model^.visible := true;
  model^.wireframe := false;
  model^.tessellated := false;
  model^.compiled := false;
  model^.sticked := false;
  model^.zbuffered := true;
  model^.colorkey.r := 255;
  model^.colorkey.g := 255;
  model^.colorkey.b := 255;
  model^.colorkey.a := 255;
  model^.multitextured := false;
  model^.multitexassigned := -1;
  model^.reference := -1;
  model^.submodels := TList.Create;
  new(submodel);
  model^.submodels.Add(submodel);
  submodel^.vertices := TList.Create;
  submodel^.faces := TList.Create;
  submodel^.uvwcoords := nil;
  submodel^.textured := false;
  submodel^.visible := true;
  model^.rotationxzy := true;

  // bal szélsõ lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > left plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := -1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := -1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := -1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := -1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i;
  face^.tex := 0;
  submodel^.faces.Add(face);

  // jobb szélsõ lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > right plane...');
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 1;
  vertex^.ny := 0;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+4;
  face^.tex := 0;
  submodel^.faces.Add(face);
  // közép alsó lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > center bottom plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 0;
  vertex^.ny := -1;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 0;
  vertex^.ny := -1;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 0;
  vertex^.ny := -1;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 0;
  vertex^.ny := -1;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+8;
  face^.tex := 0;
  submodel^.faces.Add(face);
  // közép felsõ lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > center upper plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 0;
  vertex^.ny := 1;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 0;
  vertex^.ny := 1;
  vertex^.nz := 0;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 0;
  vertex^.ny := 1;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 0;
  vertex^.ny := 1;
  vertex^.nz := 0;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+12;
  face^.tex := 0;
  submodel^.faces.Add(face);
  // közép elsõ lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > center front plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz - c/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+16;
  face^.tex := 0;
  submodel^.faces.Add(face);
  // közép hátsó lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > center rear plane...');
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := 1;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy - b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := 1;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := 1;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - a/2;
  vertex^.y := model^.posy + b/2;
  vertex^.z := model^.posz + c/2;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := 1;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i+20;
  face^.tex := 0;
  submodel^.faces.Add(face);
  for i := 0 to submodel^.faces.Count-1 do
    begin
      face := submodel^.faces[i];
      for j := 0 to 3 do
        begin
          vertex := submodel^.vertices[ face^.vertices[j] ];
          vertex^.color.r := 255;
          vertex^.color.g := 255;
          vertex^.color.b := 255;
          vertex^.color.a := 255;
        end;
    end;
  result := world.Objects.Add(model);
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > done, '+inttostr(submodel^.vertices.Count)+' vertex, '+inttostr(submodel^.faces.Count)+' face; '+
          ' list capacity: '+inttostr(world.Objects.Capacity)+', object count: '+inttostr(world.Objects.Count) );
end;

{ létrehoz egy sík lapot, és visszaadja a sorszámát }
function tmcsCreatePlane(w,h: single): integer; stdcall;
var i: integer;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsCreatePlane('+floattostr(w)+','+floattostr(h)+') ...');
  new(model);
  model^.posx := 0;
  model^.posy := 0;
  model^.posz := 0;
  model^.sizex := w;
  model^.sizey := h;
  model^.sizez := 0;
  model^.anglex := 0;
  model^.angley := 0;
  model^.anglez := 0;
  model^.scaling := 1;
  model^.textured := false;
  model^.affectedbylights := true;
  model^.blended := false;
  model^.doublesided := false;
  model^.visible := true;
  model^.wireframe := false;
  model^.zbuffered := true;
  model^.tessellated := false;
  model^.compiled := false;
  model^.sticked := false;
  model^.colorkey.r := 255;
  model^.colorkey.g := 255;
  model^.colorkey.b := 255;
  model^.colorkey.a := 255;
  model^.multitextured := false;
  model^.multitexassigned := -1;
  model^.reference := -1;
  model^.submodels := TList.Create;
  new(submodel);
  model^.submodels.Add(submodel);
  submodel^.vertices := TList.Create;
  submodel^.faces := TList.Create;
  submodel^.uvwcoords := nil;
  submodel^.textured := false;
  submodel^.visible := true;
  model^.rotationxzy := true;

  // a lap
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > the plane...');
  new(vertex);
  vertex^.x := model^.posx - w/2;
  vertex^.y := model^.posy - h/2;
  vertex^.z := model^.posz;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 0;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + w/2;
  vertex^.y := model^.posy - h/2;
  vertex^.z := model^.posz;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 1;
  vertex^.v := 0;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx + w/2;
  vertex^.y := model^.posy + h/2;
  vertex^.z := model^.posz;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 1;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(vertex);
  vertex^.x := model^.posx - w/2;
  vertex^.y := model^.posy + h/2;
  vertex^.z := model^.posz;
  vertex^.nx := 0;
  vertex^.ny := 0;
  vertex^.nz := -1;
  vertex^.u := 0;
  vertex^.v := 1;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.x)+';'
                                                    +floattostr(vertex^.y)+';'
                                                    +floattostr(vertex^.z)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.nx)+';'
                                                    +floattostr(vertex^.ny)+';'
                                                    +floattostr(vertex^.nz)+') ');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('   ('+floattostr(vertex^.u)+';'
                                                    +floattostr(vertex^.v)+') ');
  submodel^.vertices.Add(vertex);
  new(face);
  for i := 0 to 3 do
    face^.vertices[i] := i;
  face^.tex := 0;
  submodel^.faces.Add(face);

  for i := 0 to 3 do
    begin
      vertex := submodel^.vertices[ i ];
      vertex^.color.r := 255;
      vertex^.color.g := 255;
      vertex^.color.b := 255;
      vertex^.color.a := 255;
    end;

  result := world.Objects.Add(model);
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > kész, '+inttostr(submodel^.vertices.Count)+' vertex, '+inttostr(submodel^.faces.Count)+' face; '+
          ' list capacity: '+inttostr(world.Objects.Capacity)+', object count: '+inttostr(world.Objects.Count) );
end;

function tmcsCreateTextureFromFile(fname: TFileName; mipmapped,border,compressed: boolean; filtering,envmode,wrap_s,wrap_t: TGLConst): integer; stdcall; forward;

{ módosítja a külsõ modellfájlok textúráinak megjelenítési beállításait }
procedure tmcsSetExtObjectsTextureMode(mipmapping: boolean; filtering,envmode: TGLConst; border,compressed: boolean; wrap_s,wrap_t: TGLConst); stdcall;
begin
  with world do
    begin
      extobjectstexmode.mipmapping := mipmapping;
      extobjectstexmode.compression := compressed;
      extobjectstexmode.filtering := filtering;
      extobjectstexmode.envmode := envmode;
      if ( border ) then extobjectstexmode.border := 1
        else extobjectstexmode.border := 0;
      extobjectstexmode.wrap_s := wrap_s;
      extobjectstexmode.wrap_t := wrap_t;
    end;
end;

{ adott indexû objektumot VRAM-ba rakja }
procedure tmcsCompileObject(index: word); stdcall;
var
  model2: PModel;
  submodel2: PSubmodel;
  face2: PFace;
  uvw2: PUVW;
  j,k,l: integer;
  lasttex,lasttex2: GLuint;
begin
  if ( (index <= world.Objects.Count-1) and (assigned(world.objects[index])) ) then
    begin
      lasttex := 0;
      lasttex2 := 0;
      model := world.Objects[index];
      if ( not(model^.compiled) ) then
        begin
          model^.compiled := true;
          for l := 0 to model^.submodels.Count-1 do
            begin
              submodel := model^.submodels[l];
              submodel^.displaylist := glGenLists(1);
              glNewList(submodel^.displaylist,GL_COMPILE);
              //if ( submodel^.visible ) then
                begin
                  //if ( submodel^.textured ) then glEnable(GL_TEXTURE_2D)
                   //else glDisable(GL_TEXTURE_2D);
                  if (l > 0) then lasttex := face^.tex;
                  face := submodel^.faces[0]; // magyarázat lentebb...

                  if ( model^.multitextured ) then
                    begin
                      if ( assigned(glActiveTextureARB) ) then
                        begin  // multitextúrázva van, és van ilyen extensionünk
                          model2 := world.objects[ model^.multitexassigned ];
                          submodel2 := model2^.submodels[l];
                          if (l > 0) then lasttex2 := face2^.tex;
                          face2 := submodel2^.faces[0];
                          if ( face^.tex <> lasttex ) then
                            begin
                              glActiveTextureARB(GL_TEXTURE0_ARB);
                              glBindTexture(GL_TEXTURE_2D, face^.tex);
                            end;
                          if ( face2^.tex <> lasttex2 ) then
                            begin
                              glActiveTextureARB(GL_TEXTURE1_ARB);
                              glBindTexture(GL_TEXTURE_2D, face2^.tex);
                            end;
                        end
                       else
                        begin // multitextúrázva van, de nincs ilyen extensionünk
                          if ( face^.tex <> lasttex ) then
                            glBindTexture(GL_TEXTURE_2D, face^.tex);
                        end;
                    end
                   else
                    begin
                      if ( assigned(glActiveTextureARB) ) then
                        begin // nem multitextúrázott, van extension
                          //glActiveTextureARB(GL_TEXTURE1_ARB);
                          //glDisable(GL_TEXTURE_2D);
                          glActiveTextureARB(GL_TEXTURE0_ARB);
                          if ( face^.tex <> lasttex ) then
                            glBindTexture(GL_TEXTURE_2D,face^.tex);
                        end
                       else
                        begin // nem multitextúrázott, és nincs is extension
                          if ( face^.tex <> lasttex ) then
                            glBindTexture(GL_TEXTURE_2D, face^.tex);
                        end;
                    end;
                  if ( model^.tessellated ) then glBegin(GL_TRIANGLES)
                    else glBegin(GL_QUADS);
                  for j := 0 to submodel^.faces.Count-1 do
                    begin
                      face := submodel^.faces[j];
                      if ( model^.multitextured ) then face2 := submodel2^.faces[j];
                      // if ( submodel^.textured ) then glBindTexture(GL_TEXTURE_2D,face^.tex);
                      // performance-hack:elvileg face-enként más-más textúra lehet, de felesleges...
                      // a glbindtexture idõigényes, ezért csak subobjectenként váltunk...
                      if ( model^.tessellated ) then
                        begin
                          for k := 0 to 2 do
                            begin
                              vertex := submodel^.vertices[ face^.vertices[k]-1 ];
                              if ( submodel^.textured ) then
                                begin
                                  if ( model^.multitextured ) then
                                    begin
                                      if ( assigned(glMultiTexCoord2fARB) ) then
                                        begin // multitextúrázott model, van extension
                                          uvw := submodel^.uvwcoords[ face^.uvcoords[k]-1 ];
                                          uvw2 := submodel2^.uvwcoords[ face2^.uvcoords[k]-1 ];
                                          glMultiTexCoord2fARB(GL_TEXTURE0_ARB, uvw^.u, uvw^.v);
                                          glMultiTexCoord2fARB(GL_TEXTURE1_ARB, uvw2^.u, uvw2^.v);
                                        end
                                       else
                                        begin // multitextúrázott model, de nincs extension
                                          uvw := submodel^.uvwcoords[ face^.uvcoords[k]-1 ];
                                          glTexCoord2f(uvw^.u,uvw^.v);
                                        end;
                                    end  // model^.multitextured
                                   else
                                    begin  // nem multitextúrázott model
                                      uvw := submodel^.uvwcoords[ face^.uvcoords[k]-1 ];
                                      glTexCoord2f(uvw^.u,uvw^.v);
                                    end;
                                end  // subomdel.textured
                               else
                                begin
                                  glColor4ub(vertex^.color.r,vertex^.color.g,vertex^.color.b,vertex^.color.a);
                                end;
                              if ( model^.affectedbylights ) then glNormal3f(vertex^.nx,vertex^.ny,vertex^.nz);
                              glVertex3f(vertex^.x,vertex^.y,vertex^.z);
                            end;  // k ciklus
                        end  // model^.tessellated
                       else
                        begin
                          for k := 0 to 3 do
                            begin
                              vertex := submodel^.vertices[ face^.vertices[k] ];
                              if ( submodel^.textured ) then
                                begin
                                  glTexCoord2f(vertex^.u,vertex^.v);
                                end
                               else
                                begin
                                  glColor4ub(vertex^.color.r,vertex^.color.g,vertex^.color.b,vertex^.color.a);
                                end;
                              if ( model^.affectedbylights ) then glNormal3f(vertex^.nx,vertex^.ny,vertex^.nz);
                              glVertex3f(vertex^.x,vertex^.y,vertex^.z);
                            end;  // k ciklus
                        end;  // endif model^.tessellated
                     end;  // j ciklus
                  glEnd();
                end; // endif submodel^.visible
              glEndList();
            end; // l ciklus

           for l := 0 to model^.submodels.Count-1 do
             begin
               submodel := model^.submodels[l];
               if ( assigned(submodel^.vertices) ) then
                 begin
                   for j := 0 to submodel^.vertices.Count-1 do
                     begin
                       if ( assigned(submodel^.vertices[j]) ) then dispose(submodel^.vertices[j]);
                       submodel^.vertices[j] := nil;
                     end;
                   submodel^.vertices.Free;
                 end;
               if ( assigned(submodel^.uvwcoords) ) then
                 begin
                   for j := 0 to submodel^.uvwcoords.Count-1 do
                     begin
                       if ( assigned(submodel^.uvwcoords[j]) ) then dispose(submodel^.uvwcoords[j]);
                       submodel^.uvwcoords[j] := nil;
                     end;
                   submodel^.uvwcoords.Free;
                 end;
               if ( assigned(submodel^.faces) ) then
                 begin
                   for j := 0 to submodel^.faces.Count-1 do
                     begin
                       if ( assigned(submodel^.faces[j]) ) then dispose(submodel^.faces[j]);
                       submodel^.faces[j] := nil;
                     end;
                   submodel^.faces.Free;
                 end;
             end;
        end;  // not(model^.compiled)
    end;
end;

{ adott tesszellált .OBJ modellfájlt tölt be és a motor számára natív formára alakítja }
function tmcsCreateObjectFromFile(fname: TSTR40; compiled: boolean): integer; stdcall;
var
  i,j,k,l,m: integer;
  a: TStringList;
  s1,s2,s3: string;
  fsp,ssp,tsp: byte;
  numv,numt: integer;
  offsv,offst: integer;
  t: integer;
  t2: integer;
  boolborder: boolean;
  modelminx,modelmaxx,modelminy,modelmaxy,modelminz,modelmaxz: GLfloat;
  smodelminx,smodelmaxx,smodelminy,smodelmaxy,smodelminz,smodelmaxz: GLfloat;
  minvertexx,maxvertexx,minvertexy,maxvertexy,minvertexz,maxvertexz: GLfloat;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsCreateObjectFromFile('''+fname+''') ...');
  if ( fileExists(fname) ) then
    begin
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > file exists, reading ...');
      a := TStringList.Create;
      a.LoadFromFile(fname);
      new(model);
      model^.posx := 0;
      model^.posy := 0;
      model^.posz := 0;
      model^.anglex := 0;
      model^.angley := 0;
      model^.anglez := 0;
      model^.textured := false;
      model^.affectedbylights := true;
      model^.blended := false;
      model^.doublesided := false;
      model^.wireframe := false;
      model^.zbuffered := true;
      model^.scaling := 1;
      model^.visible := true;
      model^.rotationxzy := true;
      model^.tessellated := true;
      model^.sticked := false;
      model^.colorkey.r := 255;
      model^.colorkey.g := 255;
      model^.colorkey.b := 255;
      model^.colorkey.a := 255;
      model^.multitextured := false;
      model^.multitexassigned := -1;
      model^.submodels := TList.Create;
      model^.compiled := false;
      model^.reference := -1;
      model^.name := extractfilename(fname);

      minvertexx := 0;
      maxvertexx := 0;
      minvertexy := 0;
      maxvertexy := 0;
      minvertexz := 0;
      maxvertexz := 0;

      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > file read, processing ...');
      i := 0;
      offsv := 0;
      offst := 0;

      //try
      while ( i < a.Count-3 ) do
        begin
          new(submodel);
          model^.submodels.Add(submodel);
          submodel^.vertices := TList.Create;
          submodel^.uvwcoords := TList.Create;
          submodel^.faces := TList.Create;
          submodel^.visible := true;
          while ( copy(a[i],1,1) <> 'v' ) do i := i+1;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('   > 1st processable line: '+inttostr(i+1));
          j := i;
          while ( copy(a[j],1,2) <> 'vt' ) do j := j+1;
          j := j-2;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('    <--- V E R T I C E S --->');
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('     > vertex count: '+inttostr(j-i));
          numv := j-i;

          for k := i to i+numv-1 do
            begin
              // FIX in 2018: moving these 2 lines from before loop into loop
              // reason: there are some rare cases when none of 1st vertex coordinate contains decimal separator in the obj file
              // in those cases, decimalseparator would be wrongly set to ',', and that would result in EConvertError exception
              // so better to set it per vertex, which obviously slower, but safer now for a quick solution ...
              if ( pos('.',a[k]) > 0 ) then decimalseparator := '.'
                else decimalseparator := ',';

              new(vertex);
              vertex^.color.r := 255;
              vertex^.color.g := 255;
              vertex^.color.b := 255;
              vertex^.color.a := 255;
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append('Nyers: '+a[k]);
              a[k] := copy(a[k],4,length(a[k])-3);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append('Tag elhagyva: '+a[k]);
              fsp := pos(' ',a[k]);
              s1 := copy(a[k],1,fsp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              vertex^.x := strtofloat(s1);
              s1 := copy(a[k],fsp+1,length(a[k])-fsp);
              s2 := s1;
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              ssp := pos(' ',s1);
              s1 := copy(s1,1,ssp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              vertex^.y := strtofloat(s1);
              s1 := copy(s2,ssp+1,length(s2)-ssp);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              vertex^.z := strtofloat(s1);
              submodel^.vertices.Add(vertex);
            end;
          if ( submodel^.vertices.Count > 0 ) then
            begin
              vertex := submodel^.vertices[0];
              smodelminx := vertex^.x;
              smodelmaxx := vertex^.x;
              smodelminy := vertex^.y;
              smodelmaxy := vertex^.y;
              smodelminz := vertex^.z;
              smodelmaxz := vertex^.z;
              if ( model^.submodels.Count = 1 ) then
                begin
                  minvertexx := vertex^.x;
                  maxvertexx := vertex^.x;
                  minvertexy := vertex^.y;
                  maxvertexy := vertex^.y;
                  minvertexz := vertex^.z;
                  maxvertexz := vertex^.z;
                end;
              for m := 1 to submodel^.vertices.count-1 do
                begin
                  vertex := submodel^.vertices[m];
                  if ( vertex^.x < smodelminx ) then smodelminx := vertex^.x
                    else if ( vertex^.x > smodelmaxx ) then smodelmaxx := vertex^.x;
                  if ( vertex^.y < smodelminy ) then smodelminy := vertex^.y
                    else if ( vertex^.y > smodelmaxy ) then smodelmaxy := vertex^.y;
                  if ( vertex^.z < smodelminz ) then smodelminz := vertex^.z
                    else if ( vertex^.z > smodelmaxz ) then smodelmaxz := vertex^.z;
                  if ( vertex^.x < minvertexx ) then minvertexx := vertex^.x
                    else if ( vertex^.x > maxvertexx ) then maxvertexx := vertex^.x;
                  if ( vertex^.y < minvertexy ) then minvertexy := vertex^.y
                    else if ( vertex^.y > maxvertexy ) then maxvertexy := vertex^.y;
                  if ( vertex^.z < minvertexz ) then minvertexz := vertex^.z
                    else if ( vertex^.z > maxvertexz ) then maxvertexz := vertex^.z;
                end;
            end
           else
            begin
              smodelminx := 0;
              smodelminy := 0;
              smodelminz := 0;
              smodelmaxx := 0;
              smodelmaxy := 0;
              smodelmaxz := 0;
            end;
          submodel^.sizex := abs(smodelmaxx - smodelminx);
          submodel^.sizey := abs(smodelmaxy - smodelminy);
          submodel^.sizez := abs(smodelmaxz - smodelminz);
          submodel^.posx := (smodelminx + smodelmaxx) / 2;
          submodel^.posy := (smodelminy + smodelmaxy) / 2;
          submodel^.posz := (smodelminz + smodelmaxz) / 2;
          i := j+2;
          j := i;
          while ( copy(a[j],1,2) = 'vt' ) do j := j+1;
          j := j-1;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('    <--- U V W - C O O R D I N A T E S --->');
          numt := j-i+1;
          for k := i to j do
            begin
              if ( pos('.',a[k]) > 0 ) then decimalseparator := '.'
                else decimalseparator := ',';
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append('Nyers: '+a[k]);
              new(uvw);
              a[k] := copy(a[k],5,length(a[k])-4);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append('Tag elhagyva: '+a[k]);
              fsp := pos(' ',a[k]);
              s1 := copy(a[k],1,fsp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              uvw^.u := strtofloat(s1);
              s1 := copy(a[k],fsp+1,length(a[k])-fsp);
              s2 := s1;
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              ssp := pos(' ',s1);
              s1 := copy(s1,1,ssp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              uvw^.v := strtofloat(s1);
              s1 := copy(s2,ssp+1,length(s2)-ssp);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              uvw^.w := strtofloat(s1);
              submodel^.uvwcoords.Add(uvw);
            end;
          i := k;
          while ( copy(a[i],1,2) <> 'vn' ) do i := i+1;
          j := i;
          while ( copy(a[j],1,2) = 'vn' ) do j := j+1;
          j := j-1;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('    <--- N O R M A L S --->');
          for k := i to j do
            begin
              if ( pos('.',a[k]) > 0 ) then decimalseparator := '.'
                else decimalseparator := ',';
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append('Nyers: '+a[k]);
              a[k] := copy(a[k],5,length(a[k])-4);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append('Tag elhagyva: '+a[k]);
              fsp := pos(' ',a[k]);
              s1 := copy(a[k],1,fsp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append('vertex: '+inttostr(k-i)+'; num of vertices: '+inttostr(submodel^.vertices.Count));
              vertex := submodel^.vertices[k-i];
              vertex^.nx := strtofloat(s1);
              s1 := copy(a[k],fsp+1,length(a[k])-fsp);
              s2 := s1;
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              ssp := pos(' ',s1);
              s1 := copy(s1,1,ssp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              vertex^.ny := strtofloat(s1);
              s1 := copy(s2,ssp+1,length(s2)-ssp);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              vertex^.nz := strtofloat(s1);
            end;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('    <--- F A C E S --->');
          i := k;
          while ( copy(a[i],1,1) <> 'g' ) do i := i+1;
          s1 := copy(a[i],3,length(a[i])-2);
          t := pos('|',s1);
          if ( t > 0 ) then
            begin
              submodel^.name := copy(s1,1,t-1);
              boolborder := ( world.extobjectstexmode.border = 1 ); 
              t2 := tmcsCreateTextureFromFile(extractfilepath(fname)+copy(s1,t+1,length(s1)-t),
                                              world.extobjectstexmode.mipmapping,
                                              boolborder,
                                              world.extobjectstexmode.compression,
                                              world.extobjectstexmode.filtering,
                                              world.extobjectstexmode.envmode,
                                              world.extobjectstexmode.wrap_s,
                                              world.extobjectstexmode.wrap_t);
              submodel^.textured := t2 > -1;
              if ( not(model^.textured) and submodel^.textured ) then model^.textured := true;
            end
           else
            begin
              submodel^.name := s1;
              submodel^.textured := false;
            end;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('    > Submodel: '+submodel^.name);
          while ( copy(a[i],1,1) <> 'f' ) do i := i+1;
          j := i;
          while ( copy(a[j],1,1) = 'f' ) do j := j+1;
          j := j-1;
          for k := i to j do
            begin
              new(face);
              if ( submodel^.textured ) then
                begin
                  texture := world.Textures[t2];
                  face^.tex := texture^.internalnum;
                end
               else face^.tex := 0;
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append('Nyers: '+a[k]);
              a[k] := copy(a[k],3,length(a[k])-2);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append('Tag elhagyva: '+a[k]);
              fsp := pos(' ',a[k]);
              s1 := copy(a[k],1,fsp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              //
              ssp := pos('/',s1);
              s2 := copy(s1,1,ssp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s2);
              face^.vertices[0] := strtoint(s2)-offsv;
              s2 := copy(s1,ssp+1,pos('/',copy(s1,ssp+1,length(s1)-ssp))-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s2);
              face^.uvcoords[0] := strtoint(s2)-offst;
              //
              s1 := copy(a[k],fsp+1,length(a[k])-fsp);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              //
              ssp := pos('/',s1);
              s2 := copy(s1,1,ssp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s2);
              face^.vertices[1] := strtoint(s2)-offsv;
              s2 := copy(s1,ssp+1,pos('/',copy(s1,ssp+1,length(s1)-ssp))-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s2);
              face^.uvcoords[1] := strtoint(s2)-offst;
              //
              s2 := s1;
              ssp := pos(' ',s1);
              s1 := copy(s1,1,ssp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              s1 := copy(s2,ssp+1,length(s2)-ssp);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s1);
              //
              ssp := pos('/',s1);
              s2 := copy(s1,1,ssp-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s2);
              face^.vertices[2] := strtoint(s2)-offsv;
              s2 := copy(s1,ssp+1,pos('/',copy(s1,ssp+1,length(s1)-ssp))-1);
              //if ( tmcsdebug ) then frm_c.mm.Lines.Append(s2);
              face^.uvcoords[2] := strtoint(s2)-offst;
              //
              submodel^.faces.Add(face);
            end;
          offsv := offsv + numv;
          offst := offst + numt;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('    > offsv = '+inttostr(offsv)+' ; offst = '+inttostr(offst));
          i := j+1;
          while ( (copy(a[i],1,1) <> 'v') and (i < a.Count-1) ) do
            begin
              i := i+1;
              if ( tmcsdebug ) then frm_c.mm.Lines.Append('    > i = '+inttostr(i)+'; a[i] = '+a[i]);
            end;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('     > i = '+inttostr(i)+'; a[i] = '+a[i]);
          i := i-2;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('     > clearing lines from 0 to '+inttostr(i)+' (count-1 = '+inttostr(a.Count-1)+') ...');
          if ( tmcsdebug ) then frm_c.mm.lines.Append('     > Subobject posx/posy/posz/sizex/sizey/sizez: '+floattostr(submodel^.posx)+'/'+floattostr(submodel^.posy)+'/'+floattostr(submodel^.posz)+'/'
                                                                                                            +floattostr(submodel^.sizex)+'/'+floattostr(submodel^.sizey)+'/'+floattostr(submodel^.sizez));
          {for k := 0 to i do
            a.Delete(k);   }
        end; // endwhile
      a.Clear;
      a.Free;
      //except
      //on exception do
      //  frm_c.mm.Lines.SaveToFile('tmcslog2.txt');
      //end;

      if ( model^.submodels.Count > 0 ) then
        begin
          model^.sizex := maxvertexx - minvertexx;
          model^.sizey := maxvertexy - minvertexy;
          model^.sizez := maxvertexz - minvertexz;
          if ( tmcsdebug ) then frm_c.mm.lines.Append(floattostr(maxvertexx)+';'+floattostr(minvertexx));
          if ( tmcsdebug ) then frm_c.mm.lines.Append(floattostr(maxvertexy)+';'+floattostr(minvertexy));
          if ( tmcsdebug ) then frm_c.mm.lines.Append(floattostr(maxvertexz)+';'+floattostr(minvertexz));
        end
       else
        begin
          model^.sizex := 0.0;
          model^.sizey := 0.0;
          model^.sizez := 0.0;
        end;
      if ( tmcsdebug ) then frm_c.mm.lines.Append('  > Object sizex/sizey/sizez: '+floattostr(model^.sizex)+'/'+floattostr(model^.sizey)+'/'+floattostr(model^.sizez));
      result := world.objects.Add(model);
      if ( model^.compiled ) then tmcsCompileObject(result);
    end
   else
    begin
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > result: -1, file does not exist!');
      result := -1; // file nem létezik
    end;
end;

{ adott indexû objektumot multitextúrázottra állítja }
procedure tmcsSetObjectMultiTextured(index: word); stdcall;
begin
  if ( (index <= world.Objects.Count-1) and (assigned(world.objects[index])) ) then
    begin
      model := world.Objects[index];
      model^.multitextured := true;
    end;
end;

{ index2 objektum UV-adatait rendeli index1 2. textúrarétegének UV-adataihoz }
procedure tmcsMultiTexAssignObject(index1, index2: word); stdcall;
begin
  if ( (index1 <= world.Objects.Count-1) and assigned(world.objects[index1]) and (index2 <= world.Objects.Count-1) and assigned(world.objects[index2])) then
    begin
      model^.multitexassigned := index2;
    end;
end;

{ törli az adott objektumot }
procedure tmcsDeleteObject(index: word); stdcall;
var
  i,j: integer;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsDeleteObject('+inttostr(index)+') ...');
  if ( (index <= world.Objects.Count-1) and (assigned(world.objects[index])) ) then
    begin
      model := world.Objects[index];
      if ( assigned(model) ) then
        begin
          if ( model^.reference = -1 ) then
            begin
              for i := model^.submodels.Count-1 downto 0 do
                begin
                  submodel := model^.submodels[i];
                  if ( model^.compiled = FALSE ) then
                    begin
                      for j := submodel^.vertices.Count-1 downto 0 do
                        begin
                          vertex := submodel^.vertices[j];
                          dispose(vertex);
                          submodel^.vertices.Delete(j);
                        end;  // j ciklus
                      submodel^.vertices.Capacity := submodel^.vertices.Count;
                      submodel^.vertices.Free;
                      if ( assigned(submodel^.uvwcoords) ) then
                        begin
                          for j := submodel^.uvwcoords.Count-1 downto 0 do
                            begin
                              uvw := submodel^.uvwcoords[j];
                              dispose(uvw);
                              submodel^.uvwcoords.Delete(j);
                            end;  // j ciklus
                          submodel^.uvwcoords.Capacity := submodel^.uvwcoords.Count;
                          submodel^.uvwcoords.Free;
                        end;
                      for j := submodel^.faces.Count-1 downto 0 do
                        begin
                          face := submodel^.faces[j];
                          dispose(face);
                          submodel^.faces.Delete(j);
                        end;  // j ciklus
                      submodel^.faces.Capacity := submodel^.faces.Count;
                      submodel^.faces.Free;
                    end
                   else glDeleteLists(submodel^.displaylist,1);
                  dispose(submodel);
                  model^.submodels.Delete(i);
                end;  // i ciklus
            end;  // model^.reference > -1
          dispose(model);
          world.Objects[index] := nil;
        end;  // assigned(model)
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > kész!');
    end;  // (index <= world.Objects.Count-1) and (assigned(world.objects[index]))
end;  // proc. tmcsDeleteObject

{ törli az összes objektumot }
procedure tmcsDeleteObjects(); stdcall;
var i: integer;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsDeleteObjects() ...');
  for i := 0 to world.Objects.Count-1 do
    tmcsDeleteObject(i);
  world.Objects.Free;
  world.Objects := TList.Create;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > done; list capacity: '+inttostr(world.Objects.Capacity)+', object count: '+inttostr(world.Objects.Count));
end;

function tmcsCreateClonedObject(refersto: integer): integer; stdcall;
begin
  if ( (refersto <= world.Objects.Count-1) and assigned(world.Objects[refersto]) ) then
    begin
      new(model);
      model^.posx := pmodel(world.Objects[refersto])^.posx;
      model^.posy := pmodel(world.Objects[refersto])^.posy;
      model^.posz := pmodel(world.Objects[refersto])^.posz;
      model^.anglex := pmodel(world.Objects[refersto])^.anglex;
      model^.angley := pmodel(world.Objects[refersto])^.angley;
      model^.anglez := pmodel(world.Objects[refersto])^.anglez;
      model^.sizex := pmodel(world.Objects[refersto])^.sizex;
      model^.sizey := pmodel(world.Objects[refersto])^.sizey;
      model^.sizez := pmodel(world.Objects[refersto])^.sizez;
      model^.textured := pmodel(world.Objects[refersto])^.textured;
      model^.affectedbylights := pmodel(world.Objects[refersto])^.affectedbylights;
      model^.blended := pmodel(world.Objects[refersto])^.blended;
      model^.blendmode := pmodel(world.Objects[refersto])^.blendmode;
      model^.doublesided := pmodel(world.Objects[refersto])^.doublesided;
      model^.wireframe := pmodel(world.Objects[refersto])^.wireframe;
      model^.zbuffered := pmodel(world.Objects[refersto])^.zbuffered;
      model^.scaling := pmodel(world.Objects[refersto])^.scaling;
      model^.visible := pmodel(world.Objects[refersto])^.visible;
      model^.rotationxzy := pmodel(world.Objects[refersto])^.rotationxzy;
      model^.tessellated := pmodel(world.Objects[refersto])^.tessellated;
      model^.sticked := pmodel(world.Objects[refersto])^.sticked;
      model^.colorkey := pmodel(world.Objects[refersto])^.colorkey;
      model^.multitextured := pmodel(world.Objects[refersto])^.multitextured;
      model^.multitexassigned := pmodel(world.Objects[refersto])^.multitexassigned;
      model^.compiled := pmodel(world.Objects[refersto])^.compiled;
      model^.reference := refersto;
      model^.name := pmodel(world.Objects[refersto])^.name;
      result := world.Objects.Add(model);
    end
   else result := -1;
end;

{ adott objektumnak ki-/bekapcsolja a drótvázas megjelenítést }
procedure tmcsSetObjectWireframe(num: word; wf: boolean); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects.Items[num];
      model^.wireframe := wf;
    end;
end;

{ adott objektumnak ki-/bekapcsolja a 2D-s megjelenítését }
procedure tmcsSetObjectStickedState(num: word; state: boolean); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects.Items[num];
      model^.sticked := state;
    end;
end;

{ adott objektumnak ki-/bekapcsolja a Z-buffer számításban való részvételét }
procedure tmcsSetObjectZBuffered(num: word; state: boolean); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects.Items[num];
      model^.zbuffered := state;
    end;
end;

{ állítja a drótvázas megjelenésû objektumoknál a rejtett sokszögek megjelenítését }
procedure tmcsSetWiredCulling(state: boolean); stdcall;
begin
  tmcscullwired := state;
end;

{ adott objektum láthatóságát igazra állítja }
procedure tmcsShowObject(num: word); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects.Items[num];
      model^.visible := true;
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('! '+inttostr(num)+'. obj visible again.');
    end;
end;

{ adott objektumot elrejti }
procedure tmcsHideObject(num: word); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects.Items[num];
      model^.visible := false;
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('! '+inttostr(num)+'. obj visibility disabled.');
    end;
end;

{ adott objektumnál bekapcsolja az alapból rejtett sokszögek megjelenítését }
procedure tmcsSetObjectDoublesided(num: word; ds: boolean); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects.Items[num];
      model^.doublesided := ds;
      if ( ds ) then
        begin
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('! '+inttostr(num)+'. obj 2sided.');
        end
       else
        begin
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('! '+inttostr(num)+'. obj 1sided.');
        end;
    end;
end;

{ bekapcsolja a fények használatát }
procedure tmcsEnableLights(); stdcall;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsEnableLights()');
  glEnable(GL_LIGHTING);
  tmcslighting := true;
end;

{ kikapcsolja a fények használatát }
procedure tmcsDisableLights(); stdcall;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsDisableLights()');
  glDisable(GL_LIGHTING);
  tmcslighting := false;
end;

{ bekapcsolja az ambiens fényforrást }
procedure tmcsEnableAmbientLight(); stdcall;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsEnableAmbientLight()');
  glEnable(GL_LIGHT0);
end;

{ kikapcsolja az ambiens fényforrást }
procedure tmcsDisableAmbientLight(); stdcall;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsDisableAmbientLight()');
  glDisable(GL_LIGHT0);
end;

{ az ambiens fényforrás paramétereit állítja be (alap: 0.2,0.2,0.2) }
procedure tmcsSetAmbientLight(r,g,b: single); stdcall;
begin
  world.Lights.light_ambient[0] := r;
  world.Lights.light_ambient[1] := g;
  world.Lights.light_ambient[2] := b;
  glLightModelfv(GL_LIGHT_MODEL_AMBIENT,@world.lights.light_ambient);
end;

{
  ##############################################################################
  <----------------------------- TEXTÚRÁK KEZELÉSE ---------------------------->
  ##############################################################################
}

{ megadja, h adott fájlnevû textúra be van-e töltve, ha be van töltve, akkor
  visszaadja a sorszámát, ha nincs betöltve, akkor -1 az eredmény }
function tmcsTextureIsLoaded(fname: TSTR40): integer; stdcall;
var i,ind: integer;
    l: boolean;
begin
  l := false;
  i := 0;
  while ( (i < world.Textures.Count) and (not(l)) ) do
    begin
      texture := world.Textures[i];
      if ( assigned(texture) ) then
        begin
          l := ( texture^.filename = fname );
          if ( l ) then ind := i
            else i := i+1;
        end
       else i := i+1;
    end;
  if ( l ) then result := ind
    else result := -1; 
end;

{ betölt egy képet és textúrát csinál belõle, majd visszaadja a textúra sorszámát }
{ envmode = (GL_MODULATE, GL_DECAL, GL_BLEND) }
{ filtering = (GL_NEAREST, GL_LINEAR, GL_LINEAR_MIPMAP_NEAREST, GL_LINEAR_MIPMAP_LINEAR) }
function tmcsCreateTextureFromFile(fname: TFileName; mipmapped,border,compressed: boolean; filtering,envmode,wrap_s,wrap_t: TGLConst): integer; stdcall;
var
  pData: pointer;
  width: cardinal;
  height: cardinal;
  ind: integer;
  byteborder: byte;

{ betölti fname bmp-t, visszaadja méreteit és a pixelekre mutató pointert }
procedure LoadBitmap(fname: String; var width: Cardinal; var height: Cardinal; var pData: Pointer);
var
  FileHeader: TBITMAPFILEHEADER;
  InfoHeader: TBITMAPINFOHEADER;
  Palette: array of RGBQUAD;
  BitmapFile: THandle;
  BitmapLength: cardinal;
  PaletteLength: cardinal;
  ReadBytes: cardinal;

{ adott memóriaterületen végigmegy és megcseréli 3-as byte csoportok 0. és 2. byte-ját (BGR -> RGB) }
procedure SwapRGB(pdata: pointer; size: integer);
var i: integer;
    a: array[0..2] of byte;
    b: byte;
    p: pchar;
begin
  i := -1;
  p := pdata;
  while ( i < size-1 ) do
    begin
      i := i+1;
      copymemory(addr(a),p,3);
      b := a[0];
      a[0] := a[2];
      a[2] := b;
      copymemory(p,addr(a),3);
      inc(p);
      inc(p);
      inc(p);
    end;
end;

begin
  BitmapFile := CreateFile(PChar(fname), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if (BitmapFile = INVALID_HANDLE_VALUE) then
    begin
      Exit;
    end
   else
    begin
      // header
      ReadFile(BitmapFile, FileHeader, SizeOf(FileHeader), ReadBytes, nil);
      ReadFile(BitmapFile, InfoHeader, SizeOf(InfoHeader), ReadBytes, nil);

      // színpaletta
      PaletteLength := InfoHeader.biClrUsed;
      SetLength(Palette, PaletteLength);
      ReadFile(BitmapFile, Palette, PaletteLength, ReadBytes, nil);
      if (ReadBytes <> PaletteLength) then
        begin
         Exit;
        end
       else
        begin
          width := InfoHeader.biWidth;
          height := InfoHeader.biHeight;
          BitmapLength := InfoHeader.biSizeImage;
          if BitmapLength = 0 then BitmapLength := width * height * InfoHeader.biBitCount Div 8;

          // pixel adatok
          GetMem(pData, BitmapLength);
          ReadFile(BitmapFile, pData^, BitmapLength, ReadBytes, nil);
          if (ReadBytes <> BitmapLength) then Exit;
        end;
    end;
  CloseHandle(BitmapFile);
  SwapRGB(pData, Width*Height);
end;

begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsCreateTextureFromFile('''+fname+'''; '+booltostr(mipmapped,true)+'; '+booltostr(border,true)+'; '+booltostr(compressed,true)+'; '+inttostr(filtering)+'; '+inttostr(envmode)+') ...');
  ind := tmcsTextureIsLoaded(fname);
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > texloaded = '+inttostr(ind));
  if ( ind = -1 ) then
    begin
      pData := nil;

      if ( tmcsdebug ) then frm_c.mm.Lines.Append('   > bitmap processing...');
      LoadBitmap(fname, Width, Height, pData);
      if ( assigned(pData) ) then
        begin
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('   > bitmap processed!');
          new(texture);
          texture^.width := width;
          texture^.height := height;
          texture^.mipmapped := mipmapped;
          texture^.filename := fname;
          ind := world.Textures.Add(texture);
          glGenTextures(1, texture^.internalnum);
          glBindTexture(GL_TEXTURE_2D, texture^.internalnum);
          glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, envmode);
          glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); { közelebb van - nagyítás }
          glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filtering); { távolabb van - kicsinyítés }
          glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrap_s);
          glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrap_t);
          if ( border ) then byteborder := 1
            else byteborder := 0;
          if ( (compressed) and (hwinfo.hwtc) ) then
            begin
              if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > uploading compressed texture ...');
              if ( mipmapped ) then gluBuild2DMipmaps(GL_TEXTURE_2D, GL_COMPRESSED_RGB_ARB, width, height, GL_RGB, GL_UNSIGNED_BYTE, pData)
                else glTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_ARB, width, height, byteborder, GL_RGB, GL_UNSIGNED_BYTE, pData);
            end
           else
            begin
              if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > uploading uncompressed texture ...');
              if ( mipmapped ) then gluBuild2DMipmaps(GL_TEXTURE_2D, 3, width, height, GL_RGB, GL_UNSIGNED_BYTE, pData)
                 else glTexImage2D(GL_TEXTURE_2D, 0, 3, width, height, byteborder, GL_RGB, GL_UNSIGNED_BYTE, pData);
            end;

          freemem(pdata);
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > texture okay! '+inttostr(texture^.width)+' x '+inttostr(texture^.height)+' px; MIPmapped = '+booltostr(texture^.mipmapped,true));
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > return value: '+inttostr(ind)+'; gl internalnum: '+inttostr(texture^.internalnum));
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > lista kapacitás: '+inttostr(world.textures.Capacity)+', texcount: '+inttostr(world.textures.Count) );
          result := ind;
        end
       else
        begin
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('   > bitmap process failed!');
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > returned value: '+inttostr(high(GLuint)));
          result := -1;
        end;
    end
   else
    begin
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > the texture is already loaded!');
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > return value: '+inttostr(ind));
      result := ind;
    end;
end;

{ létrehoz egy üres textúrát }
function tmcsCreateBlankTexture(width, height: integer; filtering,envmode,wrap_s,wrap_t: TGLConst): integer; stdcall;
var
  ind: integer;
  ptr: pointer;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsCreateBlankTexture('+inttostr(width)+', '+inttostr(height)+', '+inttostr(filtering)+', '+inttostr(envmode)+')...');
  new(texture);
  texture^.width := width;
  texture^.height := height;
  texture^.filename := '';
  texture^.mipmapped := false;
  ind := world.Textures.Add(texture);
  getmem(ptr,width*height*3);
  zeromemory(ptr,width*height*3);
  glGenTextures(1, texture^.internalnum);
  glBindTexture(GL_TEXTURE_2D, texture^.internalnum);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, envmode);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); { közelebb van - nagyítás }
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filtering); { távolabb van - kicsinyítés }
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrap_s);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrap_t);
  glTexImage2D(GL_TEXTURE_2D, 0, 3, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, ptr);
  freemem(ptr);
  result := ind;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > texture okay, return value: '+inttostr(ind)+'; gl internalnum: '+inttostr(texture^.internalnum));
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > list capacity: '+inttostr(world.textures.Capacity)+', texcount: '+inttostr(world.textures.Count) );
end;

{ adott textúrára másolja a frame buffer tartalmát }
procedure tmcsFrameBufferToTexture(texnum: integer); stdcall;

begin
  if ( (texnum >= 0) and (texnum <= world.Textures.Count-1) and (assigned(world.textures[texnum])) ) then
    begin
      texture := world.Textures[texnum];
      if ( assigned(glActiveTextureARB) ) then
        begin
          glActiveTextureARB(GL_TEXTURE1_ARB);
          glDisable(GL_TEXTURE_2D);
          glActiveTextureARB(GL_TEXTURE0_ARB);
          glBindTexture(GL_TEXTURE_2D, texture^.internalnum);
        end
       else
        begin
          glBindTexture(GL_TEXTURE_2D, texture^.internalnum);
        end;
      glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, texture^.width, texture^.height, 0);
    end;
end;

{ num sorszámú objektumhoz rendeli a num2 sorszámú textúrát }
procedure tmcsTextureObject(num: word; num2: word); stdcall;
var j: integer;
begin
  try
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsTextureObject('+inttostr(num)+', '+inttostr(num2)+') ...');
  if ( tmcsdebug ) then frm_c.mm.Lines.Append(inttostr(world.Objects.Count-1)+';'+inttostr(world.Textures.Count-1));
  if ( ((num <= world.Objects.Count-1) and (assigned(world.objects[num]))) and (num2 <= world.Textures.Count-1) and (assigned(world.textures[num2])) ) then
    begin
      if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > assigning texture ...');
      model := world.Objects[num];
      model^.textured := true;
      if ( assigned(model^.submodels) ) then
        begin
          for j := 0 to model^.submodels.Count-1 do
            begin
              submodel := model^.submodels[j];
              if ( assigned(submodel) ) then
                begin
                  submodel^.textured := true;
                  { // per-face textúra helyett inkább csak per-submodel
                  for i := 0 to submodel^.faces.Count-1 do
                    begin
                      face := submodel^.faces[i];
                      texture := world.Textures[num2];
                      face^.tex := texture^.internalnum;
                    end;
                  }
                  if ( submodel^.faces.Count > 0 ) then
                    begin
                      face := submodel^.faces[0];
                      if ( assigned(face) ) then
                        begin
                          texture := world.Textures[num2];
                          face^.tex := texture^.internalnum;
                        end;
                    end;
                end;
            end;
        end;
    end;
except on exception do {showmessage('shit: '+inttostr(num)+'; '+inttostr(num2));} end;
end;

{ visszaadja adott textúra szélességét }
function tmcsGetTextureWidth(num: word): integer; stdcall;
begin
  if ( (num <= world.Textures.Count-1) and (assigned(world.textures[num])) ) then
    begin
      texture := world.Textures[num];
      result := texture^.width;
    end
   else result := -1;
end;

{ visszaadja adott textúra magasságát }
function tmcsGetTextureHeight(num: word): integer; stdcall;
begin
  if ( (num <= world.Textures.Count-1) and (assigned(world.textures[num])) ) then
    begin
      texture := world.Textures[num];
      result := texture^.height;
    end
   else result := -1;
end;

{ visszaadja adott textúra belsõ azonosítóját, amit OpenGL használ }
function tmcsGetTextureInternalnum(num: word): cardinal; stdcall;
begin
  if ( (num <= world.Textures.Count-1) and (assigned(world.textures[num])) ) then
    begin
      texture := world.Textures[num];
      result := texture^.internalnum;
    end;
end;

{ visszaadja adott objektum textúrájának számát }
function tmcsGetObjectTexture(num: word): integer; stdcall;
var
  foundtex: GLuint;
  i: integer;
  l: boolean;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      if ( model^.textured ) then
        begin
          submodel := model^.submodels[0];
          face := submodel^.faces[0];
          foundtex := face^.tex;
          i := -1;
          l := false;
          while ( not(l) and (i < world.Textures.Count-1) ) do
            begin
              i := i+1;
              texture := world.Textures[i];
              if ( assigned(texture) ) then
                l := ( texture^.internalnum = foundtex );
            end;
          if ( l ) then result := i
            else result := -1;
        end
       else result := -1;
    end
   else result := -1;
end;

{ visszaadja adott objektum alobjektumának textúrájának számát }
function tmcsGetSubObjectTexture(num1: word; num2: word): integer; stdcall;
var
  foundtex: GLuint;
  i: integer;
  l: boolean;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.Objects[num1];
      if ( model^.textured ) then
        begin
          if ( num2 <= model^.submodels.Count-1 ) then
            begin
              submodel := model^.submodels[num2];
              face := submodel^.faces[0];
              foundtex := face^.tex;
              i := -1;
              l := false;
              while ( not(l) and (i < world.Textures.Count-1) ) do
                begin
                  i := i+1;
                  texture := world.Textures[i];
                  l := ( texture^.internalnum = foundtex );
                end;
              if ( l ) then result := i
               else result := -1;
            end;
        end
       else result := -1;
    end
   else result := -1;
end;

{ num sorszámú objektum uv-értékeit szorozza factorw, factorh értékekkel }
procedure tmcsMultiplyUVCoords(num: word; factorw: single; factorh: single); stdcall;
var
  i,j: integer;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsMultiplyUVCoords('+inttostr(num)+', '+floattostr(factorw)+', '+floattostr(factorh)+')...');
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.textured := true;
      for j := 0 to model^.submodels.Count-1 do
        begin
          submodel := model^.submodels[j];
          for i := 0 to submodel^.vertices.Count-1 do
            begin
              vertex := submodel^.vertices[i];
              vertex^.u := vertex^.u * factorw;
              vertex^.v := vertex^.v * factorh;
            end;
        end;
    end;
end;

{ num sorszámú objektum uv-értékeit igazítja }
procedure tmcsAdjustUVCoords(num: word; factor: single); stdcall;
var
  i,j: integer;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      if ( model^.tessellated ) then
        begin
          for j := 0 to model^.submodels.Count-1 do
            begin
              submodel := model^.submodels[j];
              for i := 0 to submodel^.uvwcoords.Count-1 do
                begin
                  uvw := submodel^.uvwcoords[i];
                  if ( uvw^.u = 0.0 ) then uvw^.u := uvw^.u + factor
                    else if ( uvw^.u = 1.0 ) then uvw^.u := uvw^.u - factor;
                  if ( uvw^.v = 0.0 ) then uvw^.v := uvw^.v + factor
                    else if ( uvw^.v = 1.0 ) then uvw^.v := uvw^.v - factor;
               end;
            end;
        end
       else
        begin
          for j := 0 to model^.submodels.Count-1 do
            begin
              submodel := model^.submodels[j];
              for i := 0 to submodel^.vertices.Count-1 do
                begin
                  vertex := submodel^.vertices[i];
                  if ( vertex^.u = 0.0 ) then vertex^.u := vertex^.u + factor
                    else if ( vertex^.u = 1.0 ) then vertex^.u := vertex^.u - factor;
                  if ( vertex^.v = 0.0 ) then vertex^.v := vertex^.v + factor
                    else if ( vertex^.v = 1.0 ) then vertex^.v := vertex^.v - factor;
                end;
            end;
        end;
    end;
end;

{ adott objektum (amit createplane-nel hoztak létre) UV-koordinátáit megjelenítési szélességhez és magassághoz igazítja }
procedure tmcsAdjustPlaneCoordsToViewport(num: word); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      if ( not(model^.tessellated) and (model^.submodels.Count = 1) ) then
        begin
          submodel := model^.submodels[0];
          if ( submodel^.vertices.Count = 4 ) then
            begin  // idáig eljutva biztos, h belsõ készítésû plane-rõl van szó
              // glTexCoord2f(0.0, 0.0);  glVertex2f(0.0, 0);
              vertex := submodel^.vertices[0];
              vertex^.u := 0.0;
              vertex^.v := 0.0;
              vertex^.x := -world.Camera.targettex_w / 2;
              vertex^.y := -world.Camera.targettex_h / 2;
              // glTexCoord2f(1.0, 0.0);  glVertex2f(mblurtex.width, 0);
              vertex := submodel^.vertices[1];
              vertex^.u := world.Camera.targettex_w / texture^.width;
              vertex^.v := 0.0;
              vertex^.x := world.Camera.targettex_w / 2;
              vertex^.y := -world.Camera.targettex_h / 2;
              // glTexCoord2f(1.0, world.Camera.targettex_h/mblurtex.width);  glVertex2f(mblurtex.width, world.Camera.targettex_w);
              vertex := submodel^.vertices[2];
              vertex^.u := world.Camera.targettex_w / texture^.width;
              vertex^.v := world.Camera.targettex_h/texture^.width;
              vertex^.x := world.Camera.targettex_w / 2;
              vertex^.y := world.Camera.targettex_h / 2;
              // glTexCoord2f(0.0, world.Camera.targettex_h/mblurtex.width);  glVertex2f(0, world.Camera.targettex_w);
              vertex := submodel^.vertices[3];
              vertex^.u := 0.0;
              vertex^.v := world.Camera.targettex_h/texture^.width;
              vertex^.x := -world.Camera.targettex_w / 2;
              vertex^.y := world.Camera.targettex_h / 2;
            end;
        end;
    end;

end;

{ adott sorszámú textúrát törli }
procedure tmcsDeleteTexture(num: word); stdcall;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsDeleteTexture('+inttostr(num)+') ...');
  if ( (num <= world.Textures.Count-1) and (assigned(world.textures[num])) ) then
    begin
      texture := world.Textures[num];
      if ( assigned(texture) ) then
        begin
          glDeleteTextures(1,@texture^.internalnum);
          dispose(texture);
          world.Textures[num] := nil;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > done!');
        end;
    end;
end;

{ törli az összes textúrát }
procedure tmcsDeleteTextures(); stdcall;
var
  i: integer;
begin
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('tmcsDeleteTextures() ...');
  for i := 0 to world.Textures.Count-1 do
    tmcsDeleteTexture(i);
  world.Textures.Free;
  world.Textures := TList.Create;
  if ( tmcsdebug ) then frm_c.mm.Lines.Append('  > done, list capacity: '+inttostr(world.textures.Capacity)+', texcount: '+inttostr(world.textures.Count) );
end;

{
  ##############################################################################
  <--------------------------- OBJEKTUMOK KEZELÉSE ---------------------------->
  ##############################################################################
}

{
  <--------------------- VERTEX - MANIPULÁCIÓ ------------------------->
}

{ adott objektum vertexeinek számát adja vissza }
function tmcsGetTotalVertices(num: word): integer; stdcall;
var i: integer;
    sum: integer;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      sum := 0;
      model := world.Objects[num];
      for i := 0 to model^.submodels.Count-1 do
        begin
          submodel := model^.submodels[i];
          sum := sum + submodel^.vertices.Count;
        end;
      result := sum;
    end
   else result := -1;
end;

{ adott objektum adott számú alobjektumának adott vertexének x-pozícióját adja vissza }
function tmcsGetVertexX(num: word; num3: word; num2: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin                         
      model := world.Objects.Items[num];
      if ( num3 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num3];
          if ( num2 <= submodel^.vertices.Count-1 ) then
            begin
              vertex := submodel^.vertices[num2];
              result := vertex^.x;
            end;
        end;
    end;
end;

{ adott objektum adott számú alobjektumának adott vertexének y-pozícióját adja vissza }
function tmcsGetVertexY(num: word; num3: word; num2: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects.Items[num];
      if ( num3 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num3];
          if ( num2 <= submodel^.vertices.Count-1 ) then
            begin
              vertex := submodel^.vertices[num2];
              result := vertex^.y;
            end;
        end;
    end;
end;

{ adott objektum adott számú alobjektumának adott vertexének z-pozícióját adja vissza }
function tmcsGetVertexZ(num: word; num3: word; num2: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects.Items[num];
      if ( num3 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num3];
          if ( num2 <= submodel^.vertices.Count-1 ) then
            begin
              vertex := submodel^.vertices[num2];
              result := vertex^.x;
            end;
        end;
    end;
end;

{ adott objektum nagyításának mértékét adja vissza }
function tmcsGetScaling(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.scaling*100;
    end;
end;

{ adott objektum X-méretét adja vissza }
function tmcsGetSizeX(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.sizex;
    end
   else result := -1;
end;

{ adott objektum Y-méretét adja vissza }
function tmcsGetSizeY(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.sizey;
    end
   else result := -1;
end;

{ adott objektum Z-méretét adja vissza }
function tmcsGetSizeZ(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.sizez;
    end
   else result := -1;
end;

{ adott objektum pozícióját adja vissza az X-tengelyen }
function tmcsGetXPos(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.objects[num];
      result := model^.posx;
    end;
end;

{ adott objektum pozícióját adja vissza az Y-tengelyen }
function tmcsGetYPos(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.objects[num];
      result := model^.posy;
    end;
end;

{ adott objektum pozícióját adja vissza az Z-tengelyen }
function tmcsGetZPos(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.objects[num];
      result := model^.posz;
    end;
end;

{ adott objektum forgásszögét adja vissza az X-tengelyen }
function tmcsGetAngleX(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.anglex;
    end;
end;

{ adott objektum forgásszögét adja vissza az Y-tengelyen }
function tmcsGetAngleY(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.angley;
    end;
end;

{ adott objektum forgásszögét adja vissza az Z-tengelyen }
function tmcsGetAngleZ(num: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.anglez;
    end;
end;

{ adott objektumról megmondja, h látható-e (visible tulajdonság) }
function tmcsIsVisible(num: word): boolean; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.visible;
    end
   else result := false;
end;

{ adott objektum nevét adja vissza }
function tmcsGetName(num: word): TSTR40; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.name;
    end;
end;

{ adott objektum adott alobjektumának pozícióját adja vissza az X-tengelyen }
function tmcsGetSubXPos(num1, num2: word): single; stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          result := submodel^.posx;
        end;
    end;
end;

{ adott objektum adott alobjektumának pozícióját adja vissza az Y-tengelyen }
function tmcsGetSubYPos(num1, num2: word): single; stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          result := submodel^.posy;
        end;
    end;
end;

{ adott objektum adott alobjektumának pozícióját adja vissza az Z-tengelyen }
function tmcsGetSubZPos(num1, num2: word): single; stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          result := submodel^.posz;
        end;
    end;
end;

{ adott objektum adott alobjektumáról megmondja, h látható-e (visible tulajdonság) }
function tmcsSubIsVisible(num1, num2: word): boolean; stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.Objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          result := submodel^.visible;
        end
       else result := false;
    end
   else result := false; 
end;

{ adott objektum adott alobjektumának X-méretét adja vissza }
function tmcsGetSubSizeX(num1, num2: word): single; stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          result := submodel^.sizex;
        end
       else result := -1;
    end
   else result := -1;
end;

{ adott objektum adott alobjektumának Y-méretét adja vissza }
function tmcsGetSubSizeY(num1, num2: word): single; stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          result := submodel^.sizey;
        end
       else result := -1;
    end
   else result := -1;
end;

{ adott objektum adott alobjektumának Z-méretét adja vissza }
function tmcsGetSubSizeZ(num1, num2: word): single; stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          result := submodel^.sizez;
        end
       else result := -1;
    end
   else result := -1;
end;

{ visszaadja adott objektum adott alobjektumának nevét }
function tmcsGetSubName(num1, num2: word): TSTR40; stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          result := submodel^.name;
        end;
    end;
end;

{ adott objektum adott számú alobjektumának adott vertexének pozícióját beállítja }
procedure tmcsSetVertex(num: word; num3: word; num2: word; x,y,z: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      if ( not(model^.compiled) and (num3 <= model^.submodels.Count-1) ) then
        begin
          submodel := model^.submodels[num3];
          if ( num2 <= submodel^.vertices.Count-1 ) then
            begin
              vertex := submodel^.vertices[num2];
              vertex^.x := x;
              vertex^.y := y;
              vertex^.z := z;
           end;
        end;
    end;
end;

{ adott objektum méretét adott mértékkel változtatja }
procedure tmcsScaleObject(num: word; factor: single); stdcall;
var
  a: GLfloat;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      a := factor / 100;
      model := world.Objects[num];
      model^.scaling := model^.scaling*a;
    end;
end;

{ adott objektum méretét adott mértékre változtatja }
procedure tmcsScaleObjectAbsolute(num: word; factor: single); stdcall;
var
  a: GLfloat;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      a := factor / 100;
      model := world.Objects[num];
      model^.scaling := a;
    end;
end;

{ adott objektum pozícióját állítja be az X-tengelyen }
procedure tmcsSetXPos(num: word; factor: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.objects[num];
      model^.posx := factor;
    end;
end;

{ adott objektum pozícióját állítja be az Y-tengelyen }
procedure tmcsSetYPos(num: word; factor: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.objects[num];
      model^.posy := factor;
    end;
end;

{ adott objektum pozícióját állítja be az Z-tengelyen }
procedure tmcsSetZPos(num: word; factor: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.objects[num];
      model^.posz := factor;
    end;
end;

{ adott objektumot elforgatja az X-tengelyen adott szöggel }
procedure tmcsXRotateObject(num: word; factor: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.anglex := tmcswrapangle(model^.anglex+factor);
    end;
end;

{ adott objektumot elforgatja az Y-tengelyen adott szöggel }
procedure tmcsYRotateObject(num: word; factor: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.angley := tmcswrapangle(model^.angley+factor);
    end;
end;

{ adott objektumot elforgatja az Z-tengelyen adott szöggel }
procedure tmcsZRotateObject(num: word; factor: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.anglez := tmcswrapangle(model^.anglez+factor);
    end;
end;

{ adott objektum forgásszögét állítja be az X-tengelyen }
procedure tmcsSetAngleX(num: word; factor: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.anglex := tmcswrapangle(factor);
    end;
end;

{ adott objektum forgásszögét állítja be az Y-tengelyen }
procedure tmcsSetAngleY(num: word; factor: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.angley := tmcswrapangle(factor);
    end;
end;

{ adott objektum forgásszögét állítja be az Z-tengelyen }
procedure tmcsSetAngleZ(num: word; factor: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.anglez := tmcswrapangle(factor);
    end;
end;

{ adott objektum elforgatási sorrendjét állítja xzy-ra }
procedure tmcsSetObjectRotationXZY(num: word); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.rotationxzy := true;
    end;
end;

{ adott objektum elforgatási sorrendjét állítja yxz-ra }
procedure tmcsSetObjectRotationYXZ(num: word); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.rotationxzy := false;
    end;
end;

{ beállítja az adott objektum nevét }
procedure tmcsSetName(num: word; name: TSTR40); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.name := name;
    end;
end;

{ adott objektum színét állítja be }
procedure tmcsSetObjectColor(num: word; r,g,b: byte); stdcall;
var i,j,k: integer;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      if ( not(model^.compiled) ) then
        begin
          for k := 0 to model^.submodels.Count-1 do
            begin
              submodel := model^.submodels[k];
              for i := 0 to submodel^.faces.Count-1 do
                begin
                  face := submodel^.faces[i];
                  for j := 0 to 3 do
                    begin
                      vertex := submodel^.vertices[ face^.vertices[j] ];
                      vertex^.color.r := r;
                      vertex^.color.g := g;
                      vertex^.color.b := b;
                    end;
                end;
            end;
        end;
    end;
end;

function tmcsGetObjectColorKey(num: word): TRGBA; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      result := model^.colorkey;
    end;
end;

procedure tmcsSetObjectColorKey(num: word; r,g,b,a: byte); stdcall;
begin
  if ( ((num <= world.Objects.Count-1) and (assigned(world.objects[num]))) and assigned(world.Objects[num]) ) then
    begin
      model := world.Objects[num];
      model^.colorkey.r := r;
      model^.colorkey.g := g;
      model^.colorkey.b := b;
      model^.colorkey.a := a;
    end;
end;

{ adott objektum átlátszóságát állítja be }
procedure tmcsSetObjectAlpha(num: word; a: byte); stdcall;
var i,j,k: integer;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      if ( not(model^.compiled) ) then
        begin
          for k := 0 to model^.submodels.Count-1 do
            begin
              submodel := model^.submodels[k];
              for i := 0 to submodel^.faces.Count-1 do
                begin
                  face := submodel^.faces[i];
                  for j := 0 to 3 do
                    begin
                      if ( model^.tessellated ) then
                        vertex := submodel^.vertices[ face^.vertices[j]-1 ]
                       else vertex := submodel^.vertices[ face^.vertices[j] ];
                      vertex^.color.a := a;
                    end;
                end;
            end;
        end;
    end;
end;

{ adott objektum színkeverési módját állítja be }
procedure tmcsSetObjectBlendMode(num: word; sfactor,dfactor: TGLConst); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.blendmode.sfactor := sfactor;
      model^.blendmode.dfactor := dfactor;
    end;
end;

{ adott objektum színkeverési módját állítja be }
procedure tmcsSetObjectBlending(num: word; state: boolean); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.blended := state;
    end;
end;

{ adott objektum fényekre való érzékenységét állítja be }
procedure tmcsSetObjectLit(num: word; state: boolean); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      model^.affectedbylights := state;
    end;
end;

{ adott objektum adott alobjektumának pozícióját állítja be az X-tengelyen }
procedure tmcsSetSubXPos(num1, num2: word; factor: single); stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          submodel^.posx := factor;
        end;
    end;
end;

{ adott objektum adott alobjektumának pozícióját állítja be az Y-tengelyen }
procedure tmcsSetSubYPos(num1, num2: word; factor: single); stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          submodel^.posy := factor;
        end;
    end;
end;

{ adott objektum adott alobjektumának pozícióját állítja be az Z-tengelyen }
procedure tmcsSetSubZPos(num1, num2: word; factor: single); stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          submodel^.posz := factor;
        end;
    end;
end;

{ beállítja adott objektum adott alobjektumának nevét }
procedure tmcsSetSubName(num1, num2: word; name: TSTR40); stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.objects[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          submodel^.name := name;
        end;
    end;
end;

{ adott objektum adott alobjektumának láthatóságát igazra állítja }
procedure tmcsShowSubObject(num1, num2: word); stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.Objects.Items[num1];
      if ( num2 < model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          submodel^.visible := true;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('! '+inttostr(num1)+'. obj '+inttostr(num2)+' subobj visibility enabled.');
        end;
    end;
end;

{ adott objektumot adott alobjektumának láthatóságát hamisra állítja }
procedure tmcsHideSubObject(num1, num2: word); stdcall;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.Objects.Items[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          submodel^.visible := false;
          if ( tmcsdebug ) then frm_c.mm.Lines.Append('! '+inttostr(num1)+'. obj '+inttostr(num2)+' subobj visibility disabled.');
        end;
    end;
end;

{ adott objektum adott alobjektumának színét állítja be }
procedure tmcsSetSubobjectColor(num1, num2: word; r,g,b: byte); stdcall;
var i: integer;
begin
  if ( (num1 <= world.Objects.Count-1) and (assigned(world.objects[num1])) ) then
    begin
      model := world.Objects.Items[num1];
      if ( num2 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num2];
          for i := 0 to submodel^.vertices.Count-1 do
            begin
              vertex := submodel^.vertices[i];
              vertex^.color.r := r;
              vertex^.color.g := g;
              vertex^.color.b := b;
            end;
        end;
    end;
end;

{
  <--------------------- NORMÁL - MANIPULÁCIÓ ------------------------->
}

{ adott objektum adott számú alobjektum adott vertexének x-normálját adja vissza }
function tmcsGetNormalX(num: word; num3: word; num2: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.objects[num];
      if ( num3 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num3];
          if ( num2 <= submodel^.vertices.Count-1 ) then
            begin
              vertex := submodel^.vertices[num2];
              result := vertex^.nx;
            end;
        end;
    end;
end;

{ adott objektum adott számú alobjektum adott vertexének y-normálját adja vissza }
function tmcsGetNormalY(num: word; num3: word; num2: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.objects[num];
      if ( num3 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num3];
          if ( num2 <= submodel^.vertices.Count-1 ) then
            begin
              vertex := submodel^.vertices[num2];
              result := vertex^.ny;
            end;
        end;
    end;
end;

{ adott objektum adott számú alobjektum adott vertexének z-normálját adja vissza }
function tmcsGetNormalZ(num: word; num3: word; num2: word): single; stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.objects[num];
      if ( num3 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num3];
          if ( num2 <= submodel^.vertices.Count-1 ) then
            begin
              vertex := submodel^.vertices[num2];
              result := vertex^.nz;
           end;
        end;
    end;
end;

{ adott objektum adott számú alobjektum adott vertexének normájait beállítja }
procedure tmcsSetNormal(num: word; num3: word; num2: word; nx,ny,nz: single); stdcall;
begin
  if ( (num <= world.Objects.Count-1) and (assigned(world.objects[num])) ) then
    begin
      model := world.Objects[num];
      if ( num3 <= model^.submodels.Count-1 ) then
        begin
          submodel := model^.submodels[num3];
          if ( num2 <= submodel^.vertices.Count-1 ) then
            begin
              vertex := submodel^.vertices[num2];
              vertex^.nx := nx;
              vertex^.ny := ny;
              vertex^.nz := nz;
           end;
        end;
    end;
end;

{
  ##############################################################################
  <----------------------- SZÖVEGEK KIÍRÁSÁNAK KEZELÉSE ----------------------->
  ##############################################################################
}

{ adott elérési útról betölti name nevû font adatait name.bmp és name.dat alapján }
procedure tmcsLoadFontInfo(path,name: tstr255); stdcall;
var
  f: tfilestream;
  i,j: integer;
  k: integer;
  texnum: integer;
begin
  if ( length(name) > 0 ) then
    begin
      texnum := tmcsCreateTextureFromFile(path+name+'.bmp',false,false,false,GL_LINEAR,GL_MODULATE,GL_CLAMP,GL_CLAMP);
      fonttex := tmcsGetTextureInternalNum(texnum);
      f := tfilestream.Create(path+name+'.dat',fmOpenRead);
      f.Read(fontwidths,512);
      f.Free;
      k := -1;
      for i := 15 downto 0 do
        begin
          for j := 0 to 15 do
            begin
              k := k+1;
              fontdisplists[k] := glGenLists(1);
              glNewList(fontdisplists[k],GL_COMPILE);
                glBegin(GL_QUADS);
                  glTexCoord2f( (j*16)/255,     (i*16)/255   );  glVertex2f(0.0, 0.0);
                  glTexCoord2f( ((j+1)*16)/256, (i*16)/255   );  glVertex2f(FONT_PLANE_HEIGHT, 0.0);
                  glTexCoord2f( ((j+1)*16)/256, (i+1)*16/256 );  glVertex2f(FONT_PLANE_HEIGHT, FONT_PLANE_HEIGHT);
                  glTexCoord2f( (j*16)/255,     (i+1)*16/256 );  glVertex2f(0.0, FONT_PLANE_HEIGHT);
                glEnd();
              glEndList();
            end;
        end;
    end;
end;

{ adott szöveget adott pozícióra ír. fontheight = magasság, scaling = átméretezés százalékban }
procedure tmcsText(text: tstr255; x,y: word; fontheight: word; scaling: word); stdcall;
var
  pt: PText;
begin
  if ( length(text) > 0 ) then
    begin
      setlength(texts,length(texts)+1);
      new(pt);
      pt^.txt := text;
      pt^.x := x;
      pt^.y := y;
      pt^.scaling := scaling;
      pt^.height := fontheight;
      pt^.color := tmcstextcolor;
      texts[length(texts)-1] := pt;
    end;
end;

{ szöveg színét állítja }
procedure tmcsSetTextColor(r,g,b,a: byte); stdcall;
begin
  tmcstextcolor.r := r;
  tmcstextcolor.g := g;
  tmcstextcolor.b := b;
  tmcstextcolor.a := a;
end;

{ blendelve legyen-e a szöveg }
procedure tmcsSetTextBlendingState(state: boolean); stdcall;
begin
  tmcstextblendingstate := state;
end;

{ szöveg blendelési módját állítja }
procedure tmcsSetTextBlendMode(sfactor, dfactor: TGLConst); stdcall;
begin
  tmcstextblendmode.sfactor := sfactor;
  tmcstextblendmode.dfactor := dfactor;
end;

{ megbecsüli adott szöveg szélességét a képernyõn }
function tmcsGetTextWidth(text: tstr255; fontheight: word; scaling: word): integer; stdcall;
var
  i: integer;
  s: integer;
begin
  s := 0;
  for i := 1 to length(text) do
    begin
      s := s + round( (fontwidths[ ord(text[i]) ]*1.1) * (scaling/100) );
    end;
  result := length(text)*2+s;
end;


{
   ############################################################################
  ##############################################################################
  <--------###----###----###---###- EXPORTÁLÁS -###---###----###----###-------->
  ##############################################################################
   ############################################################################
}

exports
  tmcsInitialized,
  tmcsInitGraphix,
  tmcsEnableDebugging,
  tmcsDisableDebugging,
  tmcsSetGamma,
  tmcsRestoreOriginalDisplayMode,
  tmcsRestoreDisplayMode,
  tmcsShutdownGraphix,
  tmcsEnableMotionblur,
  tmcsDisableMotionblur,
  tmcsFreeMotionBlurResources,
  tmcsGetMotionBlurUpdateRate,
  tmcsSetMotionBlurUpdateRate,
  tmcsGetMotionBlurColor,
  tmcsSetMotionBlurColor,
  tmcsWrapAngle,
  tmcsGetCameraX,
  tmcsGetCameraY,
  tmcsGetCameraZ,
  tmcsGetCameraAngleX,
  tmcsGetCameraAngleY,
  tmcsGetCameraAngleZ,
  tmcsGetCameraAspect,
  tmcsGetCameraFov,
  tmcsGetCameraNearPlane,
  tmcsGetCameraFarPlane,
  tmcsSetCameraX,
  tmcsSetCameraY,
  tmcsSetCameraZ,
  tmcsSetCameraPos,
  tmcsSetCameraAngleX,
  tmcsSetCameraAngleY,
  tmcsSetCameraAngleZ,
  tmcsSetCameraAngle,
  tmcsXRotateCamera,
  tmcsYRotateCamera,
  tmcsZRotateCamera,
  tmcsSetCameraAspect,
  tmcsSetCameraFov,
  tmcsSetCameraNearPlane,
  tmcsSetCameraFarPlane,
  tmcsSetviewport,
  tmcsInitCamera,
  tmcsGetNewX,
  tmcsGetNewZ,
  tmcsRender,
  tmcsSetBgColor,
  tmcsGetTotalObjects,
  tmcsGetNumSubObjects,
  tmcsCreatePlane,
  tmcsCreateCube,
  tmcsCreateBox,
  tmcsSetExtObjectsTextureMode,
  tmcsCompileObject,
  tmcsCreateObjectFromFile,
  tmcsSetObjectMultiTextured,
  tmcsMultiTexAssignObject,
  tmcsDeleteObject,
  tmcsCreateClonedObject,
  tmcsSetObjectWireframe,
  tmcsSetWiredCulling,
  tmcsGetTotalVertices,
  tmcsGetVertexX,
  tmcsGetVertexY,
  tmcsGetVertexZ,
  tmcsSetVertex,
  tmcsGetNormalX,
  tmcsGetNormalY,
  tmcsGetNormalZ,
  tmcsSetNormal,
  tmcsGetSizeX,
  tmcsGetSizeY,
  tmcsGetSizeZ,
  tmcsGetXPos,
  tmcsGetYPos,
  tmcsGetZPos,
  tmcsGetAngleX,
  tmcsGetAngleY,
  tmcsGetAngleZ,
  tmcsGetScaling,
  tmcsIsVisible,
  tmcsGetName,
  tmcsScaleObject,
  tmcsScaleObjectAbsolute,
  tmcsSetXPos,
  tmcsSetYPos,
  tmcsSetZPos,
  tmcsSetObjectLit,
  tmcsSetSubXPos,
  tmcsSetSubYPos,
  tmcsSetSubZPos,
  tmcsXRotateObject,
  tmcsYRotateObject,
  tmcsZRotateObject,
  tmcsSetAngleX,
  tmcsSetAngleY,
  tmcsSetAngleZ,
  tmcsSetObjectRotationXZY,
  tmcsSetObjectRotationYXZ,
  tmcsSetName,
  tmcsSetObjectColor,
  tmcsGetObjectColorKey,
  tmcsSetObjectColorKey,
  tmcsSetObjectAlpha,
  tmcsSetObjectBlendMode,
  tmcsSetObjectBlending,
  tmcsSetObjectLit,
  tmcsGetSubXPos,
  tmcsGetSubYPos,
  tmcsGetSubZPos,
  tmcsGetSubSizeX,
  tmcsGetSubSizeY,
  tmcsGetSubSizeZ,
  tmcsGetSubName,
  tmcsSetSubName,
  tmcsSubIsVisible,
  tmcsShowObject,
  tmcsHideObject,
  tmcsShowSubObject,
  tmcsHideSubObject,
  tmcsSetObjectDoubleSided,
  tmcsSetObjectZBuffered,
  tmcsSetObjectStickedState,
  tmcsDeleteObject,
  tmcsDeleteObjects,
  tmcsEnableLights,
  tmcsDisableLights,
  tmcsEnableAmbientLight,
  tmcsDisableAmbientLight,
  tmcsSetAmbientLight,
  tmcsTextureIsLoaded,
  tmcsCreateTextureFromFile,
  tmcsCreateBlankTexture,
  tmcsFrameBufferToTexture,
  tmcsTextureObject,
  tmcsGetTextureWidth,
  tmcsGetTextureHeight,
  tmcsGetTextureInternalNum,
  tmcsGetObjectTexture,
  tmcsGetSubObjectTexture,
  tmcsMultiplyUVCoords,
  tmcsAdjustUVCoords,
  tmcsAdjustPlaneCoordsToViewport,
  tmcsDeleteTexture,
  tmcsDeleteTextures,
  tmcsLoadFontInfo,
  tmcsText,
  tmcsSetTextColor,
  tmcsSetTextBlendingState,
  tmcsSetTextBlendMode,
  tmcsGetTextWidth;
begin

end.
