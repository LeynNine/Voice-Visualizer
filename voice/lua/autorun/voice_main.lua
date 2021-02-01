if SERVER then return end

VOICEVIS = VOICEVIS or {}

VOICEVIS.vgui = {}
surface.CreateFont( "Voice_Player_Name", {font = VOICEVIS.PlayerNameFont.FONT, size = VOICEVIS.PlayerNameFont.SIZE, weight = VOICEVIS.PlayerNameFont.THICKNESS} )
surface.CreateFont( "Voice_Player_Tag", {font = VOICEVIS.PlayerTagFont.FONT, size = VOICEVIS.PlayerTagFont.SIZE, weight = VOICEVIS.PlayerTagFont.THICKNESS} )
surface.CreateFont( "Voice_Player_TopRight", {font = VOICEVIS.PlayerTopRightFont.FONT, size = VOICEVIS.PlayerTopRightFont.SIZE, weight = VOICEVIS.PlayerTopRightFont.THICKNESS} )

function VOICEVIS.Box( x, y, w, h, c, p)
	VOICEVIS.vgui[#VOICEVIS.vgui+1] = VGUIRect( x, y, w, h )
	VOICEVIS.vgui[#VOICEVIS.vgui]:SetColor(c)
	VOICEVIS.vgui[#VOICEVIS.vgui]:SetParent(p)
	return #VOICEVIS.vgui
end

function VOICEVIS.Text( x, y, w, h, tt, f, c, p)
	VOICEVIS.vgui[#VOICEVIS.vgui+1] = vgui.Create( "DLabel", p)
	VOICEVIS.vgui[#VOICEVIS.vgui]:SetPos( x, y )
	VOICEVIS.vgui[#VOICEVIS.vgui]:SetSize( w, h )
	VOICEVIS.vgui[#VOICEVIS.vgui]:SetText(tt)
	VOICEVIS.vgui[#VOICEVIS.vgui]:SetFont(f)
	VOICEVIS.vgui[#VOICEVIS.vgui]:SetColor(c)
	return #VOICEVIS.vgui
end


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

function surface.GetSizesEz( t, f )
	surface.SetFont(f)
	return surface.GetTextSize(t)
end


local PANEL = {}
local PlayerVoicePanels = {}

function PANEL:Init()
	self.Visualizer = vgui.Create("VoiceVisualizer", self)
	self.Visualizer:SetSize( VOICEVIS.Width, VOICEVIS.Height )
	self.Visualizer:SetVis( VOICEVIS.Visualizer )
	
	
	self.PlayerName = VOICEVIS.Text( 44, VOICEVIS.Height/2-16, 0, 0, "", "Voice_Player_Name", VOICEVIS.PlayerNameFont.COLOR, self)
	self.PlayerTag = VOICEVIS.Text( 44, VOICEVIS.Height/2-3, 0, 0, "", "Voice_Player_Tag", VOICEVIS.PlayerTagFont.COLOR, self)
	self.PlayerTopRight = VOICEVIS.Text( 44, 0, 0, 0, "", "Voice_Player_TopRight", VOICEVIS.PlayerTopRightFont.COLOR, self)
	
	if VOICEVIS.FriendAvatarBorder and VOICEVIS.Gamemode == 0 then
		self.AvatarFriend = VOICEVIS.Box( 6, VOICEVIS.Height/2-17, 34, 34, VOICEVIS.NotFriendColor, self)
	end
	
	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:SetSize( 32, 32 )
	self.Avatar:SetPos( 7, VOICEVIS.Height/2-16)

	self.Color = color_transparent

	self:SetSize( VOICEVIS.Width, VOICEVIS.Height )
	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( BOTTOM )
end

function PANEL:Setup( ply )
	self.ply = ply
	self.TopRightTxt = ""
	
	self.Visualizer:SetPly(ply)
	
	-- Name stuff
	local w, h = surface.GetSizesEz( ply:Nick() or "", "Voice_Player_Name" )
	VOICEVIS.vgui[self.PlayerName]:SetSize( w, h)
	VOICEVIS.vgui[self.PlayerName]:SetAutoStretchVertical(true)
	VOICEVIS.vgui[self.PlayerName]:SetText( ply:Nick() )
	
	-- Tag stuff
	local w, h = surface.GetSizesEz( VOICEVIS:GetTagForPlayers(ply) or "", "Voice_Player_Tag" )
	VOICEVIS.vgui[self.PlayerTag]:SetSize( w, h)
	VOICEVIS.vgui[self.PlayerTag]:SetAutoStretchVertical(true)
	VOICEVIS.vgui[self.PlayerTag]:SetText( VOICEVIS:GetTagForPlayers(ply) or "" )
	
	-- Top right stuff
	if VOICEVIS.TopRightTextSetting == 1 then
		self.TopRightTxt = ply:SteamID()
	elseif VOICEVIS.TopRightTextSetting == 2 then
		self.TopRightTxt = "$"..string.Comma(ply:PS_GetPoints())
	elseif VOICEVIS.TopRightTextSetting == 3 then
		self.TopRightTxt = VOICEVIS:GetTagForPlayers(ply) or ""
	elseif VOICEVIS.TopRightTextSetting == 4 then
		self.TopRightTxt = team.GetName(ply:Team()) or ""
	end
	local w, h = surface.GetSizesEz( self.TopRightTxt, "Voice_Player_TopRight" )
	VOICEVIS.vgui[self.PlayerTopRight]:SetSize( w, h )
	VOICEVIS.vgui[self.PlayerTopRight]:SetPos( VOICEVIS.Width-w-8, -1 )
	VOICEVIS.vgui[self.PlayerTopRight]:SetAutoStretchVertical(true)
	VOICEVIS.vgui[self.PlayerTopRight]:SetText( self.TopRightTxt )
	
	if VOICEVIS.FriendAvatarBorder and VOICEVIS.Gamemode == 0 then
		if ply:GetFriendStatus() == "friend" then
			VOICEVIS.vgui[self.AvatarFriend]:SetColor(VOICEVIS.FriendColor)
		end
	end
	
	self.Avatar:SetPlayer( ply )
	self.Color = team.GetColor( ply:Team() )
	self:InvalidateLayout()
end

function PANEL:VoicePaint( w, h )
	if ( !IsValid( self.ply ) ) then return end
	self.BoxBorderCol = VOICEVIS.BorderColor
	self.BoxPanelCol = VOICEVIS.PanelColor
	
	if VOICEVIS.Gamemode == 2 then
		self.BoxBorderCol = team.GetColor(self.ply:Team())
		self.BoxPanelCol = Color(0,0,0,180)
	elseif VOICEVIS.Gamemode == 1 then
		self.BoxBorderCol = self.Color
		self.BoxPanelCol = Color(0,0,0,180)
	end
	
	draw.RoundedBox( VOICEVIS.CornerRounding, 0, 0, w, h, self.BoxBorderCol)
	draw.RoundedBox( VOICEVIS.CornerRounding, 1, 1, w-2, h-2, self.BoxPanelCol)
end

function PANEL:Think()
	self.Paint = self.VoicePaint
	if ( self.fadeAnim ) then
		self.fadeAnim:Run()
	end
end

function PANEL:FadeOut( anim, delta, data )
	if ( anim.Finished ) then
		if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end
	return end		
	self:SetAlpha( 255 - (255 * delta) )
end
derma.DefineControl( "VoiceNotify", "", PANEL, "DPanel" )



local function VoiceClean()
	for k, v in pairs( PlayerVoicePanels ) do
		if ( !IsValid( k ) ) then
			VOICEVIS:PlayerEndVoice( k )
		end
	end
end
timer.Create( "VoiceClean", 10, 0, VoiceClean )

function VOICEVIS:PlayerEndVoice( ply )	
	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then
		if ( PlayerVoicePanels[ ply ].fadeAnim ) then return end
		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 2 )
	end
end

hook.Add("Think", "ConstantlyOverrideSize", function()
	if !IsValid(g_VoicePanelList) then return end
	g_VoicePanelList:SetSize( 250, ScrH() - 200 )
end)

function CreateVoiceVGUI()
	g_VoicePanelList = vgui.Create( "DPanel" )
	g_VoicePanelList:ParentToHUD()
	g_VoicePanelList:SetPos( ScrW()-300, VOICEVIS.YCord )
	g_VoicePanelList:SetSize( VOICEVIS.Width, ScrH() - 200 )
	g_VoicePanelList:SetDrawBackground( false )
end
hook.Add( "InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI )