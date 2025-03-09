-- limeos uninstaller

local kernel = loadlib("Kernel")
function restart_os()
  kernel.MemAlloc("a")
end


