local component = require("druid.component")
local druid_helper = require("druid.helper")

-- In your game, you can use your game specific logic or data.
-- Components can pick data from your game
local data = require("components.buy_button.data")


local M = component.create("progress_rich")

local SCHEME = {
	ROOT = "root",
	AMOUNT = "amount",
	ICON = "icon",
	BUTTON = "button"
}


local function is_enough(self)
	return self.price <= data.money
end


local function update_visual(self)
	local button_node = self.button.node
	local image = is_enough(self) and "button_green" or "button_yellow"
	gui.play_flipbook(button_node, image)
	druid_helper.centrate_icon_with_text(self:get_node(SCHEME.ICON), self:get_node(SCHEME.AMOUNT), 4)
end


local function on_click(self)
	if is_enough(self) then
		data.money = data.money - self.price
		self.callback(self:get_context())
		update_visual(self)
	else
		print("Money is not enough to pay")
	end
end


function M.init(self, template_name, callback)
	self:set_template(template_name)

	self.druid = self:get_druid()
	self.callback = callback

	self.button = self.druid:new_button(self:get_node(SCHEME.BUTTON), on_click)
	self:set_price(10)
end


function M.set_price(self, price)
	self.price = price
	gui.set_text(self:get_node(SCHEME.AMOUNT), self.price)
	update_visual(self)
end


function M.refresh(self)
	update_visual(self)
end


return M
