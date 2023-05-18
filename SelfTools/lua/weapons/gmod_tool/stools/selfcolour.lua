
TOOL.Category = "Render"
TOOL.Name = "Self Color"
if (CLIENT) then
	language.Add("tool.selfcolour.name", TOOL.Name) 
	language.Add("tool.selfcolour.desc", "Set color to yourself")
	language.Add("tool.selfcolour.left", "Set color to yourself.")
	language.Add("tool.selfcolour.reload", "Reset color.")
end

TOOL.ClientConVar[ "r" ] = 255
TOOL.ClientConVar[ "g" ] = 255
TOOL.ClientConVar[ "b" ] = 255
TOOL.ClientConVar[ "a" ] = 255
TOOL.ClientConVar[ "mode" ] = "0"
TOOL.ClientConVar[ "fx" ] = "0"

TOOL.Information = {
	{ name = "left" },
	{ name = "reload" }
}

local function SetColour( ply, ent, data )

	--
	-- If we're trying to make them transparent them make the render mode
	-- a transparent type. This used to fix in the engine - but made HL:S props invisible(!)
	--
	if ( data.Color && data.Color.a < 255 && data.RenderMode == RENDERMODE_NORMAL ) then
		data.RenderMode = RENDERMODE_TRANSCOLOR
	end

	if ( data.Color ) then ent:SetColor( Color( data.Color.r, data.Color.g, data.Color.b, data.Color.a ) ) end
	if ( data.RenderMode ) then ent:SetRenderMode( data.RenderMode ) end
	if ( data.RenderFX ) then ent:SetKeyValue( "renderfx", data.RenderFX ) end
	print(ent)
	print(dump(data))
	if ( SERVER ) then
		duplicator.StoreEntityModifier( ent, "colour", data )
	end

end
duplicator.RegisterEntityModifier( "colour", SetColour )

function TOOL:LeftClick( trace )

	-- local ent = trace.Entity
	local ent = self:GetOwner()
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end
	if ( !IsValid( ent ) ) then return false end -- The entity is valid and isn't worldspawn
	if ( CLIENT ) then return true end

	local r = self:GetClientNumber( "r", 0 )
	local g = self:GetClientNumber( "g", 0 )
	local b = self:GetClientNumber( "b", 0 )
	local a = self:GetClientNumber( "a", 0 )
	local fx = self:GetClientNumber( "fx", 0 )
	local mode = self:GetClientNumber( "mode", 0 )
	-- ent = self:GetOwner()
	SetColour( self:GetOwner(), ent, { Color = Color( r, g, b, a ), RenderMode = mode, RenderFX = fx } )
	return true

end

-- function TOOL:RightClick( trace )

-- 	print(self:GetOwner():GetColor())

-- 	return true

-- end

function TOOL:RightClick( trace )
	return false
end

function TOOL:Reload( trace )

	-- local ent = trace.Entity
	local ent = self:GetOwner()
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

	if ( !IsValid( ent ) ) then return false end -- The entity is valid and isn't worldspawn
	if ( CLIENT ) then return true end
	-- ent = self:GetOwner()
	SetColour( self:GetOwner(), ent, { Color = Color( 255, 255, 255, 255 ), RenderMode = 0, RenderFX = 0 } )
	return true

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.colour.desc" } )

	CPanel:ToolPresets( "selfcolour", ConVarsDefault )

	CPanel:ColorPicker( "#tool.colour.color", "selfcolour_r", "selfcolour_g", "selfcolour_b", "selfcolour_a" )

	CPanel:AddControl( "ListBox", { Label = "#tool.colour.mode", Options = list.Get( "RenderModes" ) } )
	CPanel:AddControl( "ListBox", { Label = "#tool.colour.fx", Options = list.Get( "RenderFX" ) } )

end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


list.Set( "RenderModes", "#rendermode.normal", { selfcolour_mode = 0 } )
list.Set( "RenderModes", "#rendermode.transcolor", { selfcolour_mode = 1 } )
list.Set( "RenderModes", "#rendermode.transtexture", { selfcolour_mode = 2 } )
list.Set( "RenderModes", "#rendermode.glow", { selfcolour_mode = 3 } )
list.Set( "RenderModes", "#rendermode.transalpha", { selfcolour_mode = 4 } )
list.Set( "RenderModes", "#rendermode.transadd", { selfcolour_mode = 5 } )
list.Set( "RenderModes", "#rendermode.transalphaadd", { selfcolour_mode = 8 } )
list.Set( "RenderModes", "#rendermode.worldglow", { selfcolour_mode = 9 } )

list.Set( "RenderFX", "#renderfx.none", { selfcolour_fx = 0 } )
list.Set( "RenderFX", "#renderfx.pulseslow", { selfcolour_fx = 1 } )
list.Set( "RenderFX", "#renderfx.pulsefast", { selfcolour_fx = 2 } )
list.Set( "RenderFX", "#renderfx.pulseslowwide", { selfcolour_fx = 3 } )
list.Set( "RenderFX", "#renderfx.pulsefastwide", { selfcolour_fx = 4 } )
list.Set( "RenderFX", "#renderfx.fadeslow", { selfcolour_fx = 5 } )
list.Set( "RenderFX", "#renderfx.fadefast", { selfcolour_fx = 6 } )
list.Set( "RenderFX", "#renderfx.solidslow", { selfcolour_fx = 7 } )
list.Set( "RenderFX", "#renderfx.solidfast", { selfcolour_fx = 8 } )
list.Set( "RenderFX", "#renderfx.strobeslow", { selfcolour_fx = 9 } )
list.Set( "RenderFX", "#renderfx.strobefast", { selfcolour_fx = 10 } )
list.Set( "RenderFX", "#renderfx.strobefaster", { selfcolour_fx = 11 } )
list.Set( "RenderFX", "#renderfx.flickerslow", { selfcolour_fx = 12 } )
list.Set( "RenderFX", "#renderfx.flickerfast", { selfcolour_fx = 13 } )
list.Set( "RenderFX", "#renderfx.distort", { selfcolour_fx = 15 } )
list.Set( "RenderFX", "#renderfx.hologram", { selfcolour_fx = 16 } )
list.Set( "RenderFX", "#renderfx.pulsefastwider", { selfcolour_fx = 24 } )
