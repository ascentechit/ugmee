--[[
	Title: Defines

	Holds some defines used on both client and server.
]]

ULib = ULib or {}


ULib.VERSION = 2.30

ULib.ACCESS_ALL = "user"
ULib.ACCESS_OPERATOR = "operator"
ULib.ACCESS_ADMIN = "admin"
ULib.ACCESS_SUPERADMIN = "superadmin"
ULib.ACCESS_NONE = "none"
ULib.ACCESS_IMMUNITY = "immunity"

ULib.DEFAULT_ACCESS = ULib.ACCESS_ALL

-- This variable defines whether we use our special client files in _cl_<version> or not.
-- Set it to true to use the scripts out of shared/ and client/, false to use scripts out if _cl_<version>/
ULib.DEVELOPER_MODE = true


--[[
	Section: Umsg Helpers

	These are ids for the ULib umsg functions, so the client knows what they're getting.
]]
ULib.TYPE_ANGLE = 1
ULib.TYPE_BOOLEAN = 2
ULib.TYPE_CHAR = 3
ULib.TYPE_ENTITY = 4
ULib.TYPE_FLOAT = 5
ULib.TYPE_LONG = 6
ULib.TYPE_SHORT = 7
ULib.TYPE_STRING = 8
ULib.TYPE_VECTOR = 9
ULib.TYPE_TABLE_BEGIN = 10 -- These following don't exist, we handle them ourselves
ULib.TYPE_TABLE_END = 11
ULib.TYPE_NIL = 12


--[[
	Section: UCL Helpers

	These defines are server-only, to help with UCL.
]]
if SERVER then
ULib.UCL_LOAD_DEFAULT = true -- Set this to false to ignore the SetUserGroup() call.
ULib.UCL_USERS = "ULib/users.txt"
ULib.UCL_GROUPS = "ULib/groups.txt"
ULib.UCL_REGISTERED = "ULib/misc_registered.txt" -- Holds access strings that ULib has already registered
ULib.BANS_FILE = "ULib/bans.txt"

ULib.LISTEN_ACCESS = { id="", type="listen host", groups={"superadmin"}, acl={allow={"immunity"}, deny={}} }
ULib.DEFAULT_GRANT_ACCESS = { id="", type="guest", groups={"user"}, acl={allow={}, deny={}} }
end
