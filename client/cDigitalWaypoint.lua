class 'DigitalWaypoint'

-- Set waypoint using: /sw [number] [number]
-- "k" format is accepted (Ex: 25.4k returns 25400)
-- Clear waypoint using: /cw
-- Get waypoint using: /gw
-- Add custom waypoints in the self.custom table
-- Waypoint:GetDistance() returns distance from LocalPlayer to Waypoint

function DigitalWaypoint:__init()

	self.color = Color.Silver

	self.custom = {} -- Add custom waypoints here
	self.custom["pia"] = {9610, 12760, "Panau International Airport"}
	self.custom["totw"] = {20541, 11837, "Top of the World"}

	Events:Subscribe("LocalPlayerChat", self, self.Control)

end

function DigitalWaypoint:Control(args)

	local text = args.text:split(" ")

	if text[1] == "/sw" then

		local x_string = text[2]
		local y_string = text[3]

		local n = tonumber(x_string)
		local m = tonumber(y_string)

		if not n and x_string then
			n = tonumber(x_string:match('(%d+)k'))
			n = n and n * 1000
		end

		if not m and y_string then
			m = tonumber(y_string:match('(%d+)k'))
			m = m and m * 1000
		end

		if n and m and #text == 3 then
			Waypoint:SetPosition(Vector3(n - 16384, 0, m - 16384))
			Chat:Print(string.format('Waypoint set at x = %i m, y = %i m', n, m), self.color)
		elseif self.custom[x_string] and #text == 2 then
			n = self.custom[x_string][1]
			m = self.custom[x_string][2]
			Waypoint:SetPosition(Vector3(n - 16384, 0, m - 16384))
			Chat:Print("Waypoint set at " .. tostring(self.custom[x_string][3]), self.color)
		else
			Chat:Print("Invalid waypoint", self.color)
		end
		return false

	end

	if args.text == "/cw" then
		local pos, marker = Waypoint:GetPosition()
		if marker then
			Waypoint:Remove()
			Chat:Print("Waypoint removed", self.color)
		else
			Chat:Print("No waypoint set", self.color)
		end
		return false
	end

	if args.text == "/gw" then
		local pos, marker = Waypoint:GetPosition()
		if marker then
			Chat:Print(string.format('Waypoint located %i m away at x = %i m, y = %i m', Waypoint:GetDistance(), pos.x + 16384, pos.z + 16384), self.color)
		else
			Chat:Print("No waypoint set", self.color)
		end
		return false
	end

	if args.text == "/pos" then
		local pos = LocalPlayer:GetPosition()
		Chat:Print(string.format('Current location is x = %i m, y = %i m', pos.x + 16384, pos.z + 16384), self.color)
		return false
	end

end

function Waypoint:GetDistance()
	return (self:GetPosition()):Distance(LocalPlayer:GetPosition())
end

DigitalWaypoint = DigitalWaypoint()
