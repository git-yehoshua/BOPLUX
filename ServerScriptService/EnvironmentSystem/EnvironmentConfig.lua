-- EnvironmentConfig: tunables for the Day/Night match mode and the night
-- flashlight. All values are server-authoritative; clients only mirror state.
local EnvironmentConfig = {}

-- 50/50 roll once per match start (owner decision 2026-09-10).
EnvironmentConfig.NightChance = 0.5

-- Lighting snapshots applied wholesale when a match starts. Day mirrors the
-- engine defaults so a day match looks unchanged.
EnvironmentConfig.Day = {
	ClockTime = 14,
	Brightness = 3,
	Ambient = Color3.fromRGB(128, 128, 128),
	OutdoorAmbient = Color3.fromRGB(128, 128, 128),
	FogColor = Color3.fromRGB(192, 192, 192),
	FogEnd = 100000,
	ExposureCompensation = 0,
}

-- Night: cold low-light with a soft depth fog. Site beacons and jail lamps get
-- their own night-only lights (see RunEnvironmentSystem) so objectives stay
-- findable in the dark.
EnvironmentConfig.Night = {
	ClockTime = 0,
	Brightness = 1,
	Ambient = Color3.fromRGB(30, 34, 48),
	OutdoorAmbient = Color3.fromRGB(40, 46, 64),
	FogColor = Color3.fromRGB(18, 22, 34),
	FogEnd = 480,
	ExposureCompensation = 0.05,
}

-- Flashlight battery (owner decision 2026-09-10): drains while on, recharges
-- while off, mirrors the stamina system's shape.
EnvironmentConfig.BatteryMax = 100
EnvironmentConfig.BatteryDrainPerSecond = 2 -- 50s of continuous use
EnvironmentConfig.BatteryRegenPerSecond = 5 -- 20s to fully recharge
EnvironmentConfig.BatteryResumeThreshold = 15 -- re-enable floor after empty

-- SpotLight tuning (head-mounted, follows body facing).
EnvironmentConfig.FlashlightRange = 60
EnvironmentConfig.FlashlightAngle = 35
EnvironmentConfig.FlashlightBrightness = 3
EnvironmentConfig.FlashlightColor = Color3.fromRGB(255, 240, 200)

return EnvironmentConfig
