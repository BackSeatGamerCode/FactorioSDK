-- define a new function to process each reward
function spawn_biter()
	-- WARNING: never use game.player
	-- Use game.players[1], or even beter, iterate over all players instead.
	-- while game.player works in a single-player instance, it will fail when deployed to a Factorio server
	-- (which is what is needed to interact with the BackSeatGamer Reverse Proxy)
	game.surfaces.nauvis.create_entity({name="small-biter", position=game.players[1].position}) 
end

-- Use this line for each reward which could be redeemed
-- this should always go after the function definition
-- best practice is to define each of your functions first, 
-- and then keep all of the "commands.add_command" statements at the end of the file
commands.add_command("spawn_biter", "Spawns a nasty biter", spawn_biter)
