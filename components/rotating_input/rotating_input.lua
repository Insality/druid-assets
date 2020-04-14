--- Component for rich progress component
-- @module druid.progress_rich

local const = require("druid.const")
local component = require("druid.component")

local M = component.create("pin", { const.ON_INPUT })

local SCHEME = {
	ROOT = "root",
	PIN = "pin",
}


local function update_visual(self)
	local rotation = vmath.vector3(0, 0, self.angle)
	gui.set_rotation(self.node, rotation)
end


local function set_angle(self, value)
	local prev_value = self.angle

	self.angle = value
	self.angle = math.min(self.angle, self.angle_max)
	self.angle = math.max(self.angle, self.angle_min)
	update_visual(self)

	if prev_value ~= self.angle and self.callback then
		local output_value = self.angle
		if output_value ~= 0 then
			output_value = -output_value
		end
		self.callback(self:get_context(), output_value)
	end
end


function M.init(self, template_name, callback)
	self:set_template(template_name)
	self.druid = self:get_druid()
	self.node = self:get_node(SCHEME.PIN)
	self.is_drag = false

	self.callback = callback
	self:set_angle(0, -100, 100)
end


function M.set_angle(self, cur_value, min, max)
	self.angle_min = min
	self.angle_max = max
	set_angle(self, cur_value)
end


function M.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH then
		return false
	end

	if gui.pick_node(self.node, action.x, action.y) then
		if action.pressed then
			self.pos = gui.get_position(self.node)
			self.is_drag = true
		end
	end

	if self.is_drag and not action.pressed then
		set_angle(self, self.angle - action.dx)
	end

	if action.released then
		self.is_drag = false
	end

	return self.is_drag
end


return M
