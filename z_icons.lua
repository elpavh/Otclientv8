addIcon("Bot ON", {item=688, outfit={mount=0,feet=82,legs=82,body=82,type=128,auxType=0,addons=3,head=82}, hotkey=nil, text="Bot ON", x=0.97781885397412, y=0.96182266009852},
macro(80, "", function(macro)
  if activarCavebot then
    activarCavebot.setOn()
  end
  TargetBot.setOn()
  CaveBot.setOn()
  macro.setOff()
end))

addIcon("Bot OFF", {item=25486, outfit={mount=0,feet=94,legs=94,body=94,type=128,auxType=0,addons=3,head=94}, hotkey=nil, text="Bot OFF", x=0.92329020332717, y=0.96305418719212},
macro(80, "", function(macro)
  if activarCavebot then
    activarCavebot.setOff()
  end
  TargetBot.setOff()
  CaveBot.setOff()
  macro.setOff()
end))

addIcon("Dances", {outfit={mount=0,feet=79,legs=114,body=114,type=151,auxType=0,addons=3,head=114}, hotkey=nil, text="Dance"}, macro(1000, "", function()
  turn(0)
  schedule(120, function() turn(1) end)
  schedule(240, function() turn(2) end)
  schedule(360, function() turn(3) end)
end))

--addIcon("text", {text="text\nonly\nicon", switchable=true}, macro(100, "esp Itachi", function()
--     say('reino tsukuyomi')
--end))
--[[ 

addIcon("ctrl", {outfit={mount=0,feet=10,legs=10,body=176,type=129,auxType=0,addons=3,head=48}, text="press ctrl to move icon"}, function(widget, enabled)
  if enabled then
    info("icon on")  
  else
    info("icon off")   
  end
end)

addIcon("mount", {outfit={mount=848,feet=10,legs=10,body=176,type=129,auxType=0,addons=3,head=48}}, function(widget, enabled)
  if enabled then
    info("icon mount on")  
  else
    info("icon mount off")   
  end
end)

addIcon("mount 2", {outfit={mount=849,feet=10,legs=10,body=176,type=140,auxType=0,addons=3,head=48}, switchable=false}, function(widget, enabled)
  info("icon mount 2 pressed")  
end)

addIcon("item", {item=3380, hotkey="", switchable=false}, function(widget, enabled)
  info("icon clicked")
end)

addIcon("item2", {item={id=3043, count=100}, switchable=true}, function(widget, enabled)
  info("icon 2 clicked")
end)

addIcon("text", {text="text\nonly\nicon", switchable=true}, function(widget, enabled)
  info("icon with text clicked")
end)
 ]]
