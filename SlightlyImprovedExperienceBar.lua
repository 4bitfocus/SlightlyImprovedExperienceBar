-- Must be the first line
SIEB = {}

SIEB.name = "SlightlyImprovedExperienceBar"
SIEB.version = "2.21"
SIEB.ignoreOnHideEvent = false
SIEB.configVersion = 5
-- hmm, noone actually uses this one...
SIEB.championPointsMax = 360000

SIEB.defaults = {
	minimumAlpha = 0.8,
	showPercentageText = true,
	showCurrentMaxText = true,
	showDuringDialog = false,
	showExpAsChampion = false,
	flashGainDuration = 6,
	showLabelBelow = true,
}

-- Create a one line text label for placing over an attribute or experience bar
function SIEB.NewBarLabel(name, parent, horizontalAlign)

	local label = WINDOW_MANAGER:CreateControl(name, parent, CT_LABEL)
	label:SetDimensions(200, 20)
	label:SetAnchor(CENTER, parent, CENTER, 0, -1)
	label:SetFont("ZoFontGameBold")
	label:SetColor(0.9, 0.9, 0.9, 1)
	label:SetHorizontalAlignment(horizontalAlign)
	label:SetVerticalAlignment(CENTER)
	return label

end

-- Create the controls for the configuration pannel
function SIEB.CreateConfiguration()

	local LAM = LibStub("LibAddonMenu-2.0")

	panelData = {
		type = "panel",
		name = "Experience Bar",
		displayName = "Slightly Improved Experience Bar",
		author = "L8Knight",
		version = SIEB.version,
		registerForDefaults = true,
	}

	LAM:RegisterAddonPanel(SIEB.name.."Config", panelData)

	controlData = {
		[1] = {
			type = "slider",
			name = "Transparency",
			tooltip = "Transparency value for the experience bar",
			min = 0, max = 10, step = 1,
			getFunc = function() return SIEB.vars.minimumAlpha * 10 end,
			setFunc = function(newValue) SIEB.vars.minimumAlpha = newValue / 10.0 end,
			default = SIEB.defaults.minimumAlpha * 10,
		},
		[2] = {
			type = "checkbox",
			name = "Show Percentage Text",
			tooltip = "Show current experience progress as a percentage",
			getFunc = function() return SIEB.vars.showPercentageText end,
			setFunc = function(newValue) SIEB.vars.showPercentageText = newValue; SIEB.RefreshLabel() end,
			default = SIEB.defaults.showPercentageText,
		},
		[3] = {
			type = "checkbox",
			name = "Show Cur/Max Text",
			tooltip = "Show current/maximum experience values",
			getFunc = function() return SIEB.vars.showCurrentMaxText end,
			setFunc = function(newValue) SIEB.vars.showCurrentMaxText = newValue; SIEB.RefreshLabel() end,
			default = SIEB.defaults.showCurrentMaxText,
		},
		[4] = {
			type = "checkbox",
			name = "Show Label Text Below Bar",
			tooltip = "Show the text label below the experience bar instead of above it",
			getFunc = function() return SIEB.vars.showLabelBelow end,
			setFunc = function(newValue) SIEB.vars.showLabelBelow = newValue; SIEB.SetLabelPosition(); SIEB.RefreshLabel() end,
			default = SIEB.defaults.showLabelBelow,
		},
		[5] = {
			type = "checkbox",
			name = "Show Bar During Dialog",
			tooltip = "Continue to show the experience bar during dialog screens",
			getFunc = function() return SIEB.vars.showDuringDialog end,
			setFunc = function(newValue) SIEB.vars.showDuringDialog = newValue; SIEB.UpdateInteractiveScene() end,
			default = SIEB.defaults.showDuringDialog,
		},
		[6] = {
			type = "checkbox",
			name = "Always Show Leveling Exp",
			tooltip = "Continue to show regular experience values even after hitting Champion status",
			getFunc = function() return SIEB.vars.showExpAsChampion end,
			setFunc = function(newValue) SIEB.vars.showExpAsChampion = newValue; SIEB.RefreshLabel() end,
			default = SIEB.defaults.showExpAsChampion,
		},
		[7] = {
			type = "slider",
			name = "Experience Gain Duration",
			tooltip = "Number of seconds to show experience gain",
			min = 0, max = 60, step = 1,
			getFunc = function() return SIEB.vars.flashGainDuration end,
			setFunc = function(newValue) SIEB.vars.flashGainDuration = newValue; SIEB.CreateAnimation() end,
			default = SIEB.defaults.flashGainDuration,
		},
	}

	LAM:RegisterOptionControls(SIEB.name.."Config", controlData)

