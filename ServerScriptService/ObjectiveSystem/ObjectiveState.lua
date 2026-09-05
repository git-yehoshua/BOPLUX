local ObjectiveState = {}

local sites = {}

function ObjectiveState.registerSite(id, center, plantDuration, defuseDuration, detonationSeconds)
	sites[id] = {
		id = id,
		center = center,
		plantDuration = plantDuration,
		defuseDuration = defuseDuration,
		detonationSeconds = detonationSeconds,
		planted = false,
		plantedBy = nil,
		detonationRemaining = 0,
		channel = nil,
	}
end

function ObjectiveState.siteIds()
	local ids = {}
	for id in pairs(sites) do
		table.insert(ids, id)
	end
	table.sort(ids)
	return ids
end

function ObjectiveState.hasSite(id)
	return sites[id] ~= nil
end

function ObjectiveState.siteCenter(id)
	local site = sites[id]
	if not site then
		return nil
	end
	return site.center
end

function ObjectiveState.isPlanted(siteId)
	local site = sites[siteId]
	return site ~= nil and site.planted
end

function ObjectiveState.plantedSite()
	for _, site in pairs(sites) do
		if site.planted then
			return site
		end
	end
	return nil
end

function ObjectiveState.markPlanted(siteId, player)
	local site = sites[siteId]
	if not site then
		return false
	end
	site.planted = true
	site.plantedBy = player
	site.detonationRemaining = site.detonationSeconds
	site.channel = nil
	for _, other in pairs(sites) do
		if other ~= site then
			other.channel = nil
		end
	end
	return true
end

function ObjectiveState.startChannel(siteId, kind, player, startPos)
	local site = sites[siteId]
	if not site then
		return false, "no-site"
	end
	if site.channel then
		return false, "channel-busy"
	end
	for _, other in pairs(sites) do
		if other.channel and other.channel.player == player then
			return false, "player-busy"
		end
	end
	site.channel = {
		kind = kind,
		player = player,
		progress = 0,
		startPos = startPos,
		duration = kind == "plant" and site.plantDuration or site.defuseDuration,
	}
	return true
end

function ObjectiveState.cancelChannel(siteId)
	local site = sites[siteId]
	if not site or not site.channel then
		return false
	end
	site.channel = nil
	return true
end

function ObjectiveState.cancelChannelFor(player)
	for _, site in pairs(sites) do
		if site.channel and site.channel.player == player then
			site.channel = nil
			return true
		end
	end
	return false
end

function ObjectiveState.channelInfo(siteId)
	local site = sites[siteId]
	if not site or not site.channel then
		return nil
	end
	return {
		kind = site.channel.kind,
		player = site.channel.player,
		progress = site.channel.progress,
		startPos = site.channel.startPos,
	}
end

function ObjectiveState.stepChannel(siteId, dt)
	local site = sites[siteId]
	if not site or not site.channel then
		return nil
	end
	local channel = site.channel
	channel.progress = channel.progress + dt
	if channel.progress >= channel.duration then
		site.channel = nil
		return {
			kind = channel.kind,
			complete = true,
			player = channel.player,
		}
	end
	return {
		kind = channel.kind,
		progress = channel.progress,
		complete = false,
	}
end

function ObjectiveState.detonationRemainingOf(siteId)
	local site = sites[siteId]
	if not site then
		return 0
	end
	return site.detonationRemaining
end

function ObjectiveState.stepDetonation(dt)
	local site = ObjectiveState.plantedSite()
	if not site then
		return false
	end
	site.detonationRemaining = math.max(0, site.detonationRemaining - dt)
	return site.detonationRemaining <= 0
end

function ObjectiveState.resetRound()
	for _, site in pairs(sites) do
		site.planted = false
		site.plantedBy = nil
		site.detonationRemaining = 0
		site.channel = nil
	end
end

return ObjectiveState