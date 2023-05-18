if SERVER then
    AddCSLuaFile("shared.lua")
    SWEP.HoldType = "knife"
end

if CLIENT then
    SWEP.PrintName = "Charged Power"
    SWEP.Author = "Davilarek"
    SWEP.Slot = 1
    SWEP.SlotPos = 9
    SWEP.IconLetter = "k"
end

-- function Popup()
-- 	local DermaPanel = vgui.Create( "DFrame" )	-- Create a panel to parent it to
-- 	DermaPanel:SetSize( 400, 200 )	-- Set the size
-- 	DermaPanel:Center()				-- Center it
-- 	DermaPanel:SetTitle( "Charged Power Damge Options" )
-- 	DermaPanel:ShowCloseButton(true)
-- 	DermaPanel:MakePopup()			-- Make it a popup
-- 	local DermaNumSlider = vgui.Create( "DNumSlider", DermaPanel )
-- 	DermaNumSlider:SetPos( 50, 50 )				-- Set the position
-- DermaNumSlider:SetSize( 300, 100 )			-- Set the size
-- DermaNumSlider:SetText( "Power" )	-- Set the text above the slider
-- DermaNumSlider:SetMin( 0 )				 	-- Set the minimum number you can slide to
-- DermaNumSlider:SetMax( 999999999 )				-- Set the maximum number you can slide to
-- DermaNumSlider:SetConVar( "ultrapower_setint" )	-- Changes the ConVar when you slide
-- -- If not using convars, you can use this hook + Panel.SetValue()
-- DermaNumSlider.OnValueChanged = function( self, value )
-- 	-- Called when the slider value changes
-- end
-- end
-- concommand.Add( "PanelPopup", Popup )
-- hook.Add("PopulateToolMenu", "ChargedPowerOptionsMenu", function()
-- 	spawnmenu.AddToolMenuOption("Options", "Charged Power Options", "cpower_options", "Options", "", "", function(panel)
-- 		panel:AddControl("Button", {
-- 			Label = "Edit",
-- 			Command = "PanelPopup"
-- 		})
-- 	end)
-- end)
-- end
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_power.mdl"
SWEP.UseHands = true
SWEP.Weight = 50
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.DrawCrosshair = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 74
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""

if not ConVarExists("ultrapower_setint") then
    CreateConVar("ultrapower_setint", '5', FCVAR_ARCHIVE)
end

--function NumSlider.OnValueChanged( panel, value )
--sliderdamage = NumSlider:GetValue()
--end   
function SWEP:Initialize()
    util.PrecacheModel("sprites/physbeam.spr")
    util.PrecacheSound("weapons/physcannon/physcannon_charge.wav")

    for i = 1, 4 do
        util.PrecacheSound("weapons/physcannon/superphys_launch" .. i .. ".wav")
    end

    for i = 1, 3 do
        util.PrecacheSound("ambient/energy/zap" .. i .. ".wav")
    end
end

function SWEP:OwnerChanged()
    self.Weapon:EmitSound("weapons/physcannon/physcannon_charge.wav")
end

function SWEP:ResetVars()
end

-- self.HackEnt = 0 
-- self.HeldEnt = 0
-- self.HeldEntMass = 0
-- self.Const = 0
function SWEP:Think()
end

-- if self.HeldEnt == 0 or self.HackEnt == 0 then return end
-- if (not self.HeldEnt:IsValid()) or (not self.HackEnt:IsValid()) then
-- 	self:ResetVars()
-- 	self.Secondary.Automatic = true
-- end
-- if SERVER then
-- 	self.HackEnt:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*75)
-- 	self.HackEnt:PointAtEntity(self.Owner)
-- end
-- if math.random(1,25) < 3 then
-- 	local e = EffectData()
-- 	e:SetEntity(self.HeldEnt)
-- 	e:SetMagnitude(30)
-- 	e:SetScale(30)
-- 	e:SetRadius(30)
-- 	util.Effect("TeslaHitBoxes", e)
-- 	self.HeldEnt:EmitSound("ambient/energy/zap"..math.random(1,3)..".wav")
-- end
function RemovePrimAttack(entity)
    timer.Simple(0.1, function()
        SafeRemoveEntity(entity)
    end)
end

