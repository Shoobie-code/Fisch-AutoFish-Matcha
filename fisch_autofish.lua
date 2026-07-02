local B = game:GetService("Players");
local j = game:GetService("RunService");
local function i()
	return B.LocalPlayer;
end;
if type(setrobloxinput) == "function" then
	setrobloxinput(true);
end;
pcall(function()
	mouse1release();
end);
if type(memory_read) ~= "function" then
	notify("Enable Unsafe LuaU in Matcha \226\128\148 memory reads required.", "AutoFish", 6);
end;
local G = {
		cast_mode = "long",
		cast_power_custom = 96.0,
		cast_timeout_ms = 12000,
		post_cast_delay_ms = 150,
		post_catch_delay_ms = 400,
		cast_on_timeout = true,
		shake_interval_ms = 15,
		completion_threshold = 99.0,
		equip_slot = 1,
	};
local OFFSETS_URL = "https://offsets.imtheo.lol/offsets.hpp";
local Y = {
		FramePositionX = 1296,
		FrameSizeX = 1328,
		ScreenGuiEnabled = 1220,
		FrameVisible = 1453,
	};
local function parseOffset(B, j, i)
	local G = B:match("namespace%s+" .. j .. "%s*{(.-)\n%s*}");
	if not G then
		return nil;
	end;
	local Y = G:match(i .. "%s*=%s*(0x%x+)") or G:match(i .. "%s*=%s*(%d+)");
	return Y and tonumber(Y) or nil;
end;
local function loadOffsets()
	if type(game.HttpGet) ~= "function" then
		return;
	end;
	local B, j = pcall(function()
			return game:HttpGet(OFFSETS_URL);
		end);
	if not B or type(j) ~= "string" or #j == 0 then
		warn("[AutoFish] Failed to fetch offsets, using built-in defaults.");
		return;
	end;
	local i = {
			FramePositionX = parseOffset(j, "GuiObject", "Position"),
			FrameSizeX = parseOffset(j, "GuiObject", "Size"),
			ScreenGuiEnabled = parseOffset(j, "GuiObject", "ScreenGui_Enabled"),
			FrameVisible = parseOffset(j, "GuiObject", "Visible"),
		};
	local G = 0;
	for B, j in pairs(i) do
		if j then
			Y[B] = j;
			G = G + 1;
		end;
	end;
	if G > 0 then
		print("[AutoFish] Loaded " .. G .. " offset(s) from " .. OFFSETS_URL);
	else
		warn("[AutoFish] Offsets fetched but none matched, using built-in defaults.");
	end;
end;
pcall(loadOffsets);
local function t(B)
	if not B or B <= 4096 then
		return .0;
	end;
	local j, i = pcall(memory_read, "float", B);
	return (j and i) or .0;
end;
local function q(B)
	if not B or B <= 4096 then
		return 0;
	end;
	local j, i = pcall(memory_read, "int32", B);
	if not j then
		j, i = pcall(memory_read, "int", B);
	end;
	return (j and i) or 0;
end;
local function s(B)
	if not B or B <= 4096 then
		return 0;
	end;
	local j, i = pcall(memory_read, "byte", B);
	return (j and i) or 0;
end;
local function E(B)
	if not B then
		return nil;
	end;
	local j, i = pcall(function()
			return B.Address;
		end);
	i = ((j and i)) and tonumber(i) or nil;
	return ((i and i > 4096)) and i or nil;
end;
local function x(B)
	local j = E(B);
	if not j then
		return 0, 0, 0, 0;
	end;
	local i = j + Y.FramePositionX;
	return t(i + 0), q(i + 4), t(i + 8), q(i + 12);
end;
local function v(B)
	local j = E(B);
	if not j then
		return 0, 0, 0, 0;
	end;
	local i = j + Y.FrameSizeX;
	return t(i + 0), q(i + 4), t(i + 8), q(i + 12);
end;
local function Z(B)
	if not B then
		return false;
	end;
	local j, i = pcall(function()
			return B.Enabled;
		end);
	if j and type(i) == "boolean" then
		return i;
	end;
	local G = E(B);
	if not G then
		return true;
	end;
	return s(G + Y.ScreenGuiEnabled) ~= 0;
end;
local function e(B)
	if not B then
		return false;
	end;
	local j, i = pcall(function()
			return B.Visible;
		end);
	if j and type(i) == "boolean" then
		return i;
	end;
	local G = E(B);
	if not G then
		return true;
	end;
	return s(G + Y.FrameVisible) ~= 0;
end;
local function A(B)
	return B == B and ((B ~= math.huge and B ~= -math.huge));
