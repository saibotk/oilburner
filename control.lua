local evs=defines.events

script.on_init(function() global.oilburners={} end)--init some tables

script.on_event({evs.on_built_entity,evs.on_robot_built_entity},
	function(e)
		--this is reaction to our entities being built
		local en=e.created_entity
		--first we check if it's our entity
		if en.name=='oilburner' then
			local uid=en.unit_number--many entities have this field, which is guaranteed to be unique
			global.oilburners[uid]=global.oilburners[uid] or {}--this is common table initialization\check trick
			global.oilburners[uid]=en
		end
	end
)

script.on_event(evs.on_tick,function(e)
--this function is called on each game tick(update of the game state)
--it will murder the game's fps if done badly	
	
if not (e.tick%6000)==0 then return end
	for uid, en in pairs(global.oilburners) do
		if en.valid == true then
			local fluid = en.fluidbox[1]
			if fluid ~= nil then
				if fluid.type == "heavy-oil" or fluid.type == "light-oil" or fluid.type == "petroleum-gas" or fluid.type == "crude-oil" then 
					en.fluidbox[1] = nil
				end
			end
		else	
			global.oilburners[uid] = nil
		end
	end
end
)
