local noteNames = {[0] = "c", [1] = "csharp", [2] = "d", [3] = "dsharp", [4] = "e", [5] = "f", [6] = "fsharp", [7] = "g", [8] = "gsharp", [9] = "a", [10] = "asharp", [11] = "b"}
for i = 0, 11 do
	table.insert(noteNames, ("%s2"):format(noteNames[i]))
end

local function calculateTone(pos)
	local name = minetest.get_node(pos).name
	
	local tone_bell = minetest.get_item_group(name, "tone_bell")
	if tone_bell <= 0 then return 0 end
	
	local myTone = minetest.get_item_group(name, "tone_bell_tone")
	
	pos.y = pos.y + 1
	local nextTone = calculateTone(pos)
	pos.y = pos.y - 1
	
	return myTone + nextTone
end
local function calculateBaseTone(pos)
	local oldy = pos.y
	
	while minetest.get_item_group(minetest.get_node(pos).name, "tone_bell") > 0 do
		pos.y = pos.y - 1
	end
	pos.y = pos.y + 1
	
	local tone = calculateTone(pos)
	pos.y = oldy
	
	return tone
end

tone_bells = {}

function tone_bells.play(pos)
	minetest.sound_play(("tone_bells_%s"):format(noteNames[calculateBaseTone(pos) % (#noteNames + 1)]), {pos = pos}, true)
end

local function createBell(colour, tone)
	minetest.register_node(("tone_bells:%s"):format(colour), {
		description = ("%s Tone Bell"):format(colour:sub(1, 1):upper() .. colour:sub(2, -1)),
		tiles = {("tone_bells_%s_top.png"):format(colour), ("tone_bells_%s_top.png"):format(colour), ("tone_bells_%s_side.png"):format(colour)},
		
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {-7/16, -0.5, -7/16, 7/16, 0.5, 7/16}
		},
		selection_box = {type = "regular"},
		
		mesecons = {effector = {
			action_on = tone_bells.play,
			rules = mesecon and mesecon.rules.flat
		}},
		
		groups = {cracky = 3, tone_bell = 1, tone_bell_tone = tone},
		on_punch = tone_bells.play,
		
		on_place = function (itemstack, ...)
			local itemstack, pos = minetest.item_place(itemstack, ...)
			
			if pos then tone_bells.play(pos) end
			return itemstack
		end,
		
		sounds = {dig = ""}
	})
end

createBell("grey", 0)
createBell("red", 2)
createBell("blue", 5)
createBell("yellow", 1)

minetest.register_craft({
	output = "tone_bells:grey",
	recipe = {
		{"group:stone", "farming:string", "group:stone"},
		{"group:stone", "farming:string", "group:stone"},
		{"group:stone", "farming:string", "group:stone"},
	}
})

minetest.register_craft({
	output = "tone_bells:red",
	type = "shapeless",
	recipe = {
		"tone_bells:grey",
		"dye:red"
	}
})
minetest.register_craft({
	output = "tone_bells:blue",
	type = "shapeless",
	recipe = {
		"tone_bells:grey",
		"dye:blue"
	}
})
minetest.register_craft({
	output = "tone_bells:blue",
	type = "shapeless",
	recipe = {
		"tone_bells:grey",
		"dye:cyan"
	}
})
minetest.register_craft({
	output = "tone_bells:yellow",
	type = "shapeless",
	recipe = {
		"tone_bells:grey",
		"dye:yellow"
	}
})