end;
local function a(B, j)
	if not B then
		return nil;
	end;
	local i, G = pcall(B.FindFirstChild, B, j);
	return i and G or nil;
end;
local function h(B)
	if not B then
		return {};
	end;
	local j, i = pcall(B.GetChildren, B);
	return (j and i) or {};
end;
local function S()
	local B = i();
	if not B then
		return nil;
	end;
	return B:FindFirstChildOfClass("PlayerGui") or a(B, "PlayerGui");
end;
local function F()
	local B = i();
	if not B then
		return nil;
	end;
	return B.Character or (workspace and a(workspace, B.Name));
end;
local function d()
	local B = S();
	if not B then
		return nil;
	end;
	local j = a(B, "backpack");
	if not j then
		return nil;
	end;
	return a(j, "hotbar");
end;
local function M(B, j)
	if not B then
		return nil;
	end;
	local i, G = { B }, 1;
	while G <= #i do
		local B = i[G];
		G = G + 1;
		for B, G in ipairs(h(B)) do
			if G.Name == j and G.ClassName == "Frame" then
				return G;
			end;
			i[#i + 1] = G;
		end;
		if G > 8192 then
			return nil;
		end;
	end;
	return nil;
end;
local P = { Enter = 13, F1 = 112 };
local function u(B, j)
	keypress(B);
	task.spawn(function()
		wait(((j or 25)) / 1000);
		keyrelease(B);
	end);
end;
local function L()
	u(P.Enter, 20);
end;
local function n(B)
	local j = tostring(B or "");
	local i = tonumber(j);
	if i and ((i >= 0 and i <= 9)) then
		return 48 + i;
	end;
	if #j == 1 then
		local B = ((j:upper())):byte();
		if B >= 65 and B <= 90 then
			return B;
		end;
	end;
	return nil;
end;
local function V(B)
	local j = n(B);
	if not j then
		return;
	end;
	u(j, 25);
end;
local function z()
	if type(isrbxactive) ~= "function" then
		return true;
	end;
	local B, j = pcall(isrbxactive);
	return (not B) or (j ~= false);
end;
local T = false;
local function I()
	if T then
		return;
	end;
	mouse1press();
	T = true;
end;
local function c()
	if not T then
		return;
	end;
	mouse1release();
	T = false;
end;
local function W()
	local B = F();
	if not B then
		return false;
	end;
	for B, j in ipairs(h(B)) do
		if j.ClassName == "Tool" then
			return true;
		end;
	end;
	return false;
end;
local function r()
	if W() then
		return;
	end;
	if G.equip_slot and G.equip_slot > 0 then
		V(G.equip_slot);
	end;
end;
local function m()
	local B = S();
	if not B then
		return nil;
	end;
	return a(B, "reel");
end;
local function N()
	local B = m();
	return B and Z(B) or false;
end;
local function C()
	local B = m();
	if not B or not Z(B) then
		return nil;
	end;
	local j = a(B, "bar");
	if not j then
		return nil;
	end;
	local i = a(j, "fish");
	local G = a(j, "playerbar");
	if not ((i and G)) then
		return nil;
	end;
	return { bar = j, fish = i, playerbar = G };
end;
local function b(B)
	B = B or C();
	return B and ((B.fish and ((B.playerbar and true)))) or false;
end;
local function Q(B)
	local j = v(B);
	if not A(j) or j < -0.05 or j > 1.5 then
		return nil;
	end;
	return math.max(.0, math.min(100.0, j * 100.0));
end;
local function J()
	local B = m();
	if not B then
		return nil;
	end;
	local j = a(B, "bar");
	if not j then
		return nil;
	end;
	local i = a(j, "progress");
	if not i then
		return nil;
	end;
	local G = a(i, "bar");
	if not G then
		return nil;
	end;
	return Q(G);
end;
local function l()
	local B = F();
	if not B then
		return nil;
	end;
	local j = a(B, "HumanoidRootPart");
	if not j then
		return nil;
	end;
	local i = a(j, "power");
	if not i then
		return nil;
	end;
	return M(i, "bar");
end;
local function R(B)
	local j = E(B);
	if not j then
		return nil;
	end;
	local i = t(((j + Y.FrameSizeX)) + 8);
	if not A(i) or i < -0.05 or i > 1.5 then
		return nil;
	end;
	return math.max(.0, math.min(100.0, i * 100.0));
end;
local function f()
	if G.cast_mode == "short" then
		return 28.0;
	end;
	if G.cast_mode == "custom" then
		return math.max(1.0, math.min(100.0, G.cast_power_custom));
	end;
	return 96.0;
end;
local H = {
		CloseThreshold = .01,
		DerivativeGain = .55,
		EdgeBoundary = .1,
		NeutralDutyCycle = .5,
		PredictionStrength = 7.5,
		ProportionalGain = .42,
		Resilience = .0,
		VelocityDamping = 38,
	};
local O = {};
O.__index = O;
function O.new()
	return setmetatable({ lastPlayerbarPos = nil, lastFishPos = nil, pwmAccumulator = .0 }, O);
end;
function O.Reset(B)
	B.lastPlayerbarPos = nil;
	B.lastFishPos = nil;
	B.pwmAccumulator = .0;
end;
function O.GetFishPosition(B, j)
	if not j or not j.fish then
		return nil;
	end;
	local i = x(j.fish);
	local G = v(j.fish);
	return i + (G / 2);
end;
function O.GetPlayerbarPosition(B, j)
	if not j or not j.playerbar then
		return nil;
	end;
	return (x(j.playerbar));
end;
local function o(B)
	if not ((B and ((B.playerbar and B.fish)))) then
		return nil;
	end;
	local j = x(B.playerbar);
	local i = v(B.playerbar);
	local G = x(B.fish);
	local Y = v(B.fish);
	local t = G + (Y / 2);
	local q = i / 2;
	return t >= j - q and t <= j + q;
end;
function O.Update(B, j)
	if o(j) == nil then
		c();
		return;
	end;
	local i = B:GetFishPosition(j);
	local G = B:GetPlayerbarPosition(j);
	if not ((i and G)) then
		return;
	end;
	if B.lastPlayerbarPos == nil then
		B.lastPlayerbarPos = G;
	end;
	if B.lastFishPos == nil then
		B.lastFishPos = i;
	end;
	local Y = G - B.lastPlayerbarPos;
	B.lastPlayerbarPos = G;
	local t = i - B.lastFishPos;
	B.lastFishPos = i;
	local q = i - G;
	local s = H.EdgeBoundary;
	if G < s then
		I();
		return;
	end;
	if G > 1 - s then
		c();
		return;
	end;
	local E = G + (Y * ((H.PredictionStrength * ((1.0 - H.Resilience)))));
	local x = i - E;
	local v = H.CloseThreshold;
	local Z = (q * x) > 0;
	local e = (q * Y) > 0;
	local A = math.max(.0, math.abs(q) - v);
	local a = math.abs(Y) * 8;
	local h = e and (a >= A);
	if math.abs(q) > v and ((Z and not h)) then
		if q > 0 then
			I();
		else
			c();
		end;
		return;
	end;
	local S = H.NeutralDutyCycle;
	local F;
	if h and a > 0 then
		local B = 1.0 - math.min(1.0, A / a);
		if q > 0 then
			F = S * ((1.0 - B));
		else
			F = S + (((1.0 - S)) * B);
		end;
	else
		local B = (((H.ProportionalGain * q) + (H.DerivativeGain * t))) - (H.VelocityDamping * Y);
		F = math.max(.0, math.min(1.0, S + B));
	end;
	B.pwmAccumulator = B.pwmAccumulator + F;
	if B.pwmAccumulator >= 1.0 then
		B.pwmAccumulator = B.pwmAccumulator - 1.0;
		I();
	else
		c();
	end;
end;
local X = O.new();
local U = {
		phase = "OFF",
		castStartedAt = 0,
		castReleasedAt = 0,
		castBarSeen = false,
		castThreshold = 96.0,
		castWaitTimeoutMs = 15000,
		castChargeLastPct = nil,
		castChargeMotionAt = 0,
		lastShakedAt = 0,
		shakingIntervalMs = 25,
		fishingLostAt = 0,
		completionReached = false,
		doneAt = 0,
		powerPercent = "",
		progressPercent = "",
		caught = 0,
		lost = 0,
		timeouts = 0,
	};
local function D()
	c();
	X:Reset();
	r();
	U.castStartedAt = tick() * 1000;
	U.castReleasedAt = 0;
	U.castBarSeen = false;
	U.castChargeLastPct = nil;
	U.castChargeMotionAt = 0;
	U.lastShakedAt = 0;
	U.fishingLostAt = 0;
	U.completionReached = false;
	U.doneAt = 0;
	U.powerPercent = "";
	U.progressPercent = "";
	U.castThreshold = f();
	U.castWaitTimeoutMs = math.max(5000, G.cast_timeout_ms);
	U.shakingIntervalMs = G.shake_interval_ms;
	U.phase = b() and "FISHING" or "CASTING";
end;
local function y(B)
	c();
	X:Reset();
	U.powerPercent = "";
	U.progressPercent = "";
	U.phase = B or "OFF";
end;
local function K()
	U.timeouts = U.timeouts + 1;
	if G.cast_on_timeout then
		D();
	else
		y("OFF");
	end;
end;
local function w()
	U.progressPercent = "";
	if b() then
		c();
		U.fishingLostAt = 0;
		U.phase = "FISHING";
		return;
	end;
	I();
	if U.castStartedAt == 0 then
		U.castStartedAt = tick() * 1000;
	end;
	local B = l();
	if not B then
		U.powerPercent = "---";
		local B = tick() * 1000 - U.castStartedAt;
		if not U.castBarSeen and B >= 2000 then
			K();
			return;
		end;
		if B >= U.castWaitTimeoutMs then
			K();
		end;
		return;
	end;
	U.castBarSeen = true;
	local j = R(B);
	local i = tick() * 1000;
	if j then
		U.powerPercent = string.format("%.1f", j);
		if j >= U.castThreshold then
			c();
			U.castReleasedAt = i;
			U.phase = "CASTED";
			return;
		end;
	else
		U.powerPercent = "---";
	end;
	local G = (j ~= nil) and ((U.castChargeLastPct == nil or math.abs(j - U.castChargeLastPct) >= .5));
	if G then
		U.castChargeMotionAt = i;
	end;
	U.castChargeLastPct = j;
	if U.castChargeMotionAt == 0 then
		U.castChargeMotionAt = i;
	end;
	if U.castBarSeen and (i - U.castChargeMotionAt) >= 1200 then
		K();
		return;
	end;
	if (i - U.castStartedAt) >= U.castWaitTimeoutMs then
		K();
	end;
end;
local function p()
	U.powerPercent = "";
	c();
	if U.castReleasedAt == 0 then
		U.castReleasedAt = tick() * 1000;
	end;
	if (tick() * 1000 - U.castReleasedAt) < G.post_cast_delay_ms then
		return;
	end;
	U.lastShakedAt = 0;
	U.phase = "SHAKE";
end;
local function k()
	U.powerPercent = "";
	U.progressPercent = "";
	c();
	if b() then
		U.fishingLostAt = 0;
		U.phase = "FISHING";
		return;
	end;
	local B = tick() * 1000;
	if U.lastShakedAt == 0 or (B - U.lastShakedAt) >= U.shakingIntervalMs then
		L();
		U.lastShakedAt = B;
	end;
	if U.castReleasedAt > 0 and (B - U.castReleasedAt) >= U.castWaitTimeoutMs then
		D();
	end;
end;
local function g()
	U.powerPercent = "";
	local B = C();
	local j = J();
	U.progressPercent = j and string.format("%.1f", j) or "";
	if j and j >= G.completion_threshold then
		U.completionReached = true;
	end;
	if B and b(B) then
		U.fishingLostAt = 0;
		X:Update(B);
		return;
	end;
	c();
	X:Reset();
	if U.completionReached or (j and j >= G.completion_threshold) then
		U.caught = U.caught + 1;
	else
		U.lost = U.lost + 1;
	end;
	y("DONE");
end;
local function Bs()
	if b() then
		U.doneAt = 0;
		U.phase = "FISHING";
		return;
	end;
	local B = tick() * 1000;
	if U.doneAt == 0 then
		U.doneAt = B;
	end;
	if (B - U.doneAt) < G.post_catch_delay_ms then
		return;
	end;
	D();
end;
local js = {
		CASTING = w,
		CASTED = p,
		SHAKE = k,
		FISHING = g,
		DONE = Bs,
	};
local is = false;
local function Gs(B)
	B = B and true or false;
	if B == is then
		return;
	end;
	is = B;
	if B then
		U.phase = "OFF";
	else
		c();
		U.phase = "OFF";
	end;
	notify(B and "AutoFish ON" or ("AutoFish OFF (" .. ((U.caught .. " caught)"))), "AutoFish", 2);
end;
local Ys = false;
j.Heartbeat:Connect(function()
	if type(iskeypressed) == "function" then
		local B, j = pcall(iskeypressed, P.F1);
		if B and ((j and not Ys)) then
			Ys = true;
			Gs(not is);
		elseif B and not j then
			Ys = false;
		end;
	end;
	if not is then
		return;
	end;
	if not z() then
		c();
		return;
	end;
	if U.phase == "OFF" then
		D();
	end;
	local B = js[U.phase];
	if B then
		local j, i = pcall(B);
		if not j then
			c();
			warn("[AutoFish] " .. ((tostring(U.phase) .. ((": " .. tostring(i))))));
		end;
	end;
end);
notify("AutoFish loaded, press F1 to start.", "AutoFish", 4);
print("[AutoFish] loaded. F1 toggles cast/shake/reel. Cast mode: " .. G.cast_mode);