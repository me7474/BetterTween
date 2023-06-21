local BetterTween = {}
BetterTween.__index = BetterTween

local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")

function lerp(t, a, b)
	return a + (b - a) * t
end

function quadraticBezier(t, p0, p1, p2)
	local l1 = lerp(t, p0, p1)
	local l2 = lerp(t, p1, p2)
	local quad = lerp(t, l1, l2)
	return quad
end

function BetterTween.new(part, CFrame1, End, tweeninfo, wp)
	local ConstructedTween = {}
	setmetatable(ConstructedTween, BetterTween)
	ConstructedTween.startingPoint = CFrame1
	ConstructedTween.endPoint = End
	ConstructedTween.target = part
	ConstructedTween.weight = Instance.new("NumberValue")
	ConstructedTween.tweeninfo = tweeninfo or TweenInfo.new()
	ConstructedTween.tween = ts:Create(ConstructedTween.weight,ConstructedTween.tweeninfo,{Value = 1})
	ConstructedTween.WP = wp
	
	return ConstructedTween
end

function BetterTween:Start()
	self.step = nil
	
	if typeof(self.endPoint) == "CFrame" then
		if self.WP then
			self.step = rs.Stepped:Connect(function()
				self.target.CFrame = CFrame.new(quadraticBezier(self.weight.Value, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z), Vector3.new(self.WP.X, self.WP.Y, self.WP.Z), Vector3.new(self.endPoint.X, self.endPoint.Y, self.endPoint.Z)))
			end)
		else
			self.step = rs.Stepped:Connect(function()
				self.target.CFrame = CFrame.new(lerp(self.weight.Value, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z),Vector3.new(self.endPoint.X, self.endPoint.Y, self.endPoint.Z)))
			end)
		end
	else
		if self.WP then
			self.step = rs.Stepped:Connect(function()
				self.target.CFrame = CFrame.new(quadraticBezier(self.weight.Value, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z), Vector3.new(self.WP.X, self.WP.Y, self.WP.Z), self.endPoint.Position))
			end)
		else
			self.step = rs.Stepped:Connect(function()
				self.target.CFrame = CFrame.new(lerp(self.weight.Value, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z), self.endPoint.Position))
			end)
		end
	end
	self.tween:Play()
	self.tween.Completed:Wait()
	wait()
	self.step:Disconnect()
end

function BetterTween:Pause()
	self.tween:Pause()
	self.step:Disconnect()
end

function BetterTween:Resume()
	if typeof(self.endPoint) == "CFrame" then
		if self.WP then
			self.step = rs.Stepped:Connect(function()
				self.target.CFrame = CFrame.new(quadraticBezier(self.weight.Value, self.startingPoint, self.WP, Vector3.new(self.endPoint.X, self.endPoint.Y, self.endPoint.Z)))
			end)
		else
			self.step = rs.Stepped:Connect(function()
				self.target.CFrame = CFrame.new(lerp(self.weight.Value, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z),Vector3.new(self.endPoint.X, self.endPoint.Y, self.endPoint.Z)))
			end)
		end
	else
		if self.WP then
			self.step = rs.Stepped:Connect(function()
				self.target.CFrame = CFrame.new(quadraticBezier(self.weight.Value, self.startingPoint, self.WP, self.endPoint.Position))
			end)
		else
			self.step = rs.Stepped:Connect(function()
				self.target.CFrame = CFrame.new(lerp(self.weight.Value, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z), self.endPoint.Position))
			end)
		end
	end
	self.tween:Play()
end

function BetterTween:Cancel()
	self.tween:Pause()
	self.tween:Cancel()
	self.step:Disconnect()
end

function BetterTween:Scrub(weight)
	if typeof(self.endPoint) == "CFrame" then
		if self.WP then
			self.target.CFrame = CFrame.new(quadraticBezier(weight, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z), Vector3.new(self.WP.X, self.WP.Y, self.WP.Z), Vector3.new(self.endPoint.X, self.endPoint.Y, self.endPoint.Z)))
		else
			self.target.CFrame = CFrame.new(lerp(weight, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z),Vector3.new(self.endPoint.X, self.endPoint.Y, self.endPoint.Z)))
		end
	else
		if self.WP then
			self.target.CFrame = CFrame.new(quadraticBezier(weight, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z), Vector3.new(self.WP.X, self.WP.Y, self.WP.Z), self.endPoint.Position))
		else
			self.target.CFrame = CFrame.new(lerp(weight, Vector3.new(self.startingPoint.X, self.startingPoint.Y, self.startingPoint.Z), self.endPoint.Position))
		end
	end
end

return BetterTween
