local component = require("druid.component")

local M = component.create("ps4_loader")


local SCHEME = {
	ROOT = "root",
	ELEM1 = "elem_1",
	ELEM2 = "elem_2",
	ELEM3 = "elem_3",
	ELEM4 = "elem_4",
}

local SCALE_0 = vmath.vector3(0)
local SCALE_1 = vmath.vector3(1)
local TIME = 0.7
local DISAPPEAR_DELAY = 0.8
local APPEAR_DELAY = 0.25
local HIDE_DELAY = 0.2
local ROTATE_ANGLE = 180
local ROTATE_VECTOR = vmath.vector3(0, 0, ROTATE_ANGLE)

local function contains(t, value)
	for i = 1, #t do
		if t[i] == value then
			return true
		end
	end
end


local function set_enabled(self, state)
	gui.set_enabled(self:get_node(SCHEME.ROOT), state)
end


local function random_texture(self, node)
	gui.play_flipbook(node, self.images[math.random(1, #self.images)])
end


local function disappear(self, node, cb, custom_delay)
	local delay = custom_delay or DISAPPEAR_DELAY
	gui.animate(node, "rotation.z", ROTATE_ANGLE, gui.EASING_OUTSINE, TIME, delay)
	gui.animate(node, "scale", SCALE_0, gui.EASING_OUTSINE, TIME, delay, function()
		if cb then
			cb()
		end
	end)
end


local function appear(self, node, cb)
	gui.set_rotation(node, ROTATE_VECTOR)
	gui.animate(node, "rotation.z", 0, gui.EASING_OUTSINE, TIME, APPEAR_DELAY)
	gui.animate(node, "scale", SCALE_1, gui.EASING_OUTSINE, TIME, APPEAR_DELAY, function()
		if cb then
			cb()
		end
	end)
end


local function animate_node(self, node)
	appear(self, node, function()
		disappear(self, node, function()
			random_texture(self, node)
			animate_node(self, node)
		end)
	end)
end


function M.init(self, template)
	self:set_template(template)

	self.elems = {
		self:get_node(SCHEME.ELEM1),
		self:get_node(SCHEME.ELEM2),
		self:get_node(SCHEME.ELEM3),
		self:get_node(SCHEME.ELEM4),
	}

	self.images = {}
	for i = 1, #self.elems do
		local texture_name = gui.get_flipbook(self.elems[i])
		if not contains(self.images, texture_name) then
			table.insert(self.images, texture_name)
		end
	end

	set_enabled(self, false)
end


function M.start(self)
	for i = 1, #self.elems do
		gui.set_scale(self.elems[i], SCALE_0)
		timer.delay((i-1) * HIDE_DELAY, false, function()
			animate_node(self, self.elems[i])
		end)
	end

	set_enabled(self, true)
end


function M.stop(self)
	for i = 1, #self.elems do
		gui.cancel_animation(self.elems[i], "scale")
		gui.cancel_animation(self.elems[i], "rotation")
		disappear(self, self.elems[i], function()
			if i == #self.elems then
				set_enabled(self, false)
			end
		end, 0)
	end
end


return M
