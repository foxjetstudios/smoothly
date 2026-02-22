local Tween = require(script.Parent.tween)

local Parallel = {}

function Parallel.run(tweenList, onComplete)
	assert(type(tweenList) == "table" and #tweenList > 0, "Smoothly.parallel: expected a non-empty list of tween entries")

	local total    = #tweenList
	local finished = 0

	local function onOneTweenDone()
		finished += 1
		if finished >= total and onComplete then
			onComplete()
		end
	end

	local tweens = {}

	for _, entry in ipairs(tweenList) do
		local obj, duration, properties, easing, options

		if entry.obj then
			obj        = entry.obj
			duration   = entry.duration
			properties = entry.props or entry.properties
			easing     = entry.easing
			options    = entry.options
		else
			obj        = entry[1]
			duration   = entry[2]
			properties = entry[3]
			easing     = entry[4]
			options    = entry[5]
		end

		local t = Tween.new(obj, duration, properties, easing, options)
		t:onComplete(onOneTweenDone)
		t:play()
		table.insert(tweens, t)
	end

	return tweens
end

return Parallel
