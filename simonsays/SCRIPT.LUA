--Splashscreen by Wouter Wijsman.
splash = pge.texture.load("images/splash.png",PGE_RAM)
menu = pge.texture.load("images/menu.png",PGE_RAM)

easy = pge.texture.load("images/easy.png")
easygreen = pge.texture.load("images/easygreen.png")
normal = pge.texture.load("images/normal.png")
normalgreen = pge.texture.load("images/normalgreen.png",PGE_RAM)
hard = pge.texture.load("images/hard.png",PGE_RAM)
hardgreen = pge.texture.load("images/hardgreen.png",PGE_RAM)

default = pge.texture.load("images/default.png",PGE_RAM)
blue = pge.texture.load("images/blue.png",PGE_RAM)
yellow = pge.texture.load("images/yellow.png",PGE_RAM)
red = pge.texture.load("images/red.png",PGE_RAM)
green = pge.texture.load("images/green.png",PGE_RAM)
gover= pge.texture.load("images/gameover.png",PGE_RAM)


sound1 = pge.wav.load("sounds/1.wav")
sound2 = pge.wav.load("sounds/2.wav")
sound3 = pge.wav.load("sounds/3.wav")
sound4 = pge.wav.load("sounds/4.wav")

font = pge.font.load("DejaVuSansMono.ttf", 12, PGE_VRAM)

--set variables
white = pge.gfx.createcolor(255, 255, 255)
state = "splash"
simon = {}

math.randomseed(os.time())

savedata=pge.file.open("savedata",PGE_FILE_RDONLY)
if savedata then
  size = savedata:size()
  hs = tonumber(savedata:read(size))
else
  savedata=pge.file.open("savedata",PGE_FILE_CREATE+PGE_FILE_WRONLY)
  savedata:write('0')
  savedata:close()
  hs = 0
end

--menu function
function drawmenu(x,y,image)
  image:activate()
  image:draw(x,y, image:width(), image:height(),0,0,image:width(),image:height())
end

--game functions
function draw(x,y,image)
  pge.gfx.startdrawing()
  pge.gfx.clearscreen()
  image:activate()
  image:draw(x,y, image:width(), image:height(),0,0,image:width(),image:height())
end

function screenrefresh(drscore)
	if (drscore == 1) then
    font:activate()
    font:print(0,0,white,score)
	else
    font:activate()
    font:print(257,171,white,score)
	end
  pge.gfx.enddrawing()
  pge.gfx.swapbuffers()
end
	
function wait(seconds)
  t =0
  if mode == "easy" then
    while (t < seconds*50000) do
      t = t + 1
    end
  else
    while (t < seconds*33333) do
      t = t + 1
    end
  end
end

function gameover()
  draw(0,0,gover)
  screenrefresh(0)
  wait(10)
  state = "splash"
end

function game()
  if mode ~= "hard" then
    kount = 0
  else
    kount = score
  end
  repeat
    if (simon[kount] == nil) then
      simon[kount] = {y = math.random(4)}
    end
     wait(1.5)
     if (simon[kount].y == 1) then
       sound1:play()
       draw(0,0,red)
    end
    if (simon[kount].y == 2) then
      sound2:play()
     draw(0,0,yellow)
    end
     if (simon[kount].y == 3) then
       sound3:play()
       draw(0,0,blue)
    end
    if (simon[kount].y == 4) then
      sound4:play()
      draw(0,0,green)
    end
    screenrefresh(1)
    wait(1.5)
    draw(0,0,default)
    screenrefresh(1)
    kount = kount + 1
    pge.wav.stopall()
  until(kount >= number)
end

function user()
  repeat
    pge.controls.update()
    if pge.controls.pressed(PGE_CTRL_TRIANGLE) or pge.controls.pressed(PGE_CTRL_UP) then
      ipb = 1
    end
    if pge.controls.pressed(PGE_CTRL_CROSS) or pge.controls.pressed(PGE_CTRL_DOWN) then
      ipb = 2
    end
    if pge.controls.pressed(PGE_CTRL_SQUARE) or pge.controls.pressed(PGE_CTRL_LEFT) then
      ipb = 3
    end
    if pge.controls.pressed(PGE_CTRL_CIRCLE) or pge.controls.pressed(PGE_CTRL_RIGHT) then
      ipb = 4
    end
  until ipb~=0 or pge.running()==0
