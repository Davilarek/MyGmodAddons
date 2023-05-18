if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType			= "knife"
end

if (CLIENT) then
	SWEP.PrintName			= "Ragdoll To NPC"			
	SWEP.Author			= "Davilarek"
	SWEP.Slot			= 2
	SWEP.SlotPos			= 10
	SWEP.IconLetter			= "l"
end
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModel			= "models/weapons/v_powerl.mdl"
-- SWEP.WorldModel			= "models/weapons/w_powerl.mdl"

SWEP.UseHands           = true
SWEP.Weight			= 50
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true
SWEP.DrawCrosshair		= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV 		= 74
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= ""
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		= ""
SWEP.HeldEnt				= 0
SWEP.HeldEntMass			= 0
SWEP.HackEnt				= 0
SWEP.Const					= 0
if CLIENT then
	CreateClientConVar("resurect_ragdoll_rl", "4", false, true, "")
	CreateClientConVar("resurect_ragdoll_class_override", "npc_citizen", false, true, "")
	-- cvars.AddChangeCallback("resurect_ragdoll_class_override", function(convar_name, value_old, value_new)
	-- 	print("Class override: " .. value_new)
	-- end)
end

local function CopyGenericData( ply, A, B )
	local data = duplicator.CopyEntTable( A )
			-- data.Skin = nil
			-- data.FlexScale = nil 
			-- data.Flex = nil
			-- data.BoneManip = nil
			-- data.Model = A:GetModel()
			-- data.Class = nil
			-- data.LastCollide = nil
			-- data.PhysicsObjects = nil
			data._DuplicatedColor = nil

	-- B.EntityMods = data.EntityMods

	-- print(dump(data))

	duplicator.DoGeneric( B, data )
	-- duplicator.ApplyEntityModifiers( ply, B )
end

-- function dump(o)
-- 	if type(o) == 'table' then
-- 	   local s = '{ '
-- 	   for k,v in pairs(o) do
-- 		  if type(k) ~= 'number' then k = '"'..k..'"' end
-- 		  s = s .. '['..k..'] = ' .. dump(v) .. ','
-- 	   end
-- 	   return s .. '} '
-- 	else
-- 	   return tostring(o)
-- 	end
--  end

function SWEP:PrimaryAttack()
	if SERVER then
		local trace = self.Owner:GetEyeTrace()
		if (SERVER) then
			if trace.Entity and trace.Entity:IsValid() and trace.Entity:GetClass() == "prop_ragdoll" then		
				local ply = self.Owner
				ply:SendLua("print( \"-- [RagdollToNpc] --\" )")
				--local relatt2 = 	
				
				
				--local ragdollModel = 
				--local ragdollClass = trace.Entity:GetClass()
				--local ragdollAngle = 
				--local ragdollPos = 
				--local ragdollBodyGroups = trace.Entity:GetBodyGroups()
				
				local NPCCreated = ents.Create( ply:GetInfo( "resurect_ragdoll_class_override" ) )
				--NPCCreated:SetBodyGroups(ragdollBodyGroups)
				
				NPCCreated:SetKeyValue( "citizentype", 4 )
				-- NPCCreated:SetModel( tostring(trace.Entity:GetModel()) )
				-- NPCCreated:SetPos( trace.Entity:GetPos() )
				-- NPCCreated:SetAngles( trace.Entity:GetAngles() )
				CopyGenericData( ply, trace.Entity, NPCCreated )
				NPCCreated:SetHealth( NPCCreated:GetMaxHealth() )
				trace.Entity:Remove()
				NPCCreated:Spawn()
				ply:SendLua("print(\"Summoned NPC with class " .. NPCCreated:GetClass() .. " with relationship with you " .. tostring(ply:GetInfoNum("resurect_ragdoll_rl", 4)) .. "\")")
				--local relatt = 
				--local RemovedRagdollEnt = ents.Create( "prop_ragdoll" )

				--RemovedRagdollEnt:SetKeyValue( "citizentype", 4 )
				--RemovedRagdollEnt:SetModel( tostring(ragdollModel) )
				--RemovedRagdollEnt:SetPos( ragdollPos )
				--RemovedRagdollEnt:SetAngles( ragdollAngle )

				NPCCreated:AddEntityRelationship( ply, ply:GetInfoNum("resurect_ragdoll_rl", 4), 99 )
				ply:SendLua("print( \"-- [RagdollToNpc] --\" )")
			end
		end
	end
end


function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end