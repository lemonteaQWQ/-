/*
  Simple models: wardrobe / computer monitor / curtain
  Run: 3dsmaxbatch.exe build.ms
  Output: wardrobe.max monitor.max curtain.max all.max + preview/*.png
*/
global outDir  = "C:/Users/lansile/.openclaw/workspace/max/"
global prevDir = outDir + "preview/"
global logPath = outDir + "build.log"

fn logMsg msg =
(
	local f = openFile logPath mode:"a"
	format "%\n" msg to:f
	close f
)

makeDir outDir
makeDir prevDir
try (deleteFile logPath) catch (0)
logMsg ("=== build start ===")

units.DisplayType = #Metric
units.MetricType   = #Centimeters

fn freshScene =
(
	resetMaxFile #noPrompt
	try (renderers.current = Default_Scanline_Renderer()) catch (0)
	logMsg ("renderer: " + ((classof renderers.current) as string))
	backgroundColor = color 206 216 228
	ambientLight    = color 18 18 20
	renderWidth  = 800
	renderHeight = 600
)

fn matDiffuse nm col gloss spec =
(
	local m = StandardMaterial name:nm diffuse:col glossiness:gloss specularLevel:spec
	m
)

fn addGround =
(
	local gm = matDiffuse "Ground" (color 178 178 175) 8 6
	local g  = Plane length:1600 width:1600 pos:[0,0,-0.6]
	g.name = "Ground"
	g.material = gm
	g
)

fn setupLights =
(
	local k = OmniLight pos:[-190,-260,300] rgb:(color 255 248 236) multiplier:0.85
	k.name = "KeyLight"
	k.castShadows = true

	local f = OmniLight pos:[260,-200,140] rgb:(color 226 236 255) multiplier:0.30
	f.name = "FillLight"

	local t = OmniLight pos:[0,120,340] rgb:(color 255 255 255) multiplier:0.22
	t.name = "TopLight"
	"lights ok"
)

fn makeCam p tgt fv =
(
	local tgtObj = TargetObject pos:tgt
	local c  = TargetCamera pos:p target:tgtObj fov:fv
	c.name = "SceneCam"
	c
)

fn shot cam filePath =
(
	try
	(
		render camera:cam outputfile:filePath vfb:off width:800 height:600
		logMsg ("rendered: " + filePath)
	)
	catch
	(
		logMsg ("RENDER FAIL: " + filePath + " :: " + (getCurrentException()))
	)
)

fn silhouetteRender cam outPath =
(
	try
	(
		backgroundColor = color 255 255 255
		ambientLight = color 0 0 0
		for l in (lights as array) do delete l
		local blk = StandardMaterial name:"Silhouette" diffuse:(color 0 0 0) ambient:(color 0 0 0)
		local g = getNodeByName "Ground"
		if g != undefined do delete g
		for o in (geometry as array) do o.material = blk
		render camera:cam outputfile:outPath vfb:off width:800 height:600
		logMsg ("silhouette: " + outPath)
	)
	catch (logMsg ("SIL FAIL " + getCurrentException()))
)

/* ------------------------------- wardrobe ------------------------------- */
fn mkWardrobe basePos =
(
	local bodyMat  = matDiffuse "CabinetBody" (color 190 166 132) 22 18
	local doorMat  = matDiffuse "CabinetDoor" (color 214 190 156) 32 26
	local metalMat = matDiffuse "HandleMetal" (color 62 64 68) 60 70

	local body = Box length:60 width:120 height:192 pos:(basePos + [0,0,8])
	body.name = "Wardrobe_Body"
	body.material = bodyMat

	local top = Box length:64 width:124 height:2 pos:(basePos + [0,0,200])
	top.name = "Wardrobe_Top"
	top.material = bodyMat

	local plinth = Box length:54 width:112 height:8 pos:(basePos + [0,0,0])
	plinth.name = "Wardrobe_Plinth"
	plinth.material = matDiffuse "Plinth" (color 120 104 84) 15 10

	local dl = Box length:2 width:58.5 height:184 pos:(basePos + [-29.75,-31,12])
	dl.name = "Wardrobe_DoorL"
	dl.material = doorMat

	local dr = Box length:2 width:58.5 height:184 pos:(basePos + [29.75,-31,12])
	dr.name = "Wardrobe_DoorR"
	dr.material = doorMat

	local seam = Box length:1.2 width:1 height:184 pos:(basePos + [0,-30.6,12])
	seam.name = "Wardrobe_Seam"
	seam.material = matDiffuse "Seam" (color 120 106 88) 10 8

	local h1 = Cylinder radius:0.9 height:24 pos:(basePos + [-4,-33,86]) sides:12
	h1.name = "HandleL"
	h1.material = metalMat

	local h2 = Cylinder radius:0.9 height:24 pos:(basePos + [4,-33,86]) sides:12
	h2.name = "HandleR"
	h2.material = metalMat

	local m1 = Box length:0.8 width:44 height:1 pos:(basePos + [-29.75,-32.2,90])
	m1.name = "MouldL"
	m1.material = matDiffuse "Moulding" (color 200 176 142) 25 15
	local m2 = Box length:0.8 width:44 height:1 pos:(basePos + [29.75,-32.2,90])
	m2.name = "MouldR"
	m2.material = m1.material

	"wardrobe ok"
)

