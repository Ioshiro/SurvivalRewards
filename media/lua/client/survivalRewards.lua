require "scripts/item_Rewards.txt"

local rewards = {}
rewards[1] = {"Base.Wallet"}
rewards[2] = {"Base.Wallet2"}
rewards[3] = {"Base.Wallet3"}
rewards[4] = {"Base.Wallet4"} 
rewards[5] = {"Base.Spiffo"}
rewards[6] = {"Rewards.NightstickS" , "Rewards.CrowbarS" , "Rewards.MeatCleaverS" , "Rewards.NightstickS" , "Rewards.MeatCleaverS"}
rewards[7] = {"MoneyToXP.MoneyStak" ,  "Rewards.LongJohnsFrodoL"}
rewards[8] = {"Rewards.SledgehammerS" , "Rewards.Machete20D" , "Rewards.Katana20D" , "Rewards.Machete20D" , "Rewards.Machete20D"}
rewards[9] = {"Rewards.Machete50D" , "Rewards.Katana50D"  , "Rewards.LongJohnsFrodoH" }
rewards[10] = {"Base.SpiffoBig" ,  "Rewards.Katana50D" , "Rewards.Jacket_PaddedRep" , "Base.SpiffoBig" }
rewards[11] = {"Base.SpiffoBig" , "Rewards.SpearMacheteS" , "Rewards.LongJohnsFrodoH" , "Base.SpiffoBig"}
rewards[12] = {"Rewards.Katana50D"}
rewards[13] = {"Rewards.Machete100D" , "Rewards.LongJohnsFrodoS" , "Rewards.SpearMacheteS"}
rewards[14] = {"Base.Money"}
rewards[15] = {"Rewards.SpearMacheteS"}
rewards[16] = {"Rewards.Machete100D" , "Rewards.LongJohnsFrodoS"}
rewards[17] = {"Rewards.Katana100D"}
rewards[18] = {"MoneyToXP.MoneyBriefCase"}
rewards[19] = {"Base.KatePic"}

local killRewards = {}
killRewards[1] = {"Base.Wallet"}
killRewards[2] = {"Base.Wallet2"}
killRewards[3] = {"Base.Wallet3"}    
killRewards[4] = {"Base.Wallet4"}         
killRewards[5] = {"Base.Spiffo"}               
killRewards[6] = {"MoneyToXP.XPMoneyStack"}
killRewards[7] = {"MoneyToXP.XPMoneyStack"}   
killRewards[8] = {"Base.SpiffoBig"}
killRewards[9] = {"Base.SpiffoBig"}
killRewards[10] = {"Base.Money"}
killRewards[11] = {"MoneyToXP.MoneyBriefCase"}
killRewards[12] = {"Base.KatePic"}

local rewardMultiplier = {}
rewardMultiplier["Base.Money"] = 300
rewardMultiplier["Base.ShotgunShellsBox"] = 2
rewardMultiplier["Base.Staples"] = 1
rewardMultiplier["Base.NailsBox"] = 1
rewardMultiplier["Base.Wallet"] = 1
rewardMultiplier["Base.Wallet2"] = 2
rewardMultiplier["Base.Wallet3"] = 3
rewardMultiplier["Base.Wallet4"] = 4

hourMilestones = {24, 48, 72, 96, 120, 144, 168, 336, 504, 672, 840, 1008, 1176, 1344, 1512, 1680, 1848, 2016, 8736}
killMilestones = {100, 200, 300, 400, 500, 1000, 2000, 3000, 4000, 5000, 10000, 20000}

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