function SWEP:PrimaryAttack()
    self.Weapon:EmitSound("weapons/physcannon/superphys_launch" .. math.random(1, 4) .. ".wav")
    local ownerOfTheSWEP = self:GetOwner()
    local trace = self:GetOwner():GetEyeTrace()

    if SERVER then
        -- if self.HeldEnt ~= 0 and self.HeldEnt:IsValid() then
        -- 	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
        -- 	return
        -- end
        local rnd = math.random(1, 99999)
        local TS = ents.Create("info_target")
        TS:SetPos((ownerOfTheSWEP:GetRight() * 100) + (ownerOfTheSWEP:GetShootPos() + ((ownerOfTheSWEP:GetAimVector() * 50) + Vector(0, 0, -100))))
        TS:SetName("TS" .. rnd)
        local TE = ents.Create("info_target")
        TE:SetPos(trace.HitPos)
        TE:SetName("TE" .. rnd)
        local TB = ents.Create("env_beam")
        TB:SetKeyValue("texture", "sprites/physcannon_bluelight1b.vtf")
        TB:SetKeyValue("renderamt", 255)
        TB:SetKeyValue("rendercolor", "255 255 255")
        TB:SetKeyValue("life", 1)
        --TB:SetKeyValue("damage", 0)
        TB:SetKeyValue("LightningStart", "TS" .. rnd)
        TB:SetKeyValue("LightningEnd", "TE" .. rnd)
        TB:SetKeyValue("spawnflags", 1)
        TB:SetKeyValue("TouchType", 0)
        TB:SetKeyValue("framestart", 0)
        TB:SetKeyValue("framerate", 0)
        TB:SetKeyValue("NoiseAmplitude", 5)
        TB:SetKeyValue("TextureScroll", 35)
        TB:SetKeyValue("BoltWidth", 1)
        TB:SetKeyValue("Radius", 256)
        TB:SetKeyValue("StrikeTime", 1)
        local TB2 = ents.Create("env_beam")
        TB2:SetKeyValue("texture", "sprites/physcannon_bluelight1b.vtf")
        TB2:SetKeyValue("renderamt", 255)
        TB2:SetKeyValue("rendercolor", "255 255 255")
        TB2:SetKeyValue("life", 1)
        TB2:SetKeyValue("damage", 0)
        TB2:SetKeyValue("LightningStart", "TS" .. rnd)
        TB2:SetKeyValue("LightningEnd", "TE" .. rnd)
        TB2:SetKeyValue("spawnflags", 1)
        TB2:SetKeyValue("TouchType", 0)
        TB2:SetKeyValue("framestart", 0)
        TB2:SetKeyValue("framerate", 0)
        TB2:SetKeyValue("NoiseAmplitude", 3)
        TB2:SetKeyValue("TextureScroll", 35)
        TB2:SetKeyValue("BoltWidth", 8)
        TB2:SetKeyValue("Radius", 256)
        TB2:SetKeyValue("StrikeTime", 1)
        -- TB:Fire("kill","",0.1)
        -- TB2:Fire("kill", "", 0.1)
        -- TE:Fire("kill", "", 0.1)
        -- TS:Fire("kill", "", 0.1)
        TS:Spawn()
        TE:Spawn()
        TB:Spawn()
        TB2:Spawn()
        TB:Fire("turnon")
        TB2:Fire("turnon")
        RemovePrimAttack(TS)
        RemovePrimAttack(TE)
        RemovePrimAttack(TB)
        RemovePrimAttack(TB2)
        -- SafeRemoveEntityDelayed(TS, 0.1)
        -- SafeRemoveEntityDelayed(TE, 0.1)
        -- SafeRemoveEntityDelayed(TB, 0.1)
        -- SafeRemoveEntityDelayed(TB2	, 0.1)
        -- SafeRemoveEntity(TS)
        -- SafeRemoveEntity(TE)
        -- SafeRemoveEntity(TB)
        -- SafeRemoveEntity(TB2)
        -- print("ez1")
        -- 	TB:Spawn()
        -- 	TB2:Spawn()
        -- 	TE:Spawn()
        -- 	TS:Spawn()
        -- timer.Create( "DelayDelete"..rnd, 0.1, 1, function()
        -- 	print("ez2")
        -- 	--TB:Remove()
        -- 	--TB2:Remove()
        -- 	--TE:Remove()
        -- 	--TS:Remove()
        -- 	TB:Fire("kill")
        -- 	TB2:Fire("kill")
        -- 	TE:Fire("kill")
        -- 	TS:Fire("kill")
        -- end)
        local e = EffectData()
        e:SetMagnitude(30)
        e:SetScale(30)
        e:SetRadius(30)
        e:SetOrigin(trace.HitPos)
        e:SetNormal(trace.HitNormal)
        util.Effect("ManhackSparks", e)

        if trace.Entity and trace.Entity:IsValid() then
            local e = EffectData()
            local sliderdamage = GetConVar("ultrapower_setint")
            e:SetEntity(trace.Entity)
            e:SetMagnitude(30)
            e:SetScale(30)
            e:SetRadius(30)
            util.Effect("TeslaHitBoxes", e)
            trace.Entity:EmitSound("ambient/energy/zap" .. math.random(1, 3) .. ".wav")
            trace.Entity:TakeDamage(sliderdamage:GetInt(), ownerOfTheSWEP)
            local bullet = {}
            bullet.Num = 1
            bullet.Src = ownerOfTheSWEP:GetShootPos()
            bullet.Dir = ownerOfTheSWEP:GetAimVector()
            bullet.Spread = 0
            bullet.Tracer = 0
            bullet.Force = sliderdamage:GetInt()
            bullet.Damage = sliderdamage:GetInt()
            bullet.AmmoType = "pistol"
            ownerOfTheSWEP:FireBullets(bullet)
        end
    end
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end

-- function SWEP:DropHeld()
-- 	if SERVER then
-- 		if not self.Pulling then
-- 			self.Const:Remove()
-- 			self.HackEnt:Remove()
-- 		end
-- 		self.HeldEnt:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
-- 		local phys = self.HeldEnt:GetPhysicsObject()
-- 		phys:EnableCollisions(true)
-- 		phys:EnableGravity(true)
-- 		phys:EnableDrag(true)
-- 		phys:EnableMotion(true)
-- 		phys:Wake()
-- 		phys:SetMass(self.HeldEntMass)
-- 		--[[if self.HeldEnt:GetClass() == "prop_ragdoll" then
-- 			phys:ApplyForceCenter(self.Owner:GetAimVector()*10)
-- 		end]]
-- 	end
-- 	self.HeldEnt:EmitSound("ambient/energy/zap"..math.random(1,3)..".wav")
-- 	local e = EffectData()
-- 	e:SetEntity(self.HeldEnt)
-- 	e:SetMagnitude(30)
-- 	e:SetScale(30)
-- 	e:SetRadius(30)
-- 	util.Effect("TeslaHitBoxes", e)
-- 	self:ResetVars()
-- end
-- function SWEP:ForceLaunch()
-- 	if SERVER then
-- 		if not self.Pulling then
-- 			self.Const:Remove()
-- 			self.HackEnt:Remove()
-- 		end
-- 		self.HeldEnt:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
-- 		local phys = self.HeldEnt:GetPhysicsObject()
-- 		phys:EnableCollisions(true)
-- 		phys:EnableGravity(true)
-- 		phys:EnableDrag(true)
-- 		phys:EnableMotion(true)
-- 		phys:SetMass(self.HeldEntMass)
-- 		phys:ApplyForceCenter(self.Owner:GetAimVector()*(999*999))
-- 		local rnd = math.random(1,99999)
-- 		local TS = ents.Create("info_target")
-- 		TS:SetPos((self.Owner:GetRight()*100)+(self.Owner:GetShootPos()+((self.Owner:GetAimVector()*50)+Vector(0,0,-100))))
-- 		TS:SetName("TS"..rnd)
-- 		local TE = ents.Create("info_target" )
-- 		TE:SetPos(self.HeldEnt:GetPos())
-- 		TE:SetName("TE"..rnd)
-- 		local TB = ents.Create("env_beam")
-- 		TB:SetKeyValue("texture", "sprites/physcannon_bluelight1b.vtf")
-- 		TB:SetKeyValue("renderamt", 255)
-- 		TB:SetKeyValue("rendercolor", "255 255 255")
-- 		TB:SetKeyValue("life", 0.1)
-- 		TB:SetKeyValue("damage", 0)
-- 		TB:SetKeyValue("LightningStart", "TS"..rnd)
-- 		TB:SetKeyValue("LightningEnd", "TE"..rnd)
-- 		TB:SetKeyValue("spawnflags", 1)
-- 		TB:SetKeyValue("TouchType", 0)
-- 		TB:SetKeyValue("framestart", 0)
-- 		TB:SetKeyValue("framerate", 0)
-- 		TB:SetKeyValue("NoiseAmplitude", 5)
-- 		TB:SetKeyValue("TextureScroll", 35)
-- 		TB:SetKeyValue("BoltWidth", 1)
-- 		TB:SetKeyValue("Radius", 256)
-- 		TB:SetKeyValue("StrikeTime", 1)
-- 		local TB2 = ents.Create("env_beam")
-- 		TB2:SetKeyValue("texture", "sprites/physcannon_bluelight1b.vtf")
-- 		TB2:SetKeyValue("renderamt", 255)
-- 		TB2:SetKeyValue("rendercolor", "255 255 255")
-- 		TB2:SetKeyValue("life", 0.1)
-- 		TB2:SetKeyValue("damage", 0)
-- 		TB2:SetKeyValue("LightningStart", "TS"..rnd)
-- 		TB2:SetKeyValue("LightningEnd", "TE"..rnd)
-- 		TB2:SetKeyValue("spawnflags", 1)
-- 		TB2:SetKeyValue("TouchType", 0)
-- 		TB2:SetKeyValue("framestart", 0)
-- 		TB2:SetKeyValue("framerate", 0)
-- 		TB2:SetKeyValue("NoiseAmplitude", 3)
-- 		TB2:SetKeyValue("TextureScroll", 35)
-- 		TB2:SetKeyValue("BoltWidth", 8)
-- 		TB2:SetKeyValue("Radius", 256)
-- 		TB2:SetKeyValue("StrikeTime", 1)
-- 		TS:Spawn()
-- 		TE:Spawn()
-- 		TB:Spawn()
-- 		TB2:Spawn()
-- 		TB:Fire("turnon","","")
-- 		TB2:Fire("turnon","","")
-- 		TB:Fire("kill","",0.1)
-- 		TB2:Fire("kill", "", 0.1)
-- 		TE:Fire("kill", "", 0.1)
-- 		TS:Fire("kill", "", 0.1)
-- 		local bullet = {} --much more effective then applyforce center for ragdolls
-- 		bullet.Num 	= 1
-- 		bullet.Src 	= self.Owner:GetShootPos()			
-- 		bullet.Dir 	= self.Owner:GetAimVector()			
-- 		bullet.Spread 	= 0	
-- 		bullet.Tracer	= 0					 
-- 		bullet.Force	= 9999999999
-- 		bullet.Damage	= 9999999999
-- 		bullet.AmmoType = "pistol"
-- 		self.Owner:FireBullets(bullet)
-- 	end
-- 	local e = EffectData()
-- 	e:SetEntity(self.HeldEnt)
-- 	e:SetMagnitude(30)
-- 	e:SetScale(30)
-- 	e:SetRadius(30)
-- 	util.Effect("TeslaHitBoxes", e)
-- 	self.HeldEnt:EmitSound("ambient/energy/zap"..math.random(1,3)..".wav")
-- 	for k,v in pairs(ents.FindInSphere(self.HeldEnt:GetPos(), 25)) do
-- 		if (v == self.Owner) then return end
-- 		local e = EffectData()
-- 		e:SetEntity(v)
-- 		e:SetMagnitude(30)
-- 		e:SetScale(30)
-- 		e:SetRadius(30)
-- 		util.Effect("TeslaHitBoxes", e)
-- 	end
-- 	self.Weapon:EmitSound("weapons/physcannon/superphys_launch"..math.random(1,4)..".wav")
-- 	self:ResetVars()
-- end
function SWEP:Deploy()
    self.Weapon:EmitSound("weapons/physcannon/physcannon_charge.wav")
end
-- function SGravZap(ent, x)
-- 	if not ent:IsValid() then return end
-- 	self.Weapon:EmitSound("ambient/energy/zap"..math.random(1,3)..".wav")
-- 	local e = EffectData()
-- 	e:SetMagnitude(30)
-- 	e:SetScale(30)
-- 	e:SetRadius(30)
-- 	util.Effect("TeslaHitBoxes", e)
-- 	x = x+1
-- 	if (x <= math.random(3,7)) then
-- 		timer.Simple(math.random()*math.random(1,2), SGravZap, ent, x)
-- 	end
-- end