/* -------------------------------- monitor ------------------------------- */
fn mkMonitor basePos =
(
	local plastic = matDiffuse "MonitorPlastic" (color 42 44 48) 35 30
	local screenM = matDiffuse "Screen" (color 58 96 148) 90 80
	local metal   = matDiffuse "StandMetal" (color 120 122 128) 55 60

	local base = Cylinder radius:13 height:1.8 pos:(basePos + [0,0,0]) sides:36
	base.name = "Monitor_Base"
	base.material = metal

	local neck = Box length:5 width:9 height:26 pos:(basePos + [0,0,1.8])
	neck.name = "Monitor_Neck"
	neck.material = plastic

	local bezel = Box length:4 width:62 height:37 pos:(basePos + [0,1.5,26])
	bezel.name = "Monitor_Bezel"
	bezel.material = plastic

	local scr = Plane length:32 width:57 pos:(basePos + [0,-0.62,44.5])
	convertTo scr Editable_Mesh
	rotate scr (eulerangles 90 0 0)
	scr.pos = (basePos + [0,-2.1,44.5])
	scr.name = "Monitor_Screen"
	scr.material = screenM

	local back = Box length:3 width:20 height:14 pos:(basePos + [0,4,34])
	back.name = "Monitor_Back"
	back.material = plastic

	"monitor ok"
)

/* -------------------------------- curtain ------------------------------- */
fn mkCurtainPanel w h zTop xPos amp =
(
	local k = 360.0/20.0   -- degrees: MAXScript sin() takes degrees
	local p = Plane length:h width:w lengthsegs:1 widthsegs:64 pos:[0,0,0]
	convertTo p Editable_Mesh
	for v = 1 to (getNumVerts p) do
	(
		local vp = getVert p v
		local dz = amp * sin(vp.x * k)
		local bdy = 0.6 * sin((vp.y + h/2.0) * 12.0)
		setVert p v [vp.x, vp.y, dz + bdy]
	)
	update p
	rotate p (eulerangles 90 0 0)
	p.pos = [xPos, 0, zTop - h/2.0]
	p.material = matDiffuse "CurtainFabric" (color 198 168 128) 18 14
	p.material.twoSided = true
	p
)

fn mkCurtain basePos =
(
	local white = matDiffuse "FrameWhite" (color 240 240 236) 25 20
	local glass = matDiffuse "Glass" (color 190 215 230) 90 90
	glass.opacity = 25

	local wall = Plane length:300 width:380 pos:(basePos + [0,32,150])
	convertTo wall Editable_Mesh
	rotate wall (eulerangles 90 0 0)
	wall.pos = (basePos + [0,32,150])
	wall.name = "Wall"
	wall.material = matDiffuse "WallPaint" (color 216 213 206) 6 4
	wall.material.twoSided = true

	local fo = 6.0
	local yw = 26.0
	local wTop = 232.0
	local wBot = 72.0
	local wHalf = 82.0

	local barTop = Box length:8 width:(wHalf*2) height:fo pos:(basePos + [0,yw,wTop-fo])
	barTop.name = "Window_Top"
	barTop.material = white

	local barBot = Box length:8 width:(wHalf*2) height:fo pos:(basePos + [0,yw,wBot])
	barBot.name = "Window_Bottom"
	barBot.material = white

	local barL = Box length:8 width:fo height:(wTop-wBot) pos:(basePos + [-wHalf+fo/2,yw,wBot])
	barL.name = "Window_Left"
	barL.material = white

	local barR = Box length:8 width:fo height:(wTop-wBot) pos:(basePos + [wHalf-fo/2,yw,wBot])
	barR.name = "Window_Right"
	barR.material = white

	local mid = Box length:8 width:2.4 height:(wTop-wBot) pos:(basePos + [0,yw,wBot])
	mid.name = "Window_Mullion"
	mid.material = white

	local glZ = wBot + fo + (wTop-wBot-fo*2)/2
	local gl = Plane length:(wTop-wBot-fo*2) width:(wHalf*2-fo*2) pos:(basePos + [0,29,glZ])
	convertTo gl Editable_Mesh
	rotate gl (eulerangles 90 0 0)
	gl.pos = (basePos + [0,29,glZ])
	gl.name = "Window_Glass"
	gl.material = glass
	gl.material.twoSided = true

	local rodZ = 246.0
	local rod = Cylinder radius:1.6 height:262 pos:(basePos + [-131,0,rodZ]) sides:20
	rotate rod (eulerangles 0 90 0)
	rod.name = "Curtain_Rod"
	rod.material = matDiffuse "RodWood" (color 122 92 64) 40 35

	local f1 = Sphere radius:3.2 pos:(basePos + [-132.5,0,rodZ]) segments:20
	f1.name = "Rod_FinialL"
	f1.material = rod.material
	local f2 = Sphere radius:3.2 pos:(basePos + [132.5,0,rodZ]) segments:20
	f2.name = "Rod_FinialR"
	f2.material = rod.material

	local p1 = mkCurtainPanel 96 228 (rodZ-4) -74 4.2
	p1.name = "Curtain_Left"
	local p2 = mkCurtainPanel 96 228 (rodZ-4) 74 4.2
	p2.name = "Curtain_Right"

	"curtain ok"
)

/* ------------------------------- scenes -------------------------------- */
fn sceneWardrobe =
(
	logMsg "scene: wardrobe"
	freshScene()
	local cam = makeCam [330,-420,160] [0,0,96] 32
	addGround()
	logMsg (mkWardrobe [0,0,0])
	logMsg (setupLights())
	shot cam (prevDir + "wardrobe.png")
	saveMaxFile (outDir + "wardrobe.max") quiet:true
	logMsg "saved wardrobe.max"
	silhouetteRender cam (prevDir + "sil_wardrobe.png")
)

fn sceneMonitor =
(
	logMsg "scene: monitor"
	freshScene()
	local cam = makeCam [92,-128,62] [0,0,40] 34
	addGround()
	logMsg (mkMonitor [0,0,0])
	logMsg (setupLights())
	shot cam (prevDir + "monitor.png")
	saveMaxFile (outDir + "monitor.max") quiet:true
	logMsg "saved monitor.max"
	silhouetteRender cam (prevDir + "sil_monitor.png")
)

fn sceneCurtain =
(
	logMsg "scene: curtain"
	freshScene()
	local cam = makeCam [300,-620,185] [0,0,145] 38
	addGround()
	logMsg (mkCurtain [0,0,0])
	logMsg (setupLights())
	shot cam (prevDir + "curtain.png")
	saveMaxFile (outDir + "curtain.max") quiet:true
	logMsg "saved curtain.max"
	silhouetteRender cam (prevDir + "sil_curtain.png")
)

fn sceneAll =
(
	logMsg "scene: all"
	freshScene()
	addGround()
	logMsg (setupLights())
	logMsg (mkWardrobe [-215,0,0])
	logMsg (mkMonitor [30,-10,0])
	logMsg (mkCurtain [265,0,0])
	local cam = makeCam [420,-780,300] [80,0,105] 40
	shot cam (prevDir + "all.png")
	saveMaxFile (outDir + "all.max") quiet:true
	logMsg "saved all.max"
	silhouetteRender cam (prevDir + "sil_all.png")
)

logMsg ("wardrobe: " + (try ((sceneWardrobe()) as string) catch ("ERR " + getCurrentException())))
logMsg ("monitor : " + (try ((sceneMonitor()) as string) catch ("ERR " + getCurrentException())))
logMsg ("curtain : " + (try ((sceneCurtain()) as string) catch ("ERR " + getCurrentException())))
logMsg ("all     : " + (try ((sceneAll()) as string) catch ("ERR " + getCurrentException())))

logMsg "=== build end ==="