end

function complete()
  if ipb == 1 then
    sound1:play()
    draw(0,0,red)
  end
  if ipb == 2 then
    sound2:play()
    draw(0,0,yellow)
  end
  if ipb == 3 then
    sound3:play()
    draw(0,0,blue)
  end
  if ipb == 4 then
    sound4:play()
    draw(0,0,green)
  end
  screenrefresh(1)
  rel = 0
  while rel == 0 do
    pge.controls.update()
    if ipb == 1 then
      if pge.controls.released(PGE_CTRL_TRIANGLE) or pge.controls.released(PGE_CTRL_UP) then
        rel = 1
      end
    end
    if ipb ==2 then
      if pge.controls.released(PGE_CTRL_CROSS) or pge.controls.released(PGE_CTRL_DOWN) then
        rel = 1
      end
    end
    if ipb == 3 then
      if pge.controls.released(PGE_CTRL_SQUARE) or pge.controls.released(PGE_CTRL_LEFT) then
        rel = 1
      end
    end
    if ipb == 4 then
      if pge.controls.released(PGE_CTRL_CIRCLE) or pge.controls.released(PGE_CTRL_RIGHT) then
        rel = 1
      end
    end
  end
  draw(0,0,default)
  pge.wav.stopall()
  screenrefresh(1)
  if (simon[gount].y ~= ipb) then
    gameover()
  else
    gount = gount + 1
    ipb = 0
  end
end

function totaluser()
  repeat
    user()
    complete()
  until (gount >= number) or state~= "game" or pge.running()==0
end

--main loop
while pge.running() do
  if hs == nil then
    hs = 0
  end
  if score~=nil then
    for i=0,score+1 do
      simon[i] = nil
    end
    if hs < score then
      hs = score
      savedata = pge.file.open("savedata",PGE_FILE_WRONLY)
      savedata:write(hs..'  ')
      savedata:close()
    end
  end
  kount = 0
  number = 1
  score = 0

  while state == "splash" and pge.running() do
    pge.controls.update()
    pge.gfx.startdrawing()
    pge.gfx.clearscreen()
    splash:activate()
    splash:draw(0,0, 480, 272,0,0,480,272)
    font:activate()
    font:print(0,0,white,"highscore: "..hs)
    pge.gfx.enddrawing()
    pge.gfx.swapbuffers()
    if pge.controls.pressed(PGE_CTRL_CROSS) then
      state= "menu"
    end
  end

  ms = 2
  mms = 3

  while state == "menu" and pge.running() do
    pge.controls.update()
    pge.gfx.startdrawing()
    pge.gfx.clearscreen()
    drawmenu(0,0,menu)
    if ms == 1 then
      drawmenu(171,84,easygreen)
    else
      drawmenu(171,84,easy)
    end
    if ms == 2 then
      drawmenu(171,124,normalgreen)
    else
      drawmenu(171,124,normal)
    end

    if ms == 3 then
      drawmenu(171,164,hardgreen)
    else
      drawmenu(171,164,hard)
    end
    pge.gfx.enddrawing()
    pge.gfx.swapbuffers()

    if pge.controls.pressed(PGE_CTRL_UP) then
      ms = ms - 1
    end
    if pge.controls.pressed(PGE_CTRL_DOWN) then
      ms = ms + 1
    end
    if ms > mms then
      ms = mms
    elseif ms <= 0 then
      ms = 1
    end

    if pge.controls.pressed(PGE_CTRL_CROSS) then
      if ms == 1 then
        --Paste code that happens when X is pressed over option 1
        mode = "easy"
        state = "game"
      end
      if ms == 2 then
        --Paste code that happens when X is pressed over option 2
        mode = "normal"
        state = "game"
      end
      if ms == 3 then
        --Paste code that happens when X is pressed over option 3
        mode = "hard"
        state = "game"
      end
    end
  end

  while state == "game" and pge.running() do
    draw(0,0,default)
    screenrefresh(1)
    wait(1.5)
    game()
    gount = 0
    ipb = 0
    totaluser()
    if state == "game" then
      score = score + 1
      number = number + 1
    end
  end
end




