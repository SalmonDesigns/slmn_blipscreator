local PlayerData
local PlayerJob

local createdBlips = {}

Citizen.CreateThread(function()
	if Config.Framework == 'qbcore' then
		QBCore = exports['qb-core']:GetCoreObject()
	end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	local Player = QBCore.Functions.GetPlayerData()
	PlayerJob = Player.job
	Wait(500)
	loadBlips()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
	PlayerJob = JobInfo
	for k,v in pairs(createdBlips) do
		RemoveBlip(v)
	end
	Wait(500)
	loadBlips()
end)

function loadBlips()
    print(getJob())
    for k,v in pairs(Config.Blips) do
        local canSee = false

        if v.JobLock and not IsJobAllowed(v.AllowedJobs) then
            canSee = false
        else
            canSee = true
        end

        if canSee then
            local blip = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
            SetBlipSprite(blip, v.Blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.Blip.size)
            SetBlipColour(blip, v.Blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.Blip.name)
            EndTextCommandSetBlipName(blip)
            table.insert(createdBlips, blip)
        end
    end
end

function IsJobAllowed(allowedJobs)
    local playerJob = getJob()
    
    for _, job in ipairs(allowedJobs) do
        if playerJob == job then
            return true
        end
    end

    return false
end

function getJob()
	if Config.Framework == 'qbcore' then
		local Player = QBCore.Functions.GetPlayerData()
		PlayerJob = Player.job
		return PlayerJob.name
	end
end
