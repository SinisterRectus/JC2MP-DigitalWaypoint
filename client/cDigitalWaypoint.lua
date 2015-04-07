-- Written by Sinister Rectus - http://www.jc-mp.com/forums/index.php?action=profile;u=73431

class 'DigitalWaypoint'

-- Set waypoint using: /sw [number] [number]
-- "k" format is accepted (Ex: 25.4k returns 25400)
-- Clear waypoint using: /cw
-- Get waypoint using: /gw
-- Add custom waypoints in the self.custom table
-- Waypoint:GetDistance() returns distance from LocalPlayer to Waypoint

function DigitalWaypoint:__init()

	self.msg_color = Color(192, 192, 192) -- Local chat messages
	
	self.custom = {} -- Add custom waypoints here
	self.custom["pia"] = {9610, 12760, "Panau International Airport"}

	Events:Subscribe("LocalPlayerChat", self, self.Control)
	
end

function DigitalWaypoint:Control(args) -- Subscribed to LocalPlayerChat

	local cmd_string = tostring(args.text:split(" ")[1])
	local x_string = tostring(args.text:split(" ")[2])
	local y_string = tostring(args.text:split(" ")[3])
	
	local n
	local m
	
	if tonumber(x_string) then
		n = tonumber(x_string)
	elseif string.find(x_string, "k") and x_string ~= "k" and string.sub(x_string, string.find(x_string, "k") + 1) == "" and tonumber(x_string:split("k")[1]) then
	-- Checks x input string for a "k" with nothing after it, but with a number before it
		n = tonumber(x_string:split("k")[1]) * 1000
	end
	
	if tonumber(y_string) then 
		m = tonumber(y_string)
	elseif string.find(y_string, "k") and y_string ~= "k" and string.sub(y_string, string.find(y_string, "k") + 1) == "" and tonumber(y_string:split("k")[1]) then
	-- Checks y input string for a "k" with nothing after it, but with a number before it
		m = tonumber(y_string:split("k")[1]) * 1000
	end
	
	if cmd_string == "/sw" then
		if n and m and #args.text:split(" ") == 3 then
			Waypoint:SetPosition(Vector3(n - 16384, 0, m - 16384))
			Chat:Print("Waypoint set at x = "..tostring(n).." m, y = "..tostring(m).. " m", self.msg_color)
		elseif self.custom[x_string] and #args.text:split(" ") == 2 then
			n = self.custom[x_string][1]
			m = self.custom[x_string][2]
			Waypoint:SetPosition(Vector3(n - 16384, 0, m - 16384))
			Chat:Print("Waypoint set at "..tostring(self.custom[x_string][3]), self.msg_color)
		else
			Chat:Print("Invalid waypoint", self.msg_color)
		end
		return false
	end
	
	if args.text == "/cw" then
		local pos, marker = Waypoint:GetPosition()
		if marker == true then
			Waypoint:Remove()
			Chat:Print("Waypoint removed", self.msg_color)
		else
			Chat:Print("No waypoint set", self.msg_color)
		end
	return false
	end
	
	if args.text == "/gw" then
		local pos, marker = Waypoint:GetPosition()
		if marker == true then
			Chat:Print("Waypoint located "..tostring(math.floor(Waypoint:GetDistance() + 0.5)).." m away at x = "..tostring(pos.x + 16384).." m, y = "..tostring(pos.z + 16384).." m", self.msg_color)
		else
			Chat:Print("No waypoint set", self.msg_color)
		end
	return false
	end
	
	if args.text == "/pos" then
		local pos = LocalPlayer:GetPosition()
		Chat:Print("Current location is x = "..tostring(math.floor(pos.x + 16384 + 0.5)).." m, y = "..tostring(math.floor(pos.z + 16384 + 0.5)).." m", self.msg_color)
	return false
	end
	
end

function Waypoint:GetDistance()
	local pos1 = LocalPlayer:GetPosition()
	local pos2 = Waypoint:GetPosition()
	return Vector3.Distance(pos1, pos2)
end

DigitalWaypoint = DigitalWaypoint()
