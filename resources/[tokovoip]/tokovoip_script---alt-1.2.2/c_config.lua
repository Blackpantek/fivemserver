TokoVoipConfig = {
	refreshRate = 100, -- Rate at which the data is sent to the TSPlugin
	networkRefreshRate = 2000, -- Rate at which the network data is updated/reset on the local ped
	playerListRefreshRate = 5000, -- Rate at which the playerList is updated
	latestVersion = "1.2.2", -- Version of the TS plugin required to play on the server
	distance = {
		8, -- Normal speech distance in gta distance units
		2, -- Whisper speech distance in gta distance units
		40, -- Shout speech distance in gta distance units
	},
	radioKey = Keys["CAPS"], -- Keybind used to talk on the radio
	keySwitchChannels = Keys["Z"], -- Keybind used to switch the radio channels
	keySwitchChannelsSecondary = Keys["LEFTSHIFT"], -- If set, both the keySwitchChannels and keySwitchChannelsSecondary keybinds must be pressed to switch the radio channels
	keyProximity = Keys["Z"], -- Keybind used to switch the proximity mode
	plugin_data = {
		-- TeamSpeak channel name used by the voip
		-- If the TSChannelWait is enabled, players who are currently in TSChannelWait will be automatically moved
		-- to the TSChannel once everything is running
		TSChannel = "Ingame",
		TSPassword = "test123", -- TeamSpeak channel password (can be empty)

		-- Optional: TeamSpeak waiting channel name, players wait in this channel and will be moved to the TSChannel automatically
		-- If the TSChannel is public and people can join directly, you can leave this empty and not use the auto-move
		TSChannelWait = "FiveM Ingame Wartehalle",
		
		-- Blocking screen informations
		TSServer = "ts.elysium-rp.de", -- TeamSpeak server address to be displayed on blocking screen
		TSChannelSupport = "Wartehalle Support", -- TeamSpeak support channel name displayed on blocking screen
		TSDownload = "http://www.elysium-rp.de", -- Download link displayed on blocking screen

		-- The following is purely TS client settings, to match tastes
		local_click_on = true, -- Is local click on sound active
		local_click_off = true, -- Is local click off sound active
		remote_click_on = false, -- Is remote click on sound active
		remote_click_off = true -- Is remote click off sound active
	}
};
