--require "utils"
--------------------------------
-- Screen management functions
--------------------------------
-- switches the resolution of my main Dell monitor between HiDPI and regular
function changeDellResolution()
	scn =  hs.screen.find('DELL U2410')
	--hs.alert.show(table.tostring(scn:availableModes()))
	if scn:currentMode()['desc']=="960x600@2x" then
		scn:setMode(1920, 1200, 1)
	else
		scn:setMode(960, 600, 2)
	end
end

-----------------------
-- keyboard shortcuts
-----------------------
hs.hotkey.bind({"alt"}, 'R', changeDellResolution)
