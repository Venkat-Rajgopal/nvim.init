-- Machine-specific choices. The Raspberry Pi uses lighter tools (see README-pi.md).
local file = io.open("/proc/device-tree/model", "r")
local model = file and file:read("*a") or ""
if file then
  file:close()
end

return {
  is_pi = model:find("Raspberry Pi", 1, true) ~= nil,
}
