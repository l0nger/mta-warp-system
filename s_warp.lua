
local warps=nil

-- functions
local function loadTheWarps()
	warps={}
	local xml=xmlLoadFile("warpy.xml")
	if not xml then return end -- zabezpieczenie przed "brakiem pliku"/nieznalezieniem pliku
	local xmlNode=xmlNodeGetChildren(xml)

	for i, node in pairs(xmlNode) do
		warps[i]={
			name=tostring(xmlNodeGetAttribute(node, "name")),
			x=xmlNodeGetAttribute(node, "x"),
			y=xmlNodeGetAttribute(node, "y"),
			z=xmlNodeGetAttribute(node, "z"),
			dim=xmlNodeGetAttribute(node, "dim"),
			int=xmlNodeGetAttribute(node, "int"),
		}
	end
	outputDebugString("[WARPS]: Loaded " .. #warps .. " warps.")
	xmlUnloadFile(xml)
end

-- events
addEventHandler("onResourceStart", resourceRoot, loadTheWarps)
addEventHandler("onResourceStop", resourceRoot, function()
	warps=nil
end)

-- commands
addCommandHandler("lista-warpow", function(plr, cmd)
	if not warps then 
		outputChatBox("Wystapil blad, prosimy sprobowac pozniej.", plr)
		return
	end

	local tmpWarps={}
	for i,v in pairs(warps) do
		tmpWarps[i]=v.name
	end
	tmpWarps=table.concat(tmpWarps, " ")
	outputChatBox(tmpWarps, plr)
end)

addCommandHandler("warp", function(plr, cmd, warpName)
	if not warpName then
		outputChatBox("Blad! Podany warp nie istnieje. Wpisz /lista-warpow, aby sprawdzic liste wszystkich warpow.", plr)
		return
	end

	local foundedWarp=0
	for i,v in pairs(warps) do
		if v.name==warpName then
			foundedWarp=i
			break
		end
	end

	if foundedWarp~=0 then
		local curWarp=warps[foundedWarp]
		outputChatBox(("Teleportowanie do %s."):format(curWarp.name))
		fadeCamera(plr, false)

		setTimer(function(plr, v)
			setElementPosition(plr, v.x, v.y, v.z)
			setElementDimension(plr, v.dim)
			setElementInterior(plr, v.int)
			fadeCamera(plr, true)
		end, 2500, 1, plr, curWarp)
	else
		outputChatBox("Nie znaleziono teleportu. Aby sprawdzic listę wszystkich warpów wpisz /lista-warpow", plr)
	end
end)

addCommandHandler("reload-warp", function(plr, cmd)
	--[[
	Dla korzystajacych z uprawnien ACL i wbudowanego mechanizmu kont.

	local accountName=getAccountName(getPlayerAccount(plr)) or "none"
	if not isObjectInACLGroup("user." .. accountName, aclGetGroup("Admin")) then
		-- outputChatBox("Brak uprawnien.")
		return
	end
	]]

	warps=nil
	loadTheWarps()
	outputChatBox("Pomyslnie przeladowano warpy (obecnie: ".. #warps .. ")", plr)
end)

addCommandHandler("add-warp", function(plr, cmd, warpName)
	--[[
	Dla korzystajacych z uprawnien ACL i wbudowanego mechanizmu kont.

	local accountName=getAccountName(getPlayerAccount(plr)) or "none"
	if not isObjectInACLGroup("user." .. accountName, aclGetGroup("Admin")) then
		-- outputChatBox("Brak uprawnien.")
		return
	end
	]]

	if not warpName then
		outputChatBox("Blad! Nie wpisano nazwy warpu.", plr)
		return
	end

	local x,y,z=getElementPosition(plr)
	local int,dim=getElementInterior(plr), getElementDimension(plr)

	local xml=xmlLoadFile("warpy.xml")
	if not xml then return end

	--[[
		@todo: wpisywanie do pliku
	]]
	xmlSaveFile(xml)
	xmlUnloadFile(xml)

	warps=nil
	loadTheWarps()
	outputChatBox("Stworzono warp: " .. warpName .. ".", plr)
end)
