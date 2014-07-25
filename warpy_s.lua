
warpy = {}




addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
function (  )

local xml = xmlLoadFile("warpy.xml") -- ladujemy warpy z pliku xml
local xmlNode = xmlNodeGetChildren(xml)

for i, node in ipairs(xmlNode) do
local name = xmlNodeGetAttribute(node,"name")
local x = tonumber(xmlNodeGetAttribute(node,"x"))
local y = tonumber(xmlNodeGetAttribute(node,"y"))
local z = tonumber(xmlNodeGetAttribute(node,"z"))
local d = tonumber(xmlNodeGetAttribute(node,"dimension"))
local i = tonumber(xmlNodeGetAttribute(node,"interior"))

table.insert(warpy, name)
warpy[2] = x
warpy[3] = y
warpy[4] = z
warpy[5] = d
warpy[6] = i
end
xmlUnloadFile(xml)
end)


addCommandHandler("warps",
function ( )
for k,v in ipairs (warpy) do
outputChatBox("Warpy: "..v[1].."", source) -- jesli warpow bedzie za duzo nie wyswietli wiadomosci, bo bedzie za dluga, niestety nie wiem zbytnio jak to naprawic
end
end)



addCommandHandler("warp",
function ( plr, cmd, warp )

if not warp then
outputChatBox("Poprawna forma: /warp nazwawarpu  Lista warpów znajduje się pod komendą /warps", plr)
return end

for k,v in ipairs(warpy) do
if v ~= warp then return end

outputChatBox("Teleportowanie do "..v[2].."", plr)
setElementDimension(plr, v[5])
setElementInterior(plr, v[6])
setElementPosition(plr, v[2], v[3], v[4])
end
end)

