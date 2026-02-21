local RunService = game:GetService("RunService")

local Easing  = require(script.Parent.easing)
local Utils   = require(script.Parent.utils)
local Manager = require(script.Parent.manager)

local Tween = {}
Tween.__index = Tween

local STATES = {
	IDLE      = "idle",
	PLAYING   = "playing",
	PAUSED    = "paused",
	COMPLETED = "completed",
	CANCELLED = "cancelled",
}

function Tween.new(obj, duration, targetProps, easing, options)
	assert(obj,          "Smoothly: object is required")
	assert(duration,     "Smoothly: duration is required")
	assert(targetProps,  "Smoothly: properties table is required")

	options = options or {}

	local self = setmetatable({}, Tween)

	self.id            = Utils.generateId()
	self.tag           = options.tag

	self._obj          = obj
	self._duration     = math.max(0, duration)
	self._targetProps  = targetProps
	self._startProps   = options.fromProps or nil
	self._easingFunc   = Easing.get(easing)

	self._loop         = options.loop       or false
	self._pingPong     = options.pingPong   or false
	self._repeatCount  = options.repeatCount or 0

	self._elapsed      = 0
	self._repeatsDone  = 0
	self._direction    = 1
	self._state        = STATES.IDLE
	self._connection   = nil

	self._onStartCb    = nil
	self._onUpdateCb   = nil
	self._onCompleteCb = nil

	Manager.register(self.id, self)

	return self
end

function Tween:onStart(callback)
	self._onStartCb = callback
	return self
end

function Tween:onUpdate(callback)
	self._onUpdateCb = callback
	return self
end

function Tween:onComplete(callback)
	self._onCompleteCb = callback
	return self
end

function Tween:play()
	if self._state == STATES.PLAYING then return self end

	if not self._startProps then
		self._startProps = Utils.captureProperties(self._obj, self._targetProps)
	end

	for key in pairs(self._targetProps) do
		if self._startProps[key] == nil then
			warn("Smoothly: property '" .. tostring(key) .. "' was not found on " .. tostring(self._obj) .. " — it will be skipped.")
		end
	end

	if self._elapsed == 0 then
		if self._onStartCb then self._onStartCb() end
	end

	for key, val in pairs(self._startProps) do
		self._obj[key] = val
	end

	self._state = STATES.PLAYING

	self._connection = RunService.Heartbeat:Connect(function(dt)
		self._elapsed = self._elapsed + dt * self._direction

		local raw = math.clamp(self._elapsed / self._duration, 0, 1)
		local eased = self._easingFunc(raw)

		for key, target in pairs(self._targetProps) do
			local origin = self._startProps[key]
			if origin ~= nil then
				self._obj[key] = Utils.lerp(origin, target, eased)
			end
		end

		if self._onUpdateCb then self._onUpdateCb(raw) end

		local reachedEnd   = self._elapsed >= self._duration
		local reachedStart = self._elapsed <= 0

		if (self._direction == 1 and reachedEnd) or (self._direction == -1 and reachedStart) then
			self:_handleCycleEnd()
		end
	end)

	return self
end

function Tween:_handleCycleEnd()
	if self._pingPong then
		self._direction = -self._direction
		self._elapsed   = math.clamp(self._elapsed, 0, self._duration)
		self._halfsDone = (self._halfsDone or 0) + 1

		local infinite   = self._loop or self._repeatCount == 0
		local fullCycles = math.floor(self._halfsDone / 2)

		if not infinite and fullCycles >= self._repeatCount then
			self:_finish()
		end
		return
	end

	if self._loop or self._repeatsDone < self._repeatCount then
		self._repeatsDone += 1
		self._elapsed = 0
		return
	end

	self:_finish()
end

function Tween:_finish()
	for key, target in pairs(self._targetProps) do
		self._obj[key] = target
	end

	self:_disconnect()
	self._state = STATES.COMPLETED
	Manager.remove(self.id)

	if self._onCompleteCb then self._onCompleteCb() end
end

function Tween:_disconnect()
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end
end

function Tween:pause()
	if self._state ~= STATES.PLAYING then return self end
	self:_disconnect()
	self._state = STATES.PAUSED
	return self
end

function Tween:resume()
	if self._state ~= STATES.PAUSED then return self end
	self:play()
	return self
end

function Tween:cancel()
	self:_disconnect()
	self._state = STATES.CANCELLED
	Manager.remove(self.id)
	return self
end

function Tween:reverse()
	self._direction = -self._direction
	return self
end

function Tween:reset()
	self:cancel()
	self._elapsed     = 0
	self._repeatsDone = 0
	self._halfsDone   = 0
	self._direction   = 1
	self._state       = STATES.IDLE
	Manager.register(self.id, self)
	return self
end

function Tween:getState()
	return self._state
end

function Tween:getProgress()
	return math.clamp(self._elapsed / self._duration, 0, 1)
end

return Tween
