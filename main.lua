function Initialize(Plugin)
	Plugin:SetName("ClickCommand")
	Plugin:SetVersion(0)
	
	cPluginManager:BindCommand("/bl",      "blockyland", HandleItem, "- ITEEEEM");
	
	cPluginManager:AddHook(cPluginManager.HOOK_SPAWNING_ENTITY, OnSpawningEntity);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick);
	
	PM = cPluginManager:Get()

	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	
	return true
end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
    if Player:GetInventory():GetEquippedItem().m_CustomName == "Servers" and Player:GetWorld():GetName() == "MG" then
        local WindowType  = cWindow.wtHopper
        local WindowSizeX = 5
        local WindowSizeY = 1
        
        local OnSlotChanged = function(Window, SlotNum)
            if SlotNum == 0 then
                PM:ExecuteCommand(Player, "/warp MG")
            elseif SlotNum == 1 then
                PM:ExecuteCommand(Player, "/warp survival")  
            elseif SlotNum == 2 then
                PM:ExecuteCommand(Player, "/warp skyblock")
            elseif SlotNum == 3 then
                PM:ExecuteCommand(Player, "/warp creative")
            elseif SlotNum == 4 then
                PM:ExecuteCommand(Player, "/warp parkour")
            end  
            Player:CloseWindow()         
        end
        
        local Window = cLuaWindow(WindowType, WindowSizeX, WindowSizeY, "TestWnd")
        local Item1 = cItem(E_ITEM_SNOWBALL)
        local Item2 = cItem(E_ITEM_DIAMOND_PICKAXE)
        local Item3 = cItem(E_BLOCK_GRASS)
        local Item4 = cItem(E_BLOCK_EMERALD_BLOCK)
        local Item5 = cItem(E_BLOCK_FENCE)
        Item1.m_CustomName = "Minijuegos/Minigames"
        Item2.m_CustomName = "Survival"
        Item3.m_CustomName = "SkyBlock"
        Item4.m_CustomName = "Creative"
        Item5.m_CustomName = "Parkour"
        Window:SetSlot(Player, 0, Item1)
        Window:SetSlot(Player, 1, Item2)
        Window:SetSlot(Player, 2, Item3)
        Window:SetSlot(Player, 3, Item4)
        Window:SetSlot(Player, 4, Item5)
        Window:SetOnSlotChanged(OnSlotChanged)
        
        Player:OpenWindow(Window)
        
        GCOnTick = 10
        
        return true
    end
end    

function HandleItem(Split, Player)
    Item = cItem(E_ITEM_DIAMOND)
    Item.m_CustomName = "Servers"
    Player:GetInventory():AddItem(Item)
    return true
end

function OnSpawningEntity(World, Entity)
    if Entity:IsPickup() and World:GetName() == "MG" then
        Pickup = tolua.cast(Entity, "cPickup")
        name = Pickup:GetItem().m_CustomName
        if name == "Minijuegos/Minigames" or name == "Survival" or name == "SkyBlock" or name == "Creative" or name == "Parkour" then
            return true
        end
    end
end

function OnDisable()
    local EachPlayer = function(Player)
        Player:CloseWindow()
    end
    cRoot:Get():ForEachPlayer(EachPlayer)
end    
