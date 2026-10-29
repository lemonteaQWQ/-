/*
  Render repo models that have no preview yet: sofa / keyboard / mouse.
  Run: 3dsmaxbatch.exe render_repo.ms
  Output: max/preview/repo/*.png + sil_*.png
*/

global srcDir = "C:/Users/lansile/.openclaw/workspace/lemontea-repo/"
global outDir = "C:/Users/lansile/.openclaw/workspace/max/preview/repo/"
global logPath = outDir + "render_repo.log"
makeDir outDir
try (deleteFile logPath) catch (0)

fn logMsg msg =
(
	local fh = openFile logPath mode:"a"
	format "%\n" msg to:fh
	close fh
)

fn matDiffuse nm col gloss spec =
(
	StandardMaterial name:nm diffuse:col glossiness:gloss specularLevel:spec
)

fn worldBBox o =
(
	/* node.min / node.max are already world-space bounds.
	   Do NOT multiply by o.transform again, or the bbox doubles. */
	#(o.min, o.max)
)

fn sceneBBox =
(
	local gmin = [1e9,1e9,1e9]
	local gmax = [-1e9,-1e9,-1e9]
	for o in geometry do
	(
		try
		(
			local bb = worldBBox o
			local mn = bb[1]
			local mx = bb[2]
			if mn.x < gmin.x do gmin.x = mn.x
			if mn.y < gmin.y do gmin.y = mn.y
			if mn.z < gmin.z do gmin.z = mn.z
			if mx.x > gmax.x do gmax.x = mx.x
			if mx.y > gmax.y do gmax.y = mx.y
			if mx.z > gmax.z do gmax.z = mx.z
		)
		catch (0)
	)
	#(gmin, gmax)
)

fn centerOnGround =
(
	local bb = sceneBBox()
	local mn = bb[1]
	local mx = bb[2]
	local dx = -(mn.x + mx.x) / 2.0
	local dy = -(mn.y + mx.y) / 2.0
	local dz = -mn.z
	for o in geometry do o.pos = o.pos + [dx,dy,dz]
	"centered"
)

fn addGround =
(
	local gm = matDiffuse "Ground" (color 178 178 175) 8 6
	local g = Plane length:1600 width:1600 pos:[0,0,-0.15]
	g.name = "Ground"
	g.material = gm
	g
)

fn setupLights r =
(
	local k = OmniLight pos:[-1.2*r,-1.8*r,2.2*r] rgb:(color 255 248 236) multiplier:0.85
	k.name = "KeyLight"
	k.castShadows = true
	local f = OmniLight pos:[1.6*r,-1.0*r,1.1*r] rgb:(color 226 236 255) multiplier:0.30
	f.name = "FillLight"
	local t = OmniLight pos:[0,0.6*r,2.5*r] rgb:(color 255 255 255) multiplier:0.22
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

fn setupStudio distScale =
(
	local bb = sceneBBox()
	local mn = bb[1]
	local mx = bb[2]
	local sz = mx - mn
	local r = 0.5 * sqrt(sz.x*sz.x + sz.y*sz.y + sz.z*sz.z)
	if r < 1.0 do r = 1.0
	addGround()
	setupLights r
	local dist = r / (sin 16.0) * 1.15 * distScale
	local dir = normalize [0.85,-1.0,0.55]
	local tgtPos = [0,0,sz.z*0.45]
	local cam = makeCam (tgtPos + dir*dist) tgtPos 32
	logMsg ("frame size " + (sz as string) + " radius " + (r as string) + " dist " + (dist as string))
	cam
)

fn shot cam filePath =
(
	try
	(
		renderWidth = 800
		renderHeight = 600
		renderPixelAspect = 1.0
		render camera:cam outputfile:filePath vfb:off width:800 height:600
		logMsg ("rendered: " + filePath)
	)
	catch (logMsg ("RENDER FAIL: " + filePath + " :: " + (getCurrentException())))
)

fn silhouette cam filePath =
(
	try
	(
		backgroundColor = color 255 255 255
		ambientLight = color 0 0 0
		for l in (lights as array) do delete l
		local g = getNodeByName "Ground"
		if g != undefined do delete g
		local blk = StandardMaterial name:"Silhouette" diffuse:(color 0 0 0) ambient:(color 0 0 0)
		for o in (geometry as array) do o.material = blk
		renderWidth = 800
		renderHeight = 600
		renderPixelAspect = 1.0
		render camera:cam outputfile:filePath vfb:off width:800 height:600
		logMsg ("silhouette: " + filePath)
	)
	catch (logMsg ("SIL FAIL " + (getCurrentException())))
)

fn prepScene =
(
	resetMaxFile #noPrompt
	try (renderers.current = Default_Scanline_Renderer()) catch (0)
	backgroundColor = color 206 216 228
	ambientLight = color 18 18 20
	renderWidth = 800
	renderHeight = 600
	"fresh"
)

fn loadBySize sz =
(
	local files = getFiles (srcDir + "*.max")
	local found = undefined
	for f in files do
	(
		if (getFileSize f) == sz do found = f
	)
	if found == undefined then
	(
		logMsg ("FILE NOT FOUND size " + (sz as string))
		undefined
	)
	else
	(
		loadMaxFile found quiet:true
		try (renderers.current = Default_Scanline_Renderer()) catch (0)
		renderWidth = 800
		renderHeight = 600
		logMsg ("loaded size " + (sz as string) + " objects " + (objects.count as string) + " renderer " + ((classof renderers.current) as string))
		found
	)
)

/* ------------------------------- sofa ------------------------------- */
prepScene()
if (loadBySize 745472) != undefined then
(
	local baseM = matDiffuse "SofaBase" (color 104 92 80) 12 10
	local seatM = matDiffuse "SofaSeat" (color 196 184 168) 18 14
	local backM = matDiffuse "SofaBack" (color 176 162 146) 16 12
	local armM  = matDiffuse "SofaArm" (color 132 118 102) 14 10
	local rustM = matDiffuse "PillowRust" (color 154 98 74) 14 10
	local oliveM = matDiffuse "PillowOlive" (color 118 122 96) 14 10

	for o in geometry do
	(
		local n = o.name as string
		if n == "ChamferBox001" then o.material = baseM
		else if n == "ChamferBox002" or n == "ChamferBox003" or n == "ChamferBox004" then o.material = seatM
		else if n == "ChamferBox005" or n == "ChamferBox009" or n == "ChamferBox010" then o.material = backM
		else if n == "ChamferBox006" or n == "ChamferBox007" then o.material = armM
		else if n == "ChamferBox008" then o.material = rustM
		else if n == "ChamferBox011" or n == "ChamferBox012" then o.material = oliveM
		else o.material = seatM
	)
	centerOnGround()
	local cam = setupStudio 1.0
	shot cam (outDir + "sofa.png")
	silhouette cam (outDir + "sil_sofa.png")
)

/* ------------------------------ keyboard ------------------------------ */
prepScene()
if (loadBySize 950272) != undefined then
(
	local plane = getNodeByName "Plane001"
	if plane != undefined do delete plane
	local kbM = matDiffuse "KeyboardBody" (color 48 50 54) 55 45
	for o in geometry do o.material = kbM
	centerOnGround()
	local cam = setupStudio 1.0
	shot cam (outDir + "keyboard.png")
	silhouette cam (outDir + "sil_keyboard.png")
)

/* -------------------------------- mouse -------------------------------- */
prepScene()
if (loadBySize 741376) != undefined then
(
	local msM = matDiffuse "MouseShell" (color 206 203 196) 60 52
	for o in geometry do o.material = msM
	centerOnGround()
	local cam = setupStudio 0.85
	shot cam (outDir + "mouse.png")
	silhouette cam (outDir + "sil_mouse.png")
)

logMsg "=== render repo end ==="
