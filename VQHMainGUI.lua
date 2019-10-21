local events = {}
local groupRoster = {}
local groupSize = 0

-- Initialize
local MainFrame = CreateFrame('Frame', 'VQH_Main', UIParent)    
MainFrame:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...); -- call one of the functions above
end);

for k, v in pairs(events) do
    MainFrame:RegisterEvent(k); -- Register all events for which handlers have been defined
end

function events:ADDON_LOADED(...)
    pprint('loaded')
end

function events:PLAYER_LOGOUT(...)
    
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
    
        
end