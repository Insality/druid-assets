--- Component for rich progress component
-- @module druid.progress_rich

local component = require("druid.component")

local M = component.create("progress_rich")

local SCHEME = {
	GREEN = "/progress_fill_inc",
	RED = "/progress_fill_dec",
	FILL = "/progress_fill",
}

function M.init(self, template_name, key, nodes)
	self:set_template(template_name)
	self:set_nodes(nodes)

	self.druid = self:get_druid()
	self.style = self:get_style()
	self.red = self.druid:new_progress(self:get_node(SCHEME.RED), key)
	self.green = self.druid:new_progress(self:get_node(SCHEME.GREEN), key)
	self.fill = self.druid:new_progress(self:get_node(SCHEME.FILL), key)
end


--- Instant fill progress bar to value
-- @function progress_rich:set_to
-- @tparam table self Component instance
-- @tparam number value Progress bar value, from 0 to 1
function M.set_to(self, value)
	self.red:set_to(value)
	self.green:set_to(value)
	self.fill:set_to(value)
end


--- Empty a progress bar
-- @function progress_rich:empty
-- @tparam table self Component instance
function M.empty(self)
	self.red:empty()
	self.green:empty()
	self.fill:empty()
end


--- Start animation of a progress bar
-- @function progress_rich:to
-- @tparam table self Component instance
-- @tparam number to value between 0..1
-- @tparam[opt] function callback Callback on animation ends
function M.to(self, to, callback)
	if self.fill.last_value == to then
		return
	end

	if self.timer then
		timer.cancel(self.timer)
		self.timer = nil
	end

	if self.fill.last_value < to then
		self.red:to(self.fill.last_value)
		self.green:to(to, function()
			self.timer = timer.delay(self.style.DELAY, false, function()
				self.red:to(to)
				self.fill:to(to, callback)
			end)
		end)
	end

	if self.fill.last_value > to then
		self.green:to(self.red.last_value)
		self.fill:to(to, function()
			self.timer = timer.delay(self.style.DELAY, false, function()
				self.green:to(to)
				self.red:to(to, callback)
			end)
		end)
	end
end


return M
