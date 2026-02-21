local Utils = {}

function Utils.lerp(a, b, t)
	local kind = typeof(a)

	if kind == "number" then
		return a + (b - a) * t

	elseif kind == "Vector3" then
		return a:Lerp(b, t)

	elseif kind == "Vector2" then
		return a:Lerp(b, t)

	elseif kind == "CFrame" then
		return a:Lerp(b, t)

	elseif kind == "Color3" then
		return a:Lerp(b, t)

	elseif kind == "UDim2" then
		return a:Lerp(b, t)

	elseif kind == "UDim" then
		return UDim.new(
			a.Scale  + (b.Scale  - a.Scale)  * t,
			a.Offset + (b.Offset - a.Offset) * t
		)

	elseif kind == "NumberRange" then
		return NumberRange.new(
			a.Min + (b.Min - a.Min) * t,
			a.Max + (b.Max - a.Max) * t
		)

	elseif kind == "NumberSequenceKeypoint" then
		return NumberSequenceKeypoint.new(
			a.Time     + (b.Time     - a.Time)     * t,
			a.Value    + (b.Value    - a.Value)    * t,
			a.Envelope + (b.Envelope - a.Envelope) * t
		)

	elseif kind == "ColorSequenceKeypoint" then
		return ColorSequenceKeypoint.new(
			a.Time + (b.Time - a.Time) * t,
			a.Value:Lerp(b.Value, t)
		)

	end

	return t >= 1 and b or a
end

function Utils.captureProperties(obj, props)
	local snapshot = {}
	for key in pairs(props) do
		snapshot[key] = obj[key]
	end
	return snapshot
end

function Utils.generateId()
	return tostring(math.floor(tick() * 1000)) .. "_" .. tostring(math.random(100000, 999999))
end

function Utils.shallowCopy(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

return Utils
