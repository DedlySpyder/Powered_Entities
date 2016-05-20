--If technologies were changed
for _, force in pairs(game.forces) do 
	force.reset_technologies()
end

--If recipes were changed
for _, force in pairs(game.forces) do 
	force.reset_recipes()
end