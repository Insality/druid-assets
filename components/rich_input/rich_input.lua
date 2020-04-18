local component = require("druid.component")

local M = component.create("rich_input")

local SCHEME = {
	ROOT = "root",
	BUTTON = "button",
	PLACEHOLDER = "placeholder_text",
	INPUT = "input_text",
	CURSOR = "cursor_node",
}


local function animate_cursor(self)
	gui.cancel_animation(self.cursor, gui.PROP_COLOR)
	gui.set_color(self.cursor, vmath.vector4(1))
	gui.animate(self.cursor, gui.PROP_COLOR, vmath.vector4(1,1,1,0), gui.EASING_INSINE, 0.8, 0, nil, gui.PLAYBACK_LOOP_PINGPONG)
end


local function update_text(self, text)
	local text_width = self.input.total_width
	animate_cursor(self)
	gui.set_position(self.cursor, vmath.vector3(text_width/2, 0, 0))
	gui.set_scale(self.cursor, self.input.text.scale)
end


local function on_select(self)
	gui.set_enabled(self.cursor, true)
	gui.set_enabled(self.placeholder.node, false)
	animate_cursor(self)
end


local function on_unselect(self)
	gui.set_enabled(self.cursor, false)
	gui.set_enabled(self.placeholder.node, true and #self.input:get_text() == 0)
end


function M.init(self, template, placeholder)
	self:set_template(template)
	self.druid = self:get_druid()
	self.input = self.druid:new_input(self:get_node(SCHEME.BUTTON), self:get_node(SCHEME.INPUT))
	self.cursor = self:get_node(SCHEME.CURSOR)

	self.input:set_text("")
	self.placeholder = self.druid:new_text(self:get_node(SCHEME.PLACEHOLDER))

	self.input.on_input_text:subscribe(update_text)
	self.input.on_input_select:subscribe(on_select)
	self.input.on_input_unselect:subscribe(on_unselect)
	on_unselect(self)
	update_text(self, "")
end


return M
