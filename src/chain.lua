local Tween = require(script.Parent.tween)

local Chain = {}
Chain.__index = Chain

function Chain.new(obj)
	local self = setmetatable({}, Chain)

	self._obj            = obj
	self._steps          = {}
	self._onStartCb      = nil
	self._onCompleteCb   = nil

	return self
end

function Chain:to(duration, properties, easing, options)
	table.insert(self._steps, {
		type       = "tween",
		duration   = duration,
		properties = properties,
		easing     = easing,
		options    = options,
	})
	return self
end

function Chain:from(duration, properties, easing, options)
	options = options or {}

	local currentProps = {}
	for key in pairs(properties) do
		currentProps[key] = self._obj[key]
	end

	options.fromProps = properties

	table.insert(self._steps, {
		type       = "tween",
		duration   = duration,
		properties = currentProps,
		easing     = easing,
		options    = options,
	})
	return self
end

function Chain:wait(duration)
	table.insert(self._steps, {
		type     = "wait",
		duration = duration,
	})
	return self
end

function Chain:call(callback)
	table.insert(self._steps, {
		type     = "call",
		callback = callback,
	})
	return self
end

function Chain:onStart(callback)
	self._onStartCb = callback
	return self
end

function Chain:onComplete(callback)
	self._onCompleteCb = callback
	return self
end

function Chain:play()
	if self._onStartCb then self._onStartCb() end
	self:_runStep(1)
	return self
end

function Chain:_runStep(index)
	local step = self._steps[index]

	if not step then
		if self._onCompleteCb then self._onCompleteCb() end
		return
	end

	if step.type == "tween" then
		local t = Tween.new(self._obj, step.duration, step.properties, step.easing, step.options)
		t:onComplete(function()
			self:_runStep(index + 1)
		end)
		t:play()

	elseif step.type == "wait" then
		task.delay(step.duration, function()
			self:_runStep(index + 1)
		end)

	elseif step.type == "call" then
		step.callback()
		self:_runStep(index + 1)
	end
end

return Chain
