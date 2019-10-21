local events = {}
local groupRoster = {}
local groupSize = 0

local MSG_PREFIX = 'VQH_MSG'
local MSG_REQUEST = 'VQH_REQUEST'

function events:ADDON_LOADED(...)
    pprint('loaded')
end

successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix(MSG_PREFIX)

function events:CHAT_MSG_ADDON(...)
    dprint("CHAT_MSG_ADDON received")
    local prefix = select(1,...)
    if (prefix == MSG_PREFIX) then
        for i = 1, select('#',...) do
            local v = select(i,...)
            dprint(tostring(v))
        end
    end
end

function events:GROUP_ROSTER_UPDATE(...)
    -- if we get an update event, check if we're in a group
    dprint('GROUP_ROSTER_UPDATE event received')
    if (isInGroup()) then
        -- check if roster changed
        if (hasRosterChanged()) then      
            UpdateQuests()
        end
    end
end

function hasRosterChanged() 
    -- check if count of players changed
    local currCount = table.getn(roster)
    dprint('hasRosterChanged Old/New Player count:'..groupSize.."/"..currCount)
    if (currCount ~= groupSize) then
        return true
    end

    -- check if any player names are different
    local groupChanged = false
    local debugString = ""
    for k, _ in pairs(events) do
        debugString=debugString..k.." "
        if (not table.containskey(groupRoster)) then
            groupChanged = true
        end
    end
    dprint("hasRosterChanged Group Size: "..groupSize.." Roster: "..debugString.." Changed: "..tostring(groupChanged))

    return groupChanged
end

function UpdateQuests()
    pprint('updating quests from group')

    -- set local variables groupsize & roster keys
    groupSize = GetNumGroupMembers()
    groupRoster = {}

    -- send out request for quest info
    success = C_ChatInfo.SendAddonMessage(MSG_PREFIX, MSG_REQUEST, "PARTY")
    dprint('UpdateQuests - SendAddonMessage: '..tostring(success))
end

-- Initialize
local MainFrame = CreateFrame('Frame', 'VQH_Main', UIParent)    
MainFrame:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...); -- call one of the functions above
end);

for k, v in pairs(events) do
    MainFrame:RegisterEvent(k); -- Register all events for which handlers have been defined
end