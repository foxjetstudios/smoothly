local Chain = require(script.Parent.chain)

local Sequence = {}

function Sequence.run(obj, steps, options)
	assert(obj,   "Smoothly.sequence: object is required")
	assert(steps, "Smoothly.sequence: steps table is required")

	options = options or {}

	local chain = Chain.new(obj)

	for _, step in ipairs(steps) do
		chain:to(
			step.duration,
			step.props or step.properties,
			step.easing,
			step.options
		)

		if step.after then
			chain:call(step.after)
		end

		if step.wait then
			chain:wait(step.wait)
		end
	end

	if options.onStart    then chain:onStart(options.onStart)       end
	if options.onComplete then chain:onComplete(options.onComplete)  end

	chain:play()

	return chain
end

return Sequence
