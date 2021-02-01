VOICEVIS = VOICEVIS or {}

local PANEL = {}

AccessorFunc( PANEL, "m_ply", "Ply")
AccessorFunc( PANEL, "m_col", "Color")
AccessorFunc( PANEL, "m_vis", "Vis")

function PANEL:Init()
	self.Vis = {}
	self.StartPos = VOICEVIS.Width
	self.CanGo = true
	self.Point4 = VOICEVIS.Height
end

function PANEL:Paint()
	if self.ShouldNotRender then return end
	if not self:GetPly() or not IsValid(self:GetPly()) or not self:GetPly():IsPlayer() then return end
	local ply = self:GetPly()
	self.col = Color(255,255,255)
	local voice_volume = self:GetVis() == 2 and 200*ply:VoiceVolume() or VOICEVIS.VisualizerSetting[self:GetVis()].MULTIPLIER*ply:VoiceVolume()
	
	if VOICEVIS.ColorMode == 2 then
		local l = Lerp(1-(12/voice_volume), 120, 0)
		local hsv = HSVToColor( l, 1, 1)
		self.col = Color(hsv.r or 0, hsv.g or 0, hsv.b or 0, VOICEVIS.DefaultOpacity or 100)
	elseif VOICEVIS.ColorMode == 3 then
		self.col = VOICEVIS:GetColorForPlayer(ply) or VOICEVIS.DefaultColor
	end
	
	if self:GetVis() == 1 then
		if self.CanGo then
			self.last_box = VOICEVIS.Box( self.StartPos, (VOICEVIS.Height+1)-voice_volume, VOICEVIS.VisualizerSetting[1].WIDTH, voice_volume, self.col or VOICEVIS.DefaultColor, self)
			table.insert(self.Vis, self.last_box)
			self.CanGo = false
		end
	elseif self:GetVis() == 2 then
		draw.RoundedBox( VOICEVIS.CornerRounding, 2, 45, VOICEVIS.Width-2, 2, Color(0,0,0,90))
		draw.RoundedBox( VOICEVIS.CornerRounding, 2, 45, math.min(voice_volume*5, VOICEVIS.Width-2), 2, self.col)
	elseif self:GetVis() == 3 then
		local sinewave = math.sin(2*RealTime()) * VOICEVIS.Height/2 + VOICEVIS.Height/2+1
		self.last_box = VOICEVIS.Box( self.StartPos, sinewave, VOICEVIS.VisualizerSetting[3].BOXSIZE, VOICEVIS.VisualizerSetting[3].BOXSIZE, self.col or VOICEVIS.DefaultColor, self)
		table.insert(self.Vis, self.last_box)
	elseif self:GetVis() == 4 or self:GetVis() == 6 then
		if self.CanGo then
			local x1, y1, x2, y2 = self.StartPos, self.Point4, self.StartPos+VOICEVIS.VisualizerSetting[4].WIDTH, VOICEVIS.Height-voice_volume
			VOICEVIS.vgui[#VOICEVIS.vgui+1] = vgui.Create("AUDIO_LINE", self)
			VOICEVIS.vgui[#VOICEVIS.vgui]:SetSize(VOICEVIS.Width, VOICEVIS.Height)
			VOICEVIS.vgui[#VOICEVIS.vgui]:SetColor(self.col)
			VOICEVIS.vgui[#VOICEVIS.vgui]:SetP({x1,y1,x2,y2})
			VOICEVIS.vgui[#VOICEVIS.vgui].vis = self:GetVis()
			self.last_box = #VOICEVIS.vgui
			table.insert(self.Vis, self.last_box)
			self.Point4 = y2
			self.CanGo = false
		end
	elseif self:GetVis() == 5 then
		for i = 0, VOICEVIS.VisualizerSetting[5].AMOUNT, 2 do
			surface.DrawCircle( 246, 50, math.Clamp(voice_volume, 0, i), Color(self.col.r,self.col.g,self.col.b,1) )
		end
	end
end

function PANEL:Think()
	if vgui.CursorVisible() then
		self.ShouldNotRender = true
	else
		self.ShouldNotRender = false
	end
	
	for _, elem in pairs(self.Vis)do
		if IsValid(VOICEVIS.vgui[elem]) then
			local x, y = VOICEVIS.vgui[elem]:GetPos()
			VOICEVIS.vgui[elem]:SetPos(x-1,y)
			local EndPos = 0
			if self:GetVis() == 4 or self:GetVis() == 6 then EndPos = -250 end
			if x < EndPos then
				VOICEVIS.vgui[elem]:Remove()
			end
		end
	end
	if IsValid(VOICEVIS.vgui[self.last_box]) then
		local x, y = VOICEVIS.vgui[self.last_box]:GetPos()
		local CanIGo = 0
		
		if self:GetVis() == 4 or self:GetVis() == 6 then 
			CanIGo = -(VOICEVIS.VisualizerSetting[self:GetVis()].WIDTH + (VOICEVIS.VisualizerSetting[self:GetVis()].SPACING))
		elseif self:GetVis() == 1 then 
			CanIGo = VOICEVIS.Width-(VOICEVIS.VisualizerSetting[self:GetVis()].WIDTH + VOICEVIS.VisualizerSetting[self:GetVis()].SPACING)
		end
		
		if x <= CanIGo then
			self.CanGo = true
		end
	end
end
vgui.Register("VoiceVisualizer", PANEL)

local white_tex = surface.GetTextureID("vgui/white")

function surface.DrawLineEx(x1,y1, x2,y2, w, col)
	w = w or 1
	col = col or VOICEVIS.DefaultColor
	local dx,dy = x1-x2, y1-y2
	local ang = math.atan2(dx, dy)
	local dst = math.sqrt((dx * dx) + (dy * dy))
	x1 = x1 - dx * 0.5
	y1 = y1 - dy * 0.5
	surface.SetTexture(white_tex)
	surface.SetDrawColor(col)
	surface.DrawTexturedRectRotated(x1, y1, w, dst, math.deg(ang))
end

local LINE = {}
AccessorFunc( LINE, "m_p", "P")
AccessorFunc( LINE, "m_col", "Color")
function LINE:Paint(w, h)
	local p = self:GetP()
	surface.DrawLineEx( p[1]-10, p[2], p[3]-10, p[4], 2, self:GetColor() or VOICEVIS.DefaultColor)
	surface.SetTexture(white_tex)
	surface.SetDrawColor(Color(self:GetColor().r, self:GetColor().g, self:GetColor().b, 20))
	if self.vis == 6 then
		surface.DrawPoly({
			{x = p[1]-10, y = 50, u = 0, v = 0},
			{x = p[1]-10, y = p[2], u = 0, v = 1},
			{x = p[3]-10, y = p[4], u = 1, v = 1},
			{x = p[3]-10, y = 50, u = 1, v = 0},
		})
	end
end
vgui.Register("AUDIO_LINE", LINE)