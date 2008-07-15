

ULib = ULib or {}


ULib.VERSION = 2.21

ULib.ACCESS_ALL = "user"
ULib.ACCESS_OPERATOR = "operator"
ULib.ACCESS_ADMIN = "admin"
ULib.ACCESS_SUPERADMIN = "superadmin"
ULib.ACCESS_NONE = "none"
ULib.ACCESS_IMMUNITY = "immunity"

ULib.DEFAULT_ACCESS = ULib.ACCESS_ALL



ULib.DEVELOPER_MODE = false



ULib.TYPE_ANGLE = 1
ULib.TYPE_BOOLEAN = 2
ULib.TYPE_CHAR = 3
ULib.TYPE_ENTITY = 4
ULib.TYPE_FLOAT = 5
ULib.TYPE_LONG = 6
ULib.TYPE_SHORT = 7
ULib.TYPE_STRING = 8
ULib.TYPE_VECTOR = 9
ULib.TYPE_TABLE_BEGIN = 10 
ULib.TYPE_TABLE_END = 11
ULib.TYPE_NIL = 12



if SERVER then
ULib.UCL_LOAD_DEFAULT = true 
ULib.UCL_USERS = "ULib/users.txt"
ULib.UCL_GROUPS = "ULib/groups.txt"
ULib.UCL_REGISTERED = "ULib/misc_registered.txt" 
ULib.BANS_FILE = "ULib/bans.txt"

ULib.LISTEN_ACCESS = { id="", type="listen host", groups={"superadmin"}, acl={allow={"immunity"}, deny={}} }
ULib.DEFAULT_GRANT_ACCESS = { id="", type="guest", groups={"user"}, acl={allow={}, deny={}} }
end
