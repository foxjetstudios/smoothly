local Manager = {}

local registry = {}

function Manager.register(id, tween)
	registry[id] = tween
end

function Manager.get(id)
	return registry[id]
end

function Manager.remove(id)
	registry[id] = nil
end

function Manager.cancelAll(tag)
	for _, tween in pairs(registry) do
		if tag == nil or tween.tag == tag then
			tween:cancel()
		end
	end
end

function Manager.pauseAll(tag)
	for _, tween in pairs(registry) do
		if tag == nil or tween.tag == tag then
			tween:pause()
		end
	end
end

function Manager.resumeAll(tag)
	for _, tween in pairs(registry) do
		if tag == nil or tween.tag == tag then
			tween:resume()
		end
	end
end

function Manager.getAll(tag)
	local result = {}
	for id, tween in pairs(registry) do
		if tag == nil or tween.tag == tag then
			result[id] = tween
		end
	end
	return result
end

function Manager.count(tag)
	local n = 0
	for _, tween in pairs(registry) do
		if tag == nil or tween.tag == tag then
			n = n + 1
		end
	end
	return n
end

return Manager
