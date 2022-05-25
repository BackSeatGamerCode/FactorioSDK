# FactorioSDK
The Official Factorio SDK for BackSeatGamer Integration 

## Setup
Integration will only work if this mod is run on a server. You should never attempt to run two instances of Factorio on your machine if both instances are installed, and write save/mod data to the same location.
This is a surefire way to get file corruption.

To get around this, download the Windows .zip version if you are running Windows. You can think of the server as a containerized version this way. If you run the executable (located under `bin/x64`) and the executable is an installer, you have downloaded the wrong thing. It should launch an instance of Factorio on run.

**IMPORTANT FOR STEAM USERS**: You can click the `Log In` link, and then the button to log in with Steam. This will allow you to download another copy without having to pay again.

Once you have your new Factorio instance downloaded, move it to a place you will remember. This folder will contain everything, including mods and save (unlike the installed version which saves that to `%appdata%`). Finally, start a new game and save it, and remember the name. I generally like to use the name `Server`, however, the name is up to you. Once the game is saved, close Factorio.

Next, locate the `bin/x64` (`x64` may be different depending on your Operating System and Architecture) folder in terminal (or create a bash/batch script) and run the following command
```bash
factorio.exe --start-server [save name].zip --rcon-port 29175 --rcon-password factory
```

If you change the port from `29175` or the password from `factory`, remember this as you will need it when we get to the BackSeatGamer step.

If you are using Windows PowerShell, you may need to replace `factorio.exe` with `.\factorio.exe` or `./factorio.exe`.

The server does not generally take long to start up. The following lines are the last few lines of the console output you will see when startup is complete:
```
   2.529 Hosting game at IP ADDR:({0.0.0.0:34197})
   2.530 Info HttpSharedState.cpp:54: Downloading https://auth.factorio.com/generate-server-padlock-2?api_version=4
   3.080 Info AuthServerConnector.cpp:78: Obtained serverPadlock for serverHash (Aa9jlOPnrQTw2fx2n340Z0JaJcmLcrAK) from the auth server.
   3.082 Info ServerMultiplayerManager.cpp:796: updateTick(47567) changing state from(CreatingGame) to(InGame)
   3.084 Info RemoteCommandProcessor.cpp:130: Starting RCON interface at IP ADDR:({0.0.0.0:29175})
```

The first line in this group, `2.529 Hosting game at IP ADDR:({0.0.0.0:34197})` provides information on how to connect to the server. To join, simply run your normal/installed instance of Factorio, and select "Multiplayer" from the main menu. Click "Connect to Address", and enter `127.0.0.1:[port]`, where `[port]` is the five digit number after the colon in the line. In my case, this number is `34197`, so I would enter `127.0.0.1:34197`.

You will not be able to connect to the server unless your mods folder is an exact match of the server's mods folder. Factorio can mostly resolve conflicts automatically, but because your mod is in development, you will manually need to copy it from the server mods folder to your regular mods folder. I have found it easier to do all of my development in a single player game, and then deploy to a server for testing. This does speed up the workflow.

Copy the Factorio SDK folder to the mods folder of whichever instance you decide to work in (feel free to fork the repo and clone the instance to this location). 

Once copped, open the directory and edit the `info.json` file. Feel free to edit any attribute in this file, and make the mod your own (no credit is necessary). The important thing to note is that the name needs to be lowercase, and spaces should be replaced with dash (`-`) characters. The name of the folder of your mod will need to reflect these changes. It must be in the format `[name]_[version]`. For example, the default name and version is `bsg-example-mod`, and `0.0.1`, respectively, so the directory name will become `bsg-example-mod_0.0.1`.

Finally, the mod thumbnail (`thumbnail.png`) is the BackSeatGamer race car logo by default. Feel free to replace this with your own image.

## Usage
The Factorio SDK works with RCON. What this means is that the BackSeatGamer Reverse Proxy and, by extension, BackSeatGamer server, sends Factorio commands as the command of each reward. For example, if a reward command is `test`, when the command is sent to Factorio, Factorio will attempt to execute the console command `/test` (note that the slash prefix is only added if it is not included, so a reward command of `test` and `/test` will both be executed as `/test`)

So, to add an action for a reward, you simply register a new Factorio console command! If this seems confusing, hopefully this example will help clarify.

New Factorio commands can be declared in `control.lua`. In the example mod, the default contents of `control.lua` (with the comments omitted) is as follows:
```lua
function spawn_biter()
	game.surfaces.nauvis.create_entity({name="small-biter", position=game.players[1].position}) 
end

commands.add_command("spawn_biter", "Spawns a nasty biter", spawn_biter)
```

This code will create a new Factorio command called `spawn_biter`, which can be invoked by the console command `/spawn_biter`. When executed, it will spawn a small biter at the location of the first player in the server (or the only player in a single-player game).

When setting up this reward on the BackSeatGamer server, simply make the command `spawn_biter`, and when the reward is redeemed, BackSeatGamer will execute the Factorio command `/spawn_biter` which will spawn the biter.

The `commands.add_command` takes three arguments. The first is the name of the command which is used to invoke it. If this were `test`, then to execute it, we would need to issue the console command `/test` in game. The second argument is to provide help text for the command (displayed when the player issues `/h spawn_biter`). The final argument is the name of the function to execute when the command is run. If in the first line, I had named the function `my_func`, then this argument would need to be `my_func` instead (**NOTE**: Do not surround the last argument with quotes). Best practice is to define each of your functions first, and then keep all of the `commands.add_command` statements at the end of the file.

To test lua commands in game, you can simply issue the console command `/c [lua code]`. Technically, you could create a reward with this value and the lua code would be executed, however, this is not advised due to the character limit of reward commands.

## Factorio Modding Resources
- https://lua-api.factorio.com/latest/
- https://forums.factorio.com/viewforum.php?f=14
- https://discord.gg/factorio

## Issues/Feedback
If you encounter any problems, or have suggestions for future updates, feel free to leave them over in the [Issue Tracker](https://github.com/BackSeatGamerCode/FactorioSDK/issues). Alternatively, if you have questions or want to discuss something with your fellow OpenRCT2 modders, then check out our [Discussions](https://github.com/BackSeatGamerCode/FactorioSDK/discussions). Thank you for using OpenRCT2 modding SDK, and good luck with your mod!