end

function SIEB.CreateAnimation()
	
	local LAN = LibStub("LibAnimation-1.0", 1.1)
	SIEB.flashAnimation = LAN:New(SIEB.flashLabel)
	SIEB.flashAnimation:AlphaToFrom(1.0, 0.0, 500, SIEB.vars.flashGainDuration * 1000)
	
end

function SIEB.GetPlayerXP()

	if IsUnitChampion("player") and SIEB.vars.showExpAsChampion == false then
		return GetPlayerChampionXP()
	else
		return GetUnitXP("player")
	end

end

function SIEB.GetPlayerXPMax()

	if IsUnitChampion("player") and SIEB.vars.showExpAsChampion == false then
		local cp = GetUnitChampionPoints("player")
		if cp < GetChampionPointsPlayerProgressionCap() then
			cp = GetChampionPointsPlayerProgressionCap()
		end
		return GetNumChampionXPInChampionPoint(cp)
	else
		return GetUnitXPMax("player")
	end

end

function SIEB.SetLabelPosition()
	
	if not SIEB.experienceLabel then
		SIEB.experienceLabel = SIEB.NewBarLabel("SIEB_ExperienceBarLabel", ZO_PlayerProgressBar, TEXT_ALIGN_CENTER)
	end

	if SIEB.vars.showLabelBelow then
		SIEB.experienceLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
		SIEB.experienceLabel:ClearAnchors()
		SIEB.experienceLabel:SetAnchor(CENTER, ZO_PlayerProgressBarBar, CENTER, 0, 20)
	else
		SIEB.experienceLabel:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
		SIEB.experienceLabel:ClearAnchors()
		SIEB.experienceLabel:SetAnchor(RIGHT, ZO_PlayerProgressBarBar, RIGHT, 0, -22)
	end

  -- Only show the champion numbers for Champion players
	if IsUnitChampion("player") and not SIEB.championLabel then
		SIEB.championLabel = SIEB.NewBarLabel("SIEB_ChampionBarLabel", ZO_PlayerProgressBar, TEXT_ALIGN_RIGHT)
	end

	if SIEB.championLabel then
		if SIEB.vars.showLabelBelow then
			SIEB.championLabel:ClearAnchors()
			SIEB.championLabel:SetAnchor(RIGHT, ZO_PlayerProgressBarBar, RIGHT, -10, 25)
		else
			SIEB.championLabel:ClearAnchors()
			SIEB.championLabel:SetAnchor(RIGHT, ZO_PlayerProgressBarBar, RIGHT, -10, -25)
		end
	end

end

function SIEB.ExperienceBarOnUpdate()

	-- Use the OnUpdate event to make sure the alpha value is correct. The alpha
	-- value cannot be set during the OnShow event.
	ZO_PlayerProgressBar:SetAlpha(SIEB.vars.minimumAlpha)

end

function SIEB.OnExperienceGain(eventCode, reason, level, prevExp, curExp)

	-- Ignore the incoming values since the player can still gain experience points
	-- after they hit level 50. Instead, use the event as "some exp/vet point change
	-- happened" and update the label with the value the player wants to see.
	SIEB.RefreshLabel()
	SIEB.FlashGain()

end

function SIEB.UpdateInteractiveScene()

	if SIEB.vars.showDuringDialog then
		SCENE_MANAGER:GetScene("interact"):AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
		SCENE_MANAGER:GetScene("interact"):AddFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
	else
		SCENE_MANAGER:GetScene("interact"):RemoveFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
		SCENE_MANAGER:GetScene("interact"):RemoveFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
	end

end

-- Manual refresh of the label values
function SIEB.RefreshLabel()

	if SIEB.championLabel then
		SIEB.championLabel:SetText(SIEB.FormatLabelText(SIEB.GetPlayerXP(), SIEB.GetPlayerXPMax()))
	else
		SIEB.experienceLabel:SetText(SIEB.FormatLabelText(SIEB.GetPlayerXP(), SIEB.GetPlayerXPMax()))
	end

