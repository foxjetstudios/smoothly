local Tween    = require(script.tween)
local Chain    = require(script.chain)
local Parallel = require(script.parallel)
local Sequence = require(script.sequence)
local Easing   = require(script.easing)
local Manager  = require(script.manager)
local Utils    = require(script.utils)

local Smoothly = {}

function Smoothly.to(obj, duration, properties, easing, options)
	local t = Tween.new(obj, duration, properties, easing, options)
	t:play()
	return t
end

function Smoothly.from(obj, duration, properties, easing, options)
	options = options or {}

	local currentProps = Utils.captureProperties(obj, properties)
	options.fromProps  = properties

	local t = Tween.new(obj, duration, currentProps, easing, options)
	t:play()
	return t
end

function Smoothly.chain(obj)
	return Chain.new(obj)
end

function Smoothly.parallel(tweenList, onComplete)
	return Parallel.run(tweenList, onComplete)
end

function Smoothly.sequence(obj, steps, options)
	return Sequence.run(obj, steps, options)
end

function Smoothly.reverse(tweenId)
	local t = Manager.get(tweenId)
	if t then t:reverse() end
end

function Smoothly.cancel(tweenId)
	local t = Manager.get(tweenId)
	if t then t:cancel() end
end

function Smoothly.cancelAll(tag)
	Manager.cancelAll(tag)
end

function Smoothly.pause(tweenId)
	local t = Manager.get(tweenId)
	if t then t:pause() end
end

function Smoothly.pauseAll(tag)
	Manager.pauseAll(tag)
end

function Smoothly.resume(tweenId)
	local t = Manager.get(tweenId)
	if t then t:resume() end
end

function Smoothly.resumeAll(tag)
	Manager.resumeAll(tag)
end

function Smoothly.delay(duration, callback)
	assert(type(duration) == "number" and duration >= 0, "Smoothly.delay: duration must be a non-negative number")
	assert(type(callback) == "function", "Smoothly.delay: callback must be a function")
	task.delay(duration, callback)
end

function Smoothly.ease(name, func)
	Easing.register(name, func)
end

function Smoothly.count(tag)
	return Manager.count(tag)
end

return Smoothly
