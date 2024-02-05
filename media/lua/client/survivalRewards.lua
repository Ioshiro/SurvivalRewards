require "scripts/item_Rewards.txt"

local rewards = {}
rewards[1] = {"Base.Wallet"}
rewards[2] = {"Base.Wallet2"}
rewards[3] = {"Base.Wallet3"}
rewards[4] = {"Base.Wallet4"} 
rewards[5] = {"MoneyToXP.Droga1"}
rewards[6] = {"MoneyToXP.Droga2"}
rewards[7] = {"MoneyToXP.Droga3"}
-- 1 mese
rewards[8] = {"Base.Spiffo" }

--2 mesi
rewards[9] = {"MoneyToXP.Droga4"}
--3 mesi
rewards[10] = {"MoneyToXP.Rotolo"}
--4 mesi
rewards[11] = {"MoneyToXP.Mazzetta"}
--5mesi
rewards[12] = {"Base.SpiffoBig"}
--6mesi
rewards[13] = {"MoneyToXP.Droga5"}
--7mesi
rewards[14] = {"MoneyToXP.Valigetta5"}
--8mesi
rewards[15] = {"MoneyToXP.Valigetta10"}
--1anno
--rewards[16] = {"???"}



local killRewards = {}
--100
killRewards[1] = {"Base.Wallet"}
--200
killRewards[2] = {"Base.Wallet2"}
--300
killRewards[3] = {"Base.Wallet3"} 
--400   
killRewards[4] = {"Base.Wallet4"} 
--500        
killRewards[5] = {"Base.Money"} 
--1000              
killRewards[6] = {"Base.Spiffo"} 
--2000
killRewards[7] = {"MoneyToXP.Rotolo"}  
--3000  
killRewards[8] = {"MoneyToXP.Mazzetta"} 
--4000
killRewards[9] = {"Base.SpiffoBig"} 
--5000
killRewards[10] = {"SOMWReward.SRewardKnife,SOMWReward.SRewardCleaver,SOMWReward.SRewardHammer,MoneyToXPValigetta2000"} 
-- --10000
killRewards[11] = {"SOMWReward.SRewardHammer,SOMWReward.SRewardHandAxe,MoneyToXPValigetta5000"}
--20000
killRewards[12] = {"SOMWReward.SRewardCleaver,Rewards.SOMWReward.SRewardBaseballBat,SOMWReward.SRewardHandAxe"}
-- --30000
killRewards[13] = {"SOMWReward.SRewardHandAxe,SOMWReward.SRewardAxe,Rewards.SOMWReward.SRewardBaseballBat"}
-- --40000
killRewards[14] = {"Rewards.SOMWReward.SRewardBaseballBat,Rewards.SOMWReward.SRewardSpear,SOMWReward.SRewardAxe"}
-- --50000
killRewards[15] = {"SOMWReward.SRewardAxe,SOMWReward.SRewardMachete,SOMWReward.SRewardSpear,SOMWReward.SRewardSpear"}
-- --100000
killRewards[16] = {"SOMWReward.SRewardKatana"}


local rewardMultiplier = {}

rewardMultiplier["MoneyToXP.Rotolo"] = 4
rewardMultiplier["Base.Money"] = 50
rewardMultiplier["Base.Wallet"] = 1
rewardMultiplier["Base.Wallet2"] = 2
rewardMultiplier["Base.Wallet3"] = 3
rewardMultiplier["Base.Wallet4"] = 4

hourMilestones = {
	--1 giorno
	24,
	--2 giorno
	48,
	--3 giorno
	72,
	--4 giorno
	96, 
	--5 giorno
	120,
   --6 giorno
	144,
    --7 giorno
	168,
    --28 1 mese
	672,
	--56 2 mesi
	1344,
	-- 3 mesi
	2016,
	-- 4 mesi 
	2688,
	--5mesi
	3360,
	--6mesi
	4032,	
	--7mesi
	4704,	
	--8 mesi
	5376,
	-- 1 anno
	8736}
	
	
killMilestones = {100, 200, 300, 400, 500, 1000, 2000, 3000, 4000, 5000, 10000, 20000, 30000, 40000, 50000, 100000}

local function giveReward(player, rewardType)
	
	local reward
	local item
	if rewardType == "survival" then
		reward = rewards[player:getModData().milReached + 1][ZombRand(#rewards[player:getModData().milReached + 1]) + 1]
		item = instanceItem(reward)
		player:Say(getText("UI_received_reward_start") .. item:getDisplayName() .. getText("UI_received_reward_end"))
		player:getModData().milReached = player:getModData().milReached + 1
	elseif rewardType == "kill" then
		reward = killRewards[player:getModData().kilMilReached + 1][ZombRand(#killRewards[player:getModData().kilMilReached + 1]) + 1]
		item = instanceItem(reward)
		player:Say(getText("UI_received_kill_reward_start") .. item:getDisplayName() .. getText("UI_received_kill_reward_end"))
		player:getModData().kilMilReached = player:getModData().kilMilReached + 1
	end
	
	if rewardMultiplier[reward] then
		player:getInventory():AddItems(item, rewardMultiplier[reward])
	else
		player:getInventory():AddItem(item)
	end
end

local function EveryTenMinutes()
	local player = getPlayer()
	
	if player and player:isAlive() then 	
		if player:getModData().milReached == nil then
			player:getModData().milReached = 0
		end
		if player:getModData().kilMilReached == nil then
			player:getModData().kilMilReached = 0
		end
		
		local alivefor = player:getHoursSurvived()
		local zKills = player:getZombieKills()
		
		if player:getModData().milReached < #hourMilestones and alivefor >= hourMilestones[player:getModData().milReached + 1] then 
			giveReward(player, "survival")
		end
		
		if player:getModData().kilMilReached < #killMilestones and zKills >= killMilestones[player:getModData().kilMilReached + 1] then
			giveReward(player, "kill")
		end
	end
end



local function OnPlayerDeath(player)
	player:getModData().milReached = 0
	player:getModData().kilMilReached = 0
end

local function OnLoad()
	Events.EveryTenMinutes.Add(EveryTenMinutes)
	Events.OnPlayerDeath.Add(OnPlayerDeath)
end

Events.OnLoad.Add(OnLoad)