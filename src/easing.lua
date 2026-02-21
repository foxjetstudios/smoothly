local Easing = {}

Easing.linear = function(t)
	return t
end

Easing.easeInQuad = function(t)
	return t * t
end

Easing.easeOutQuad = function(t)
	return t * (2 - t)
end

Easing.easeInOutQuad = function(t)
	if t < 0.5 then
		return 2 * t * t
	else
		return -1 + (4 - 2 * t) * t
	end
end

Easing.easeInCubic = function(t)
	return t * t * t
end

Easing.easeOutCubic = function(t)
	return 1 + (t - 1) ^ 3
end

Easing.easeInOutCubic = function(t)
	if t < 0.5 then
		return 4 * t * t * t
	else
		return (t - 1) * (2 * t - 2) ^ 2 + 1
	end
end

Easing.easeInQuart = function(t)
	return t * t * t * t
end

Easing.easeOutQuart = function(t)
	return 1 - (t - 1) ^ 4
end

Easing.easeInOutQuart = function(t)
	if t < 0.5 then
		return 8 * t * t * t * t
	else
		return 1 - 8 * (t - 1) ^ 4
	end
end

Easing.easeInSine = function(t)
	return 1 - math.cos(t * math.pi / 2)
end

Easing.easeOutSine = function(t)
	return math.sin(t * math.pi / 2)
end

Easing.easeInOutSine = function(t)
	return -(math.cos(math.pi * t) - 1) / 2
end

Easing.easeInExpo = function(t)
	if t == 0 then return 0 end
	return 2 ^ (10 * t - 10)
end

Easing.easeOutExpo = function(t)
	if t == 1 then return 1 end
	return 1 - 2 ^ (-10 * t)
end

Easing.easeInOutExpo = function(t)
	if t == 0 then return 0 end
	if t == 1 then return 1 end
	if t < 0.5 then
		return 2 ^ (20 * t - 10) / 2
	else
		return (2 - 2 ^ (-20 * t + 10)) / 2
	end
end

Easing.easeInCirc = function(t)
	return 1 - math.sqrt(1 - t ^ 2)
end

Easing.easeOutCirc = function(t)
	return math.sqrt(1 - (t - 1) ^ 2)
end

Easing.easeInOutCirc = function(t)
	if t < 0.5 then
		return (1 - math.sqrt(1 - (2 * t) ^ 2)) / 2
	else
		return (math.sqrt(1 - (-2 * t + 2) ^ 2) + 1) / 2
	end
end

Easing.easeInBack = function(t)
	local c = 1.70158
	return (c + 1) * t ^ 3 - c * t ^ 2
end

Easing.easeOutBack = function(t)
	local c = 1.70158
	return 1 + (c + 1) * (t - 1) ^ 3 + c * (t - 1) ^ 2
end

Easing.easeInOutBack = function(t)
	local c = 1.70158 * 1.525
	if t < 0.5 then
		return ((2 * t) ^ 2 * ((c + 1) * 2 * t - c)) / 2
	else
		return ((2 * t - 2) ^ 2 * ((c + 1) * (2 * t - 2) + c) + 2) / 2
	end
end

Easing.easeOutBounce = function(t)
	local n, d = 7.5625, 2.75
	if t < 1 / d then
		return n * t * t
	elseif t < 2 / d then
		t = t - 1.5 / d
		return n * t * t + 0.75
	elseif t < 2.5 / d then
		t = t - 2.25 / d
		return n * t * t + 0.9375
	else
		t = t - 2.625 / d
		return n * t * t + 0.984375
	end
end

Easing.easeInBounce = function(t)
	return 1 - Easing.easeOutBounce(1 - t)
end

Easing.easeInOutBounce = function(t)
	if t < 0.5 then
		return (1 - Easing.easeOutBounce(1 - 2 * t)) / 2
	else
		return (1 + Easing.easeOutBounce(2 * t - 1)) / 2
	end
end

Easing.easeInElastic = function(t)
	if t == 0 or t == 1 then return t end
	return -(2 ^ (10 * t - 10)) * math.sin((t * 10 - 10.75) * (2 * math.pi) / 3)
end

Easing.easeOutElastic = function(t)
	if t == 0 or t == 1 then return t end
	return 2 ^ (-10 * t) * math.sin((t * 10 - 0.75) * (2 * math.pi) / 3) + 1
end

Easing.easeInOutElastic = function(t)
	if t == 0 or t == 1 then return t end
	if t < 0.5 then
		return -(2 ^ (20 * t - 10) * math.sin((20 * t - 11.125) * (2 * math.pi) / 4.5)) / 2
	else
		return (2 ^ (-20 * t + 10) * math.sin((20 * t - 11.125) * (2 * math.pi) / 4.5)) / 2 + 1
	end
end

function Easing.get(name)
	if not name then return Easing.linear end
	if type(name) == "function" then return name end
	return Easing[name] or Easing.linear
end

function Easing.register(name, func)
	assert(type(name) == "string", "Easing name must be a string")
	assert(type(func) == "function", "Easing must be a function")
	Easing[name] = func
end

return Easing
