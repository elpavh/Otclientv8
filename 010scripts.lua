UI.Button("Agregar Macro", function(newText)
  UI.MultilineEditorWindow(storage.ingame_macros_main or "", {title="Agregar Macro", description="You can add your custom macros (or any other lua code) here"}, function(text)
    storage.ingame_macros_main = text
    reload()
  end)
end)

UI.Button("Agregar Hotkey", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys_main or "", {title="Agregar Hotkey", description="You can add your custom hotkeys/singlehotkeys here"}, function(text)
    storage.ingame_hotkeys_main = text
    reload()
  end)
end)

for _, scripts in ipairs({storage.ingame_macros_main, storage.ingame_hotkeys_main}) do
  if type(scripts) == "string" and scripts:len() > 3 then
    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)
    if not status then 
      error("Ingame editor error:\n" .. result)
    end
  end
end

UI.Separator()