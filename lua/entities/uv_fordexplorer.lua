AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Ford Police Interceptor Utility 2011 Police Cruiser"
ENT.Author = "Sergeant Armstrong"

ENT.GlideCategory = "unitvehiclesglide"
ENT.ChassisModel = "models/unitvehiclescars/uv_fordexplorer/uv_fordexplorer.mdl"
ENT.CanSwitchSiren = true
ENT.UVVehicleModel = "policecar"

DEFINE_BASECLASS( "base_glide_car" )

ENT.NitrousPower = 2.5
ENT.NitrousDepletionRate = 0.55
ENT.NitrousRegenRate = 0.1
ENT.NitrousRegenDelay = 0.6

if CLIENT then

    ENT.CameraOffset = Vector( -250, 0, 75 )
	ENT.CameraCenterOffset = Vector( 0, 0, 0 )

    ENT.SirenVolume = 1

    ENT.SirenLoopSound = ")uvcars/federal sig omega 90/emv_wail.wav"
    ENT.SirenLoopAltSound = ")uvcars/federal sig omega 90/emv_yelp.wav"
    ENT.HornSound = ")uvcars/federal sig omega 90/emv_horn.wav"

    ENT.ExhaustOffsets = {
        {
            pos = Vector(-104.82,24.22,6.18)
        },
        {
            pos = Vector(-104.82,-24.22,6.18)
        },
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector(109.91,0,9.79), angle = Angle(0,0,0), width = 40 },
    }

    ENT.EngineFireOffsets = {
        { offset = Vector(84.69,0,35.64), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector(104,30.14,29.56),
            color = Color(160,205,255)
        },
        {
            offset = Vector(104,-30.14,29.56),
            color = Color(160,205,255)
        },
    }


    ENT.LightSprites = {

        { type = "brake", offset = Vector(-96.72,0,62.43), size = 50, color = Color(255,0,0,255), dir = Vector( -1, 0, 0 ) },
        { type = "brake", offset = Vector(-101.48,34.27,34.81), size = 50, color = Color(255,0,0,50), dir = Vector( -1, 0.5, 0 ) },
        { type = "brake", offset = Vector(-101.48,-34.27,34.81), size = 50, color = Color(255,0,0,50), dir = Vector( -1, -0.5, 0 ) },
        { type = "taillight", offset = Vector(-101.48,34.27,34.81), size = 50, color = Color(255,0,0,50), dir = Vector( -1, 0.5, 0 ) },
        { type = "taillight", offset = Vector(-101.48,-34.27,34.81), size = 50, color = Color(255,0,0,50), dir = Vector( -1, -0.5, 0 ) },
        { type = "headlight", offset = Vector(99.21,30.14,29.56), size = 40, color = Color(215,240,255,155), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector(99.21,-30.14,29.56), size = 40, color = Color(215,240,255,155), dir = Vector( 1, 0, 0 ) },
        { type = "reverse", offset = Vector(-99.94,35.2,40.17), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "reverse", offset = Vector(-99.94,-35.2,40.17), dir = Vector( -1, 0, 0 ),size = 30 },
		{ type = "signal_left", offset = Vector( 95.88,33.1,34.92 ), dir = Vector( 1, 0.5, 0 ), color = Glide.DEFAULT_TURN_SIGNAL_COLOR,size = 25 },
        { type = "signal_right", offset = Vector( 95.88,-33.1,34.92 ), dir = Vector( 1, -0.5, 0 ), color = Glide.DEFAULT_TURN_SIGNAL_COLOR,size = 25 },

    }

     ENT.SirenLights = {

        { bodygroup = 9, time = 0, duration = 0.5 },
        { bodygroup = 10, time = 0.5, duration = 0.5 },

        -- RED

        { offset = Vector(-16.2,22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0,size = 180, color = Color(255,30,0,125), },
        { offset = Vector(-16.2,22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.25,size = 180, color = Color(255,30,0,125), },
        { offset = Vector(-16.2,-22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0,size = 180, color = Color(255,30,0,125), },
        { offset = Vector(-16.2,-22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.25,size = 180, color = Color(255,30,0,125), },

        { offset = Vector(-8.54,22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0,size = 180, color = Color(255,30,0,125), },
        { offset = Vector(-8.54,22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.25,size = 180, color = Color(255,30,0,125), },
        { offset = Vector(-8.54,-22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0,size = 180, color = Color(255,30,0,125), },
        { offset = Vector(-8.54,-22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.25,size = 180, color = Color(255,30,0,125), },

        { offset = Vector(-16.2,22.25,71.78), time = 0,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-16.2,22.25,71.78), time = 0.25,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-16.2,15.92,71.78), time = 0,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-16.2,15.92,71.78), time = 0.25,size = 50, color = Color(255,30,0,175), },

        { offset = Vector(-16.2,-22.25,71.78), time = 0,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-16.2,-22.25,71.78), time = 0.25,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-16.2,-15.92,71.78), time = 0,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-16.2,-15.92,71.78), time = 0.25,size = 50, color = Color(255,30,0,175), },

        { offset = Vector(-8.54,22.25,71.78), time = 0,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-8.54,22.25,71.78), time = 0.25,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-8.54,15.92,71.78), time = 0,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-8.54,15.92,71.78), time = 0.25,size = 50, color = Color(255,30,0,175), },

        { offset = Vector(-8.54,-22.25,71.78), time = 0,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-8.54,-22.25,71.78), time = 0.25,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-8.54,-15.92,71.78), time = 0,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(-8.54,-15.92,71.78), time = 0.25,size = 50, color = Color(255,30,0,175), },

        { offset = Vector(117.61,-9.75,24.04), dir = Vector( 1, 0, 0 ), time = 0,size = 50, color = Color(255,30,0,175), },
        { offset = Vector(117.61,-9.75,24.04), dir = Vector( 1, 0, 0 ), time = 0.25,size = 50, color = Color(255,30,0,175), },

        -- BLUE

        { offset = Vector(-76.81,36.15,49.83), dir = Vector( 0, 1, 0 ), time = 0,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-76.81,36.15,49.83), dir = Vector( 0, 1, 0 ), time = 0.25,size = 50, color = Color(0,115,255,175), },

        { offset = Vector(-76.81,-36.15,49.83), dir = Vector( 0, -1, 0 ), time = 0,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-76.81,-36.15,49.83), dir = Vector( 0, -1, 0 ), time = 0.25,size = 50, color = Color(0,115,255,175), },

        { offset = Vector(-76.81,36.15,49.83), dir = Vector( 0, 1, 0 ), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-76.81,36.15,49.83), dir = Vector( 0, 1, 0 ), time = 0.75,size = 50, color = Color(0,115,255,175), },

        { offset = Vector(-76.81,-36.15,49.83), dir = Vector( 0, -1, 0 ), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-76.81,-36.15,49.83), dir = Vector( 0, -1, 0 ), time = 0.75,size = 50, color = Color(0,115,255,175), },

        { offset = Vector(-16.2,9.53,71.78), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-16.2,9.53,71.78), time = 0.75,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-16.2,3.24,71.78), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-16.2,3.24,71.78), time = 0.75,size = 50, color = Color(0,115,255,175), },

        { offset = Vector(-8.54,9.53,71.78), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-8.54,9.53,71.78), time = 0.75,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-8.54,3.24,71.78), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-8.54,3.24,71.78), time = 0.75,size = 50, color = Color(0,115,255,175), },

        { offset = Vector(-16.2,-9.53,71.78), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-16.2,-9.53,71.78), time = 0.75,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-16.2,-3.24,71.78), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-16.2,-3.24,71.78), time = 0.75,size = 50, color = Color(0,115,255,175), },

        { offset = Vector(-8.54,-9.53,71.78), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-8.54,-9.53,71.78), time = 0.75,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-8.54,-3.24,71.78), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(-8.54,-3.24,71.78), time = 0.75,size = 50, color = Color(0,115,255,175), },

        { offset = Vector(117.61,9.75,24.04), dir = Vector( 1, 0, 0 ), time = 0.5,size = 50, color = Color(0,115,255,175), },
        { offset = Vector(117.61,9.75,24.04), dir = Vector( 1, 0, 0 ), time = 0.75,size = 50, color = Color(0,115,255,175), },

        { offset = Vector(-16.2,0,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5,size = 180, color = Color(0,115,255,175), },
        { offset = Vector(-16.2,0,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.75,size = 180, color = Color(0,115,255,175), },
        { offset = Vector(-8.54,0,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5,size = 180, color = Color(0,115,255,175), },
        { offset = Vector(-8.54,0,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.75,size = 180, color = Color(0,115,255,175), },

}
     
    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "uvfordexplorerengine" )
    end


    local path = string.format("models/unitvehiclescars/uv_fordexplorer/", ENT.VehicleName)
    local lightsPath = path .. "lights/"
    
    local Lights = {
        ['Off'] = {
            [20] = "",
        },
        ['On'] = {},
        ['Brake'] = {
            [20] = lightsPath .. "beam",
        },
        ['Beams'] = {
            ['Off'] = {
                [20] = "",
                [19] = "",
            },
            [1] = {
                [20] = lightsPath .. "beam",
                [19] = lightsPath .. "litfull",
            },
            [2] = {
                [20] = lightsPath .. "beam",
                [19] = lightsPath .. "litfull",
            }
        }
    }

    function ENT:OnUpdateMisc()
        local eo, hl, br = self:IsEngineOn(), self:GetHeadlightState(), self:IsBraking()
        BaseClass.OnUpdateMisc(self)
        
        local submaterials = {}
        
        for bodyId, subMaterial in pairs(Lights['On']) do
            submaterials[bodyId] = subMaterial
        end
        
        if hl >= 1 and Lights['Beams'][hl] then
            for bodyId, subMaterial in pairs(Lights['Beams'][hl]) do
                submaterials[bodyId] = subMaterial
            end
        else
            for bodyId in pairs(Lights['Beams']['Off']) do
                submaterials[bodyId] = ""
            end
        end
        
        for bodyId, subMaterial in pairs(Lights['Brake']) do
            submaterials[bodyId] = ((eo and br) and subMaterial) or submaterials[bodyId]
        end

        for bodyId, subMaterial in pairs(Lights['Off']) do
            submaterials[bodyId] = ((not eo) and subMaterial) or submaterials[bodyId]
        end
        
        for bodyId, subMaterial in pairs(submaterials) do
            self:SetSubMaterial(bodyId, subMaterial)
        end
    end
end

if SERVER then

    ENT.SpawnPositionOffset = Vector( 0, 0, 20 )
    ENT.ChassisMass = 1000

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 7, 0, -8 ) )
    end
    function ENT:GetGears()
        return {
		
		
            [-1] = 3,
            [0] = 0,
            [1] = 3.2,
            [2] = 1.9,
            [3] = 1.4,
            [4] = 1.0,
            [5] = 0.85,
            [6] = 0.75,
			
        }
		
		
    end

    function ENT:CreateFeatures()

        self:CreateSeat( Vector(-4,21.5,14), Angle( 0.000000, -90.000000, 2.000000 ), Vector( 0.000000,  80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(15,-19.5,15), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, 80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(-30,-19,15), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, -80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(-30,19,15), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, -80.000000, 10.000000 ), true )

		self:SetSpringStrength( 1200 )
        self:SetSpringDamper( 3000 )
        self:SetSuspensionLength ( 7 )

        self:SetDifferentialRatio( 1.00 )
        self:SetTransmissionEfficiency( 0.80 )
        self:SetPowerDistribution( -0.25 )
        self:SetBrakePower( 4000 )

        self:SetMinRPM( 700 ) 
        self:SetMaxRPM( 18000 ) 
        self:SetMinRPMTorque( 5200 )
        self:SetMaxRPMTorque( 4800 )

        self:SetMaxSteerAngle( 40 )
        self:SetSteerConeChangeRate( 7 )
        self:SetSteerConeMaxSpeed( 1400 )
        self:SetSteerConeMaxAngle( 0.20 )
		self:SetCounterSteer ( 0.8 )

        self:SetForwardTractionMax( 5500 )
        self:SetForwardTractionBias( 0 )
        self:SetSideTractionMultiplier( 20 )
        self:SetSideTractionMaxAng( 25 )
        self:SetSideTractionMax( 4000 ) 
        self:SetSideTractionMin( 1200 )

		self:SetTurboCharged( false )
		self:SetFastTransmission( false ) 

        self:CreateWheel( Vector( 69.0, 37.0, 11.5 ), {
            model = "models/redcpol_explorer11/redcpol_explorer11_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 1, 1 ),
			radius = 17.0
        } )
        self:CreateWheel( Vector( 69.0, -37.0, 11.5 ), {
            model = "models/redcpol_explorer11/redcpol_explorer11_wheel.mdl",
            modelAngle = Angle( -0.000000, -90.000000, -0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 1, 1 ),
			radius = 17.0
        } )
        self:CreateWheel( Vector( -60, 37.5, 11.5 ), {
            model = "models/redcpol_explorer11/redcpol_explorer11_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            modelScale = Vector( 1, 1, 1 ),
			radius = 17.0
        } )
        self:CreateWheel( Vector( -60, -37.5, 11.5 ), {
            model = "models/redcpol_explorer11/redcpol_explorer11_wheel.mdl",
            modelAngle = Angle( -0.000000, -90.000000, -0.000000 ),
            modelScale = Vector( 1, 1, 1 ),
			radius = 17.0
            } )

    end
end

function ENT:GetSpawnColor()
    return Color( 255, 255, 255 )
end

