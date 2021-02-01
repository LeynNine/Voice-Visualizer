VOICEVIS = VOICEVIS or {}
VOICEVIS.VisualizerSetting = {}

-- What gamemode are you playing? 
-- This will enable darkrp job colors, and ttt voice colors
-- 0 = misc gamemode
-- 1 = TTT
-- 2 = DarkRP/Any team based gamemode (Voicebox will be that players team color)
VOICEVIS.Gamemode = 2

-- Your visualizer's mode.
-- 1 = Bar graph
-- 2 = Loading bar thing
-- 3 = The wave
-- 4 = Line graph
-- 5 = Circles
-- 6 = Cooler line graph
VOICEVIS.Visualizer = 6

-- 1 = Default color for all
-- 2 = Color depending on volume ( fade from green to red ) 
-- 3 = Color depending on rank (in color for player function below)
VOICEVIS.ColorMode = 2

-- The border color of the visualizer box
VOICEVIS.BorderColor = Color(40,40,40)

-- The foreground color of the visualizer
VOICEVIS.PanelColor = Color(25,25,25)

-- The default color of the visualizer when it finds no color
VOICEVIS.DefaultColor = Color(50,50,50,100)

-- The direct opacity of the visualizer
VOICEVIS.DefaultOpacity = 100

-- Increase to have more rounded corners on the box (keep it an even number)
VOICEVIS.CornerRounding = 0

-- How wide should the visualizer be?
VOICEVIS.Width = 250

-- How tall should the visualizer be?
VOICEVIS.Height = 50

-- Use this option if you want the voice boxes to start higher
-- Make this lower or in the negatives to make the first box start lower.
-- 100 is default
VOICEVIS.YCord = 100

-- Here you can edit the player name font settings
VOICEVIS.PlayerNameFont = {
	FONT = "Cordia New",
	SIZE = 22,
	THICKNESS = 1,
	COLOR = Color(160,160,160,120)
}

-- Settings for Player Tag Font
VOICEVIS.PlayerTagFont = {
	FONT = "Cordia New",
	SIZE = 19,
	THICKNESS = 1,
	COLOR = Color(160,160,160,60)
}

-- Settings for top right font
VOICEVIS.PlayerTopRightFont = {
	FONT = "Cordia New",
	SIZE = 16,
	THICKNESS = 1,
	COLOR = Color(160,160,160,10)
}

-- The Top right text setting.
-- 1 = Player SteamID
-- 2 = Player Pointshop points
-- 3 = Player Tag
-- 4 = DarkRP job / Team name
VOICEVIS.TopRightTextSetting = 4

-- Should there be a border around a player's avatar showing if they're a friend?
VOICEVIS.FriendAvatarBorder = true

-- The color of the border around a non friend
VOICEVIS.NotFriendColor = Color(129,196,214)

-- The color of the border around a friend
VOICEVIS.FriendColor = Color(129,214,171)

-- Here you can customize what players get what tags.
-- Keep in mind ULX uses ply:IsUserGroup("rank name") and Evolve uses ply:EV_GetRank() == "rank name"
function VOICEVIS:GetTagForPlayers(ply)
	if ply:SteamID() == "STEAM_0:0:68825805" then -- You should leave me in here for the sake of credit :3 <3
		return "Ilya"
	
	elseif ply:IsSuperAdmin() then -- SuperAdmins get SuperAdmin tag.
		return "SuperAdmin"
		
	elseif ply:IsAdmin() then -- Admins will get Admin tag.
		return "Admin"
		
	end
end

-- Here you can customize what players get what colors for their visualizers
-- Keep in mind ULX uses ply:IsUserGroup("rank name") and Evolve uses ply:EV_GetRank() == "rank name"
function VOICEVIS:GetColorForPlayer(ply)
	if ply:SteamID() == "STEAM_0:0:68825805" then -- You should leave my steam ID here. :3
		return HSVToColor( math.abs(math.sin(0.3*RealTime())*128), 1, 1 ) -- Color fade
		
	elseif ply:IsAdmin() then -- Admins will get a light white color.
		return Color(255,255,255,60)
		
	end
end

-- Visualizer settings for visualizer #1
VOICEVIS.VisualizerSetting[1] = {
	WIDTH = 2, -- Width of each bar
	SPACING = 1, -- Space between each bar
	MULTIPLIER = 200 -- Multiplier to your voice
}

-- Visualizer settings for visualizer #3
VOICEVIS.VisualizerSetting[3] = {
	WIDTH = 1,
	SPACING = 0, -- Space between each box
	MULTIPLIER = 200, -- Multiplier for player voice
	BOXSIZE = 1 -- Size of the boxes
}

-- Visualizer settings for visualizer #4
VOICEVIS.VisualizerSetting[4] = {
	WIDTH = 5, -- Width of each line segment
	SPACING = -1, -- Space between each line segment
	MULTIPLIER = 100 -- Multiplier for player voice
}

-- Visualizer settings for visualizer #5
VOICEVIS.VisualizerSetting[5] = {
	AMOUNT = 60, -- Amount of circles
	MULTIPLIER = 200 -- Multiplier for player voice
}

-- Visualizer settings for visualizer #6
VOICEVIS.VisualizerSetting[6] = {
	WIDTH = 5, -- Width of each line segment
	SPACING = -1, -- Space between each line segment
	MULTIPLIER = 100 -- Multiplier for player voice
}