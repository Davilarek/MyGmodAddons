if SERVER then
    AddCSLuaFile("shared.lua")
    SWEP.HoldType = "knife"
end

if CLIENT then
    SWEP.PrintName = "RTNPC: Class print tool"
    SWEP.Author = "Davilarek"
    SWEP.Slot = 2
    SWEP.SlotPos = 10
    SWEP.IconLetter = "l"
end

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_powerl.mdl"
-- SWEP.WorldModel			= "models/weapons/w_powerl.mdl"
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
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.HeldEnt = 0
SWEP.HeldEntMass = 0
SWEP.HackEnt = 0
SWEP.Const = 0

function SWEP:PrimaryAttack()
    if SERVER then
        local trace = self:GetOwner():GetEyeTrace()

        if SERVER then
            if trace.Entity and trace.Entity:IsValid() then
                local ply = self:GetOwner()
                ply:SendLua("print( \"-- [RagdollToNpc - Class Print Tool] --\" )")
                ply:SendLua("print(\"Class of entity you are looking at is: " .. trace.Entity:GetClass() .. "\")")
                ply:SendLua("notification.AddLegacy( \"Check out the console!\", NOTIFY_GENERIC, 5 )")
                ply:SendLua("print( \"-- [RagdollToNpc - Class Print Tool] --\" )")
            end
        end
    end
end

function SWEP:SecondaryAttack()
    if SERVER then
        local trace = self.Owner:GetEyeTrace()

        if SERVER then
            if trace.Entity and trace.Entity:IsValid() then
                local ply = self.Owner

                if trace.Entity:GetClass() == "prop_ragdoll" then
                    ply:SendLua("notification.AddLegacy( \"Cannot set resurect_ragdoll_class_override to " .. trace.Entity:GetClass() .. ".\", NOTIFY_ERROR, 5 )")

                    return
                end

                ply:ConCommand("resurect_ragdoll_class_override " .. trace.Entity:GetClass())
                ply:SendLua("notification.AddLegacy( \"Your resurect_ragdoll_class_override has been overwritten by " .. trace.Entity:GetClass() .. ".\", NOTIFY_GENERIC, 5 )")
            end
        end
    end
end

function SWEP:Reload()
	local ownerOfTheSwep = self:GetOwner()
    if ownerOfTheSwep:GetInfo("resurect_ragdoll_class_override") ~= "npc_citizen" then
        ownerOfTheSwep:ConCommand("resurect_ragdoll_class_override npc_citizen")
        ownerOfTheSwep:SendLua("notification.AddLegacy( \"Your resurect_ragdoll_class_override has been reverted to default.\", NOTIFY_ERROR, 5 )")
    end
end