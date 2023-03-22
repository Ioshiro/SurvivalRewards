require "ISUI/ISCollapsableWindow"
local WINDOW_WID = 750
local WINDOW_HGT = 790
local OFFSET_X = 50
local OFFSET_Y = 50

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
WelcomeUI = ISCollapsableWindow:derive("WelcomeUI");

function WelcomeUI:initialise()
    ISCollapsableWindow.initialise(self);
    self:create();
end

function WelcomeUI:prerender()
    ISCollapsableWindow.prerender(self);
	self.chatText.text = getText("UI_welcome_message")
    self.chatText:paginate()
end

function WelcomeUI:render()
end

function WelcomeUI:create()
	self.chatText = ISRichTextPanel:new(0, 16, WINDOW_WID, WINDOW_HGT);
    self.chatText.marginRight = self.chatText.marginLeft;
    self.chatText:initialise();
    self:addChild(self.chatText);
    self.chatText.background = false;
    self.chatText.autosetheight = true;
    self.chatText.clip = true;
    self.chatText:addScrollBars();
end

function WelcomeUI:new()
    local o = {};
    o = ISCollapsableWindow:new(OFFSET_X, OFFSET_Y, WINDOW_WID, WINDOW_HGT);
    setmetatable(o, self);
    self.__index = self;
    o.variableColor={r=0.9, g=0.55, b=0.1, a=1};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.7};
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    o.zOffsetSmallFont = 25;
    o.moveWithMouse = false;

    return o;
end

function onCustomUIKeyPressed(key)
    if key == 21 then
        local WelcomeUI = WelcomeUI:new()
        WelcomeUI:initialise();
        WelcomeUI:addToUIManager();
    end
end

function onGameStart()
		local WelcomeUI = WelcomeUI:new()
        WelcomeUI:initialise();
        WelcomeUI:addToUIManager();
end
--Events.OnGameStart.Add(onGameStart)
Events.OnCustomUIKeyPressed.Add(onCustomUIKeyPressed)