end

-- Callback for the experience update event
function SIEB.OnExperienceUpdate(eventCode, unitTag, currentExp, maxExp, reason)

	if unitTag ~= "player" then return end

	-- Ignore the incoming values since the player can still gain experience points
	-- after they hit level 50. Instead, use the event as "some exp/vet point change happened"
	-- and update the label with the value the player wants to see.

	SIEB.RefreshLabel()
	SIEB.FlashGain()

end

-- Flash the amount of xp just gained below the bar
function SIEB.FlashGain()

	local diff = SIEB.GetPlayerXP() - SIEB.lastXPValue
	if diff ~= 0 and SIEB.vars.flashGainDuration ~= 0 then
		local direction = ""
		if diff > 0 then direction = "+" end
		SIEB.flashLabel:SetText(direction..diff)
		SIEB.flashLabel:SetAlpha(1.0)
		SIEB.lastXPValue = SIEB.GetPlayerXP()
		SIEB.flashAnimation:Play()
	end

end

-- Create the label string based on user preferences
function SIEB.FormatLabelText(current, max)

	local percent = 0
	if max > 0 then
		percent = math.floor((current/max) * 100)
	else
		max = "MAX"
	end

	local str = ""
	
	-- Shorten the Champion exp display so it fits on the same line
	if IsUnitChampion("player") and SIEB.vars.showExpAsChampion == false and SIEB.vars.showLabelBelow == false then
		current = math.ceil(current / 1000) .. "k"
		max = math.ceil(max / 1000) .. "k"
	end

	-- Append the "current/maximum" text if configured
	if SIEB.vars.showCurrentMaxText then
		str = str .. current .. " / " .. max
	end

	-- Append the percentage text if configured
	if SIEB.vars.showPercentageText then
		if SIEB.vars.showCurrentMaxText then
			str = str .. "  "
		end
		str = str .. percent .. "%"
	end

	return str

end

-- Initializer functions that runs once when the game is loading addons
function SIEB.Initialize(eventCode, addOnName)

	-- Only initialize our own addon
	if SIEB.name ~= addOnName then return end

	-- Load the saved variables
	SIEB.vars = ZO_SavedVars:NewAccountWide("SIEBVars", SIEB.configVersion, nil, SIEB.defaults)

	-- Create config menu
	SIEB.CreateConfiguration()

	-- Create the top label for the experience bar
	SIEB.SetLabelPosition()

	-- Create the bottom label for the experience bar
	SIEB.flashLabel = SIEB.NewBarLabel("SIEB_ExperienceFlashLabel", ZO_PlayerProgressBar, TEXT_ALIGN_LEFT)
	SIEB.flashLabel:SetAnchor(LEFT, ZO_PlayerProgressBarBar, RIGHT, 7, -2)

	-- Setup the animation for our flash label
	SIEB.CreateAnimation()

	SIEB.lastXPValue = SIEB.GetPlayerXP()

	ZO_PreHookHandler(ZO_PlayerProgressBar, 'OnUpdate', SIEB.ExperienceBarOnUpdate)

	-- Add the experience bar to the two hud displays so it always shows up
	SCENE_MANAGER:GetScene("hud"):AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
	SCENE_MANAGER:GetScene("hudui"):AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
	SCENE_MANAGER:GetScene("hud"):AddFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
	SCENE_MANAGER:GetScene("hudui"):AddFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)

	SIEB.UpdateInteractiveScene()

	-- Initialize the label
	SIEB.RefreshLabel()
	
	-- Register for future experience updates
	EVENT_MANAGER:RegisterForEvent("SIEB", EVENT_EXPERIENCE_GAIN, SIEB.OnExperienceGain)
	EVENT_MANAGER:RegisterForEvent("SIEB", EVENT_CHAMPION_POINTS_GAIN, SIEB.OnExperienceGain)
	
end


-- Register for the init handler (needs to be declaired after the SIEB.Initialize function)
EVENT_MANAGER:RegisterForEvent("SIEB", EVENT_ADD_ON_LOADED, SIEB.Initialize)
