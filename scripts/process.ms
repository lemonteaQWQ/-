/*
  Process stage renders for the wardrobe.
  Run: 3dsmaxbatch.exe process.ms
  Output: preview/process/wardrobe_01_block.png
          preview/process/wardrobe_02_detail.png
          preview/process/wardrobe_03_final.png
*/

global outDir = "C:/Users/lansile/.openclaw/workspace/max/preview/process/"
makeDir outDir

fn logMsg msg =
(
	local f = openFile (outDir + "process.log") mode:"a"
	format "%\n" msg to:f
	close f
)

try (deleteFile (outDir + "process.log")) catch (0)
logMsg "=== process render start ==="

units.DisplayType = #Metric
units.MetricType   = #Centimeters

fn matDiffuse nm col gloss spec =
(
	StandardMaterial name:nm diffuse:col glossiness:gloss specularLevel:spec
)

fn freshScene =
(
	resetMaxFile #noPrompt
	try (renderers.current = Default_Scanline_Renderer()) catch (0)
	backgroundColor = color 206 216 228
	ambientLight    = color 18 18 20
	renderWidth  = 800
	renderHeight = 600
	logMsg ("renderer: " + ((classof renderers.current) as string))
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
	local c = TargetCamera pos:p target:tgtObj fov:fv
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
	catch (logMsg ("RENDER FAIL: " + filePath + " :: " + (getCurrentException())))
)

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

fn clayAll =
(
	local clayM = StandardMaterial name:"Clay" diffuse:(color 186 182 176) glossiness:14 specularLevel:10
	for o in (geometry as array) where o.name != "Ground" do o.material = clayM
	"clay ok"
)

fn removeNodes names =
(
	for n in names do
	(
		try (delete (getNodeByName n)) catch (0)
	)
	"removed"
)

freshScene()
addGround()
setupLights()
logMsg (mkWardrobe [0,0,0])
SceneCam = makeCam [330,-420,160] [0,0,96] 32
logMsg ("camera: " + (SceneCam as string))

-- 03: final materials
shot SceneCam (outDir + "wardrobe_03_final.png")

-- 02: all details, clay material, handles removed
removeNodes #("HandleL", "HandleR")
logMsg (clayAll())
shot SceneCam (outDir + "wardrobe_02_detail.png")

-- 01: carcass only
removeNodes #("Wardrobe_DoorL", "Wardrobe_DoorR", "Wardrobe_Seam", "MouldL", "MouldR")
shot SceneCam (outDir + "wardrobe_01_block.png")

logMsg "=== process render end ==="
