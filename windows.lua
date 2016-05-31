--require "utils"

--------------------------------
-- Window management functions
--------------------------------
hs.window.animationDuration = 0

-- I use dual monitors
local leftScreen = "DELL U2410"
local rightScreen = "SyncMaster"

function nextMonitor()
	local win = hs.window.focusedWindow()
	if win then
		local screen = win:screen()
		local targetScreen = screen:name() == leftScreen and rightScreen or leftScreen 
		win:moveToScreen(targetScreen)
	end
end

function maxWindow()
	local win = hs.window.focusedWindow()
	if win then
		-- special case for Firefox because it doesn't necessarily 
		-- resize/repaint the content to max properly
		if win:application():name() == "Firefox" then
			leftHalfScreen()
		end

		local screen = win:screen()
		local max = screen:frame()
		win:setFrame(max)

		-- special case for VLC because sometimes the window gets cut off 
		-- at the bottom, only applies to left screen because
		-- no problem on right screen
		if win:application():name() == "VLC" and
				screen:name() == leftScreen then
			local f = win:frame()
			local bottom = f.y + f.h
			--hs.alert.show("bottom" .. bottom .. "screen max" .. max.h)
			if bottom > max.h then
				f.w = f.w - (bottom - max.h)
				win:setFrame(f)
			end
		end
	end
end

function nextMonMax()
	nextMonitor()
	maxWindow()
end

function leftHalfScreen()
	local win = hs.window.focusedWindow()
	if win then
		local f = win:frame()
		local screen = win:screen()
		local max = screen:frame()
	
		f.x = max.x
		f.y = max.y
		f.w = max.w / 2
		f.h = max.h
		win:setFrame(f)
	end
end

function rightHalfScreen()
	local win = hs.window.focusedWindow()
	if win then
		local f = win:frame()
		local screen = win:screen()
		local max = screen:frame()
	
		f.x = max.x + (max.w / 2)
		f.y = max.y
		f.w = max.w / 2
		f.h = max.h
				
		win:setFrame(f)
		
		-- special case for VLC because it doesn't necessarily 
		-- resize to half, only applies to left screen because
		-- doesn't work on right screen when total max.w is 2 screens
		if win:application():name() == "VLC" and
				screen:name() == leftScreen then
			f = win:frame()
			local rightEnd = f.x + f.w
			--hs.alert.show("right end" .. rightEnd .. "screen max" .. max.w)
			if rightEnd > max.w then
				f.x = f.x - (rightEnd - max.w)
				win:setFrame(f)
			end
		end
		
	end
end

-- for some reason the OS's show desktop doesn't work
-- for me so I make my own here
-- note: a little slow
function showDesktop()
	local windows = hs.window.visibleWindows()
	for i=1,#windows do
		windows[i]:minimize()
	end
end

-----------------------
-- keyboard shortcuts
-----------------------
hs.hotkey.bind({"alt"}, 'Z', nextMonitor)
hs.hotkey.bind({"alt"}, 'X', nextMonMax)
hs.hotkey.bind({"alt"}, 'W', leftHalfScreen)
hs.hotkey.bind({"alt"}, 'E', rightHalfScreen)
hs.hotkey.bind({"alt"}, 'A', maxWindow)
hs.hotkey.bind({"alt"}, 'D', showDesktop)

----------------
-- menubar icon
----------------
local nextMonMaxIcon = hs.menubar.new()
function nextMonMaxIconClicked(keyboardModifiers)
	--hs.alert.show(table.tostring(keyboardModifiers))
	nextMonitor()
	-- alt means don't change size
	if keyboardModifiers['ctrl'] then
		leftHalfScreen()
	elseif keyboardModifiers['cmd'] then
		rightHalfScreen()
	else
		-- default
		maxWindow()
	end
end

if nextMonMaxIcon then
	nextMonMaxIcon:setIcon("~/Documents/icons/switch monitor/switch_monitor_24x24.png")
	nextMonMaxIcon:setClickCallback(nextMonMaxIconClicked)
	nextMonMaxIcon:setTooltip("Moves current window to next monitor and maximized")
end
