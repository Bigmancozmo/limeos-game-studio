local window = Lime.CreateWindow(
	"launching..."
)



loadlib("ApplicationHandler").ExitProcess(window.Parent.Value.Value)
