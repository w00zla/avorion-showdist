# showdist

### DESCRIPTION:
This mod delivers you two commands which can be used to display the distance of the player to certain locations, measured in sectors.
Those locations can either be the center/core of the galaxy, the home sector of the player or a user-defined sector.
This may be usefull for different things like finding bosses or planning some trading- and jump-routes ;)

## FEATURES:
### Commands:


**/showdist**

Shows distance of player to defined location in chat window.

*Usage:*

`/showdist center`

`/showdist home`

`/showdist home <PLAYER>`

`/showdist sector <XXX:YYY>`

`/showdist sector <XXX:YYY> <NAME>`


**/showdistjump**

Shows distance to registered locations after each jump as notifications.
You can register multiple locations which will all be shown after jumps!

*Usage:*

`/showdistjump center`

`/showdistjump home`

`/showdistjump home <PLAYER>`

`/showdistjump sector <XXX:YYY>`

`/showdistjump sector <XXX:YYY> <NAME>`

`/showdistjump off`


__*Parameters:*__

`<PLAYER>` = name or index of existing player

`<XXX:YYY>` = coordinates value *(like "321:456" or "12:-34")*

`<NAME>` = name value *(like "Trade1" or "SomeSector", no spaces)*


## INSTALLATION:
Download the ZIP file of the [latest release](https://github.com/w00zla/avorion-showdist/releases) and extract it to `<Avorion>\data\` directory, like with other mods.

No vanilla script files will be overwritten, so there should be no problem with other mods or file changes due to game updates!

__*Multiplayer:*__ This mod is **server-side only**, so no files have to be installed on clients for multiplayer games.


### Changelog:

**v0.4**

- added possibility to show/register distance to any existing player's home-sector
- fixed problem with negative and reversed coordinates
- the `/showdistjump` command now remembers registered locations over saves and loads (you must use the `/showdistjump off` command now to get rid of the notifications!) 

**v0.3**

- added possibilty to also define a name for user-defined sectors
- improved output of `/help showdist` and `/help showdistjump` commands
- minor changes and code comments

**v0.2**

- added possibility to register multiple user-defined sectors with `/showdistjump` command
