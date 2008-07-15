Title: ULib Readme

*ULib v2.30 (released 00/00/00)*

ULib is a developer library for GMod 10 (<http://garrysmod.com/>).

ULib provides such features as universal physics, user access lists, and much, much more!

Visit our homepage at <http://ulyssesmod.net/>.

You can talk to us on our forums at <http://forums.ulyssesmod.net/> or in IRC at irc.gamesurge.net in #ulysses.

Group: Author

ULib is brought to you by..

* Brett "Megiddo" Smith - Contact: <megiddo@ulyssesmod.net>
* JamminR - Contact: <jamminr@ulyssesmod.net>
* Spbogie - Contact: <spbogie@ulyssesmod.net>

Group: Requirements

ULib requires a working copy of garrysmod 10, and that's it!

Group: Installation

To install ULib, simply extract the files from the archive to your garrysmod/addons folder.
When you've done this, you should have a file structure like this--
<garrysmod>/addons/ulib/lua/ULib/init.lua
<garrysmod>/addons/ulib/lua/ULib/server/util.lua
<garrysmod>/addons/ulib/lua/autorun/ulib_init.lua
<garrysmod>/addons/ulib/data/ULib/users.txt
etc..

Please note that installation is the same on dedicated servers.

You absolutely, positively have to do a full server restart after installing the files. A simple map
change will not cut it!

Group: Usage

Server admins do not "use" ULib, they simply enjoy the benefits it has to offer. 
After installing ULib correctly, scripts that take advantage of ULib will take care of the rest. 
Rest easy!

Group: Changelog
v2.30 - *(00/00/00)*
	* [FIX] Umsgs being sent too early in certain circumstances.
	
v2.21 - *(06/08/08)*
	* [ADD] Support for client/server-side only modules. 
	* [FIX] Bug in ULib.tsay that would incorrectly print to console if the target player was disconnecting.
	* [FIX] Makes sure that prop protectors don't take ownership of props using physgun reload while a prop is unmovable.
	* [CHANGE] ULib.getUsers now returns multiple users on an asterisk "*" when enable_keywords is true. "<ALL>" can still be used. (Thanks Kyzer)


v2.20 - *(01/26/08)*
	* [ADD] ULib now has three shiny new hooks to let you know about client initialization and a new hook to signal a player name change.
	* [FIX] A possible bug in the physics helpers.
	* [CHANGE] Various things to bring ULib into new engine compatibility.
	* [CHANGE] Removed all timers dealing with initialization and now rely on flags from the client. This makes the ULib initialization much more dependable.
        * [CHANGE] Converted all calls from ULib.consoleCommand( "exec ..." ) to ULib.execFile() to avoid running into the block on "exec" without our module.
	* [REMOVE] Removing the module for now, might re-appear in the next version


v2.10 - *(09/23/07)*
	* [ADD] New hook library. Completely backwards compatible, but can now do priorities. (Server-side only)
	* [ADD] ULib.parseKeyValues, ULib.makeKeyValues
	* [ADD] ULib.getSpawnInfo, ULib.Spawn - Enhanced Spawn... will replace original health/armor when called if getSpawnInfo called first.
	* [ADD] READDED hexing system to get around garry's ConCommand() blocks. So much is now blocked that it's interferring with normal ULX operations.
	* [ADD] Our server module again. This time with only console-executing abilities. This is because garry has blocked much of what we need. Source is included.
	* [ADD] Custom ban list to store temp bans and additional ban info. Permanent bans are still stored in banned_user.cfg, and the two lists are synchronized.
	* [FIX] Can now query players from client side.
	* [FIX] An exploit in DisallowDelete() that allowed players to still remove the props
	* [FIX] Various initialization functions trying to access a disconnected player
	* [FIX] ULib.csay() sending umsgs to invalid players.
	* [FIX] UCL by clantag not working.
	* [CHANGE] Big changes in ucl.query() and concommand functions. Probably won't be backwards compatible.
	* [CHANGE] UCL now uses our new keyvalues functions. It should be backwards compatible with your old data, but we make no promises. If you're having trouble with it, try starting from scratch.
	* [CHANGE] ULib.tsay has a wait parameter to send on next frame
	* [CHANGE] subconcommands are now case insensitive
	* [CHANGE] Csay's now have fade.
	* [CHANGE] DisallowSpawning() now implements SpawnObject. For example, people can't sit and precache props while in the ulx jail.
	* [CHANGE] Say commands are now case insensitive and default to needing a space between command and arg (can flag to use old behavior though)
	* [CHANGE] ULib.ban, and ULib.kickban now accept additional information and pass data to ULib.addBan.
	* [CHANGE] Immunity is now an access string instead of a group
	* [CHANGE] Overcoming immunity is no longer bound to superadmins
	* [CHANGE] Increased performance of UCL.
	* [REMOVED] The vgui panels, derma is the vgui of choice now.

v2.05 - *(06/19/07)*
	* [ADD] ply:SetUserGroup() -- Thanks aVoN!
	* [ADD] ply:DisallowVehicles( bool )
	* [FIX] A timer error in UCL, was messing up scoreboard sometimes.
	* [FIX] Security hole where exploiters could gain superadmin access
	* [CHANGE] You can assign allow/denies to the default user group, "user" now. (IE, allow guests to slap)
	* [CHANGE] DisallowSpawning now disallows tools that can spawn things.
	* [REMOVED] Old settings/users.txt stuff, handled by SetUserGroup now

v2.04 - *(05/05/07)*
	* [ADD] ULib.isSandbox
	* [ADD] Player/ent hooks DisallowMoving, DisallowDeleting, DisallowSpawning, DisallowNoclip
	* [ADD] Some vgui libs (URoundButton, URoundMenu)
	* [FIX] Double printing in console.
	* [CHANGE] Implemented garry's "proper" way of including c-side files.
	* [CHANGE] Implemented client side UCL
	* [CHANGE] Now in addon format
	* [CHANGE] Slapping noclipped players will take them out of noclip to prevent them flying very far out of the world
	* [CHANGE] Improved the umsg send/receive functions
	* [REMOVED] Hexing system to get around garry's ConCommand() blocks. Very little is blocked now.
	* [REMOVED] Dll, MOTD functionality is handled by ULX now.

v2.03 - *(01/10/07)*
	* [ADD] ULib module, has functions for motd, concommands, and downloading files. SOURCE CODE!
	* [FIX] Player slap after dead problem.

v2.02 - *(01/07/07)*
	* [ADD] New system for giving files to clients. Strips comments and puts them in a separate folder.
	* [FIX] Autocompletes aren't handled so hackishly now. This should fix some occasional errors.
	* [FIX] Lots of general fixes.

v2.01 - *(01/02/07)*
	* [FIX] Importing from garry's default user file.
	* [FIX] All users receiving "you do not have access" message.

v2.0 - *(01/01/07)*
	* Initial version for GM10

Group: Developers

To all developers, I sincerely hope you enjoy what ULib has to offer!
If you have any suggestions, comments, or complaints, please tell us at <http://forums.ulyssesmod.net/>.

If you want an overview of what's in ULib, please visit the documentation at <http://ulyssesmod.net/docs/>

All ULib's functions are kept in the table "ULib" to prevent conflicts.

Revisions are kept in the function/variable documentation. If you don't see revisions listed, it hasn't changed since v2.0

If you write a script taking advantage of ULib, stick the init script inside ULib/modules. ULib will load your script after
ULib loads, and will send it to and load it on clients as well.

Some important quirks developers should know about --
* autocomplete - You have to define the autocomplete on the client, so if you pass a string for autocomplete to ULib.concommand,
it will assume you mean a client function. There's also a delay in the sending of these to the client.

Group: Credits

Thanks to JamminR, who is always there to offer help and advice to those who need it.

Group: License

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to 
Creative Commons
543 Howard Street
5th Floor
San Francisco, California 94105
USA
