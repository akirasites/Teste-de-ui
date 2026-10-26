--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                  CoiledTom Key System  v1.0                   ║
    ║  Painel escuro premium · órbitas · abas · sons · minimizar    ║
    ╚══════════════════════════════════════════════════════════════╝

    COMO USAR
      1. Edite a tabela Config logo abaixo (tudo é configurável ali).
      2. Conecte seu validador em Config.Validation (Adapter OU Http.Parse).
      3. Conecte seu script principal em Config.OnExecute.
      4. Rode como LocalScript / no executor.

    API (retornada pelo script e salva em getgenv().CoiledTomKeySystem):
      KeySystem.AddSphere({ Name=, Image=, Size=, Speed=, Direction=, Ring= })
      KeySystem.AddKeyProvider({ Name=, Url=, Icon= })
      KeySystem.AddCredit({ Name=, Role=, Description=, Image=, Icon=, Link= })
      KeySystem.Destroy()

    NADA aqui é simulado: sem Adapter/endpoint configurado, a Key NUNCA é
    aceita (a GUI mostra "validador não configurado").
]]

-- ════════════════════════════════════════════════════════════════
--  CONFIGURAÇÃO
-- ════════════════════════════════════════════════════════════════
local Config = {
	Name     = "CoiledTom Key System",
	Subtitle = "Autenticação segura",

	-- Ícone da marca: nome semântico (resolvido via RocketUI Icons) e/ou imagem própria.
	BrandIcon  = "key",
	BrandImage = "", -- ex.: "rbxassetid://123..." (opcional; usado também na esfera "GUI")

	Colors = {
		Bg       = Color3.fromHex("07070B"),
		Panel    = Color3.fromHex("0D0D15"),
		Card     = Color3.fromHex("14141F"),
		Field    = Color3.fromHex("0A0A11"),
		Stroke   = Color3.fromHex("262638"),
		Violet   = Color3.fromHex("8B5CF6"),
		Purple   = Color3.fromHex("5B21B6"),
		Electric = Color3.fromHex("A78BFA"),
		Orange   = Color3.fromHex("FF8A3D"),
		Success  = Color3.fromHex("34D399"),
		Error    = Color3.fromHex("F87171"),
		Text     = Color3.fromHex("F2F2F8"),
		Muted    = Color3.fromHex("8C8CA6"),
	},

	Window = {
		Width = 460, Height = 350,
		MinScale = 0.5, MaxScale = 1.15, -- escala responsiva (celular ↔ desktop)
	},

	-- Execute só aparece após validação real bem-sucedida.
	RequireKeyToExecute = true,

	-- ── Validação ────────────────────────────────────────────────
	Validation = {
		Timeout = 12,
		-- OPÇÃO A: função própria. Deve retornar uma tabela:
		--   { ok = true/false, status = "valid"|"invalid"|"expired"|"error", message = "opcional" }
		-- Ex.: Adapter = function(key) ... return { ok = true, status = "valid" } end
		Adapter = nil,

		-- OPÇÃO B: adaptador HTTP genérico (você fornece URL + como montar/ler).
		-- Nenhum endpoint é presumido. Preencha os 3 campos para ativar.
		Http = {
			Url = "",         -- endpoint do SEU provedor (documentação dele)
			BuildUrl = nil,   -- function(url, key) return string end
			Parse = nil,      -- function(decodedJson, rawBody) return {ok=,status=,message=} end
		},
		-- Panda Auth / outros: mande a documentação oficial do endpoint público
		-- e eu escrevo o Adapter exato. Nunca coloque segredos admin aqui.
	},

	-- Chamado UMA vez, só depois da animação de Execute. (Fechar com X NÃO chama.)
	OnExecute = function()
		-- >>> COLOQUE AQUI O SEU SCRIPT PRINCIPAL AUTORIZADO <<<
		warn("[CoiledTom] OnExecute não configurado.")
	end,

	-- ── Get Key ──────────────────────────────────────────────────
	-- 1 opção → botão direto · 2+ → dropdown. Sem URLs inventadas.
	KeyProviders = {
		-- { Name = "Meu Site",    Url = "https://...", Icon = "link" },
		-- { Name = "Discord",     Url = "https://...", Icon = "link" },
		-- { Name = "Linkvertise", Url = "https://...", Icon = "link" },
	},

	-- ── Esferas orbitais ─────────────────────────────────────────
	-- Image aceita: "auto:game", "auto:player", "rbxassetid://ID", número, "rbxthumb://..."
	Spheres = {
		{ Name = "Mapa",     Image = "auto:game"   },
		{ Name = "Jogador",  Image = "auto:player" },
		{ Name = "GUI",      Image = "",           UseBrand = true }, -- usa BrandImage/ícone
		{ Name = "Executor", Image = "",           Icon = "executor" }, -- coloque a imagem do seu executor
	},

	Orbit = {
		BaseSpeed = 0.55,   -- rad/s
		SphereSize = 48,
		Gap = 38,           -- distância do painel
		RingStep = 56,      -- distância entre órbitas
		PerRing = 6,        -- esferas por órbita antes de abrir outra
		Squareness = 6,     -- 2 = elipse · maior = mais "quadrada" (acompanha o painel)
		IntroSpread = 0.55, -- raio relativo durante o carregamento
		MinimizedScale = 0.6,
		ShowNames = false,
	},

	Timings = {
		Burst = 0.9, Loading = 1.8, Converge = 0.6, Expand = 1.0, Reveal = 0.7,
		SpinUp = 0.5, Absorb = 0.95, SpeedBoost = 7,
	},

	-- ── Sons (IDs fornecidos por você; vazio = sem som) ─────────
	Audio = {
		Enabled = true, Volume = 0.5,
		Sounds = {
			Open = "", Click = "", DropdownOpen = "", DropdownClose = "",
			Validate = "", Error = "", Success = "", Execute = "",
			Close = "", Minimize = "", Restore = "",
		},
	},

	-- ── Ícones (RocketUI) ────────────────────────────────────────
	Icons = {
		Url = "https://raw.githubusercontent.com/CoiledTom/RocketUI/refs/heads/main/Icons.lua",
		Timeout = 8,
		-- Mapa semântico → nomes candidatos no Icons.lua. Ajuste se os nomes forem outros.
		Map = {
			key = { "key", "key-round", "lock-keyhole" },
			verify = { "shield-check", "badge-check", "circle-check" },
			link = { "link", "external-link" },
			player = { "user", "user-round" },
			game = { "gamepad-2", "gamepad", "joystick" },
			executor = { "terminal", "cpu", "code" },
			credits = { "award", "users", "heart" },
			owner = { "crown" }, developer = { "code", "terminal" }, admin = { "shield" },
			minimize = { "minus" }, restore = { "maximize", "maximize-2" }, close = { "x" },
			audio = { "volume-2", "volume" }, audioOff = { "volume-x" },
			settings = { "settings", "sliders-horizontal" },
			success = { "circle-check", "check" }, error = { "circle-x", "x-circle", "triangle-alert" },
			fps = { "activity", "gauge" }, ping = { "wifi", "signal" }, device = { "smartphone", "monitor" },
			paste = { "clipboard-paste", "clipboard" }, chevron = { "chevron-down" }, execute = { "play", "zap" },
		},
	},

	-- ── Créditos (sem nomes pré-cadastrados) ─────────────────────
	Credits = {
		-- { Name = "Seu Nome", Role = "Owner", Description = "...", Image = "", Icon = "owner", Link = "" },
	},
}

-- ════════════════════════════════════════════════════════════════
--  SERVIÇOS / UTILIDADES
-- ════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local C = Config.Colors
local W, H = Config.Window.Width, Config.Window.Height
local BUBBLE = 58

-- instância anterior
do
	local env = type(getgenv) == "function" and getgenv() or _G
	if env.CoiledTomKeySystem and env.CoiledTomKeySystem.Destroy then
		pcall(env.CoiledTomKeySystem.Destroy)
	end
end

local Maid = {}
local function bind(conn) table.insert(Maid, conn) return conn end

local function new(class, props, kids)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do if k ~= "Parent" then o[k] = v end end
	for _, kid in ipairs(kids or {}) do kid.Parent = o end
	if props and props.Parent then o.Parent = props.Parent end
	return o
end
local function corner(o, r)
	return new("UICorner", { CornerRadius = r and UDim.new(0, r) or UDim.new(1, 0), Parent = o })
end
local function stroke(o, color, th, tr)
	return new("UIStroke", { Color = color or C.Stroke, Thickness = th or 1, Transparency = tr or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o })
end
local function gradient(o, c0, c1, rot)
	return new("UIGradient", { Color = ColorSequence.new(c0, c1), Rotation = rot or 0, Parent = o })
end
local function pad(o, l, t, r, b)
	return new("UIPadding", { PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t or l),
		PaddingRight = UDim.new(0, r or l), PaddingBottom = UDim.new(0, b or t or l), Parent = o })
end
local function lerp(a, b, t) return a + (b - a) * t end

local function tw(inst, t, props, style, dir)
	local tween = TweenService:Create(inst, TweenInfo.new(t, style or Enum.EasingStyle.Quint,
		dir or Enum.EasingDirection.Out), props)
	tween:Play()
	return tween
end
local function twWait(inst, t, props, style, dir)
	local tween = tw(inst, t, props, style, dir)
	tween.Completed:Wait()
end

local function text(parent, str, size, color, font, props)
	local p = { BackgroundTransparency = 1, Text = str, TextSize = size or 14, TextColor3 = color or C.Text,
		Font = font or Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = parent }
	for k, v in pairs(props or {}) do p[k] = v end
	return new("TextLabel", p)
end

-- ════════════════════════════════════════════════════════════════
--  ESTADO
-- ════════════════════════════════════════════════════════════════
-- Opening · Idle · Validating · Success · Executing · Closing · Closed
local State = "Opening"
local Minimized, Busy = false, false
local KeyValidated = false
local baseScale = 1

local orb = {}
for k, v in pairs({ spread = 0, speed = 1, size = 0, absorb = 0, minimized = 0 }) do
	orb[k] = new("NumberValue", { Value = v })
end

-- ════════════════════════════════════════════════════════════════
--  ADAPTADOR DE AMBIENTE (isola chamadas de executor)
-- ════════════════════════════════════════════════════════════════
local Env = {}
function Env.parent()
	if type(gethui) == "function" then
		local ok, h = pcall(gethui)
		if ok and h then return h end
	end
	if pcall(function() return CoreGui.Name end) then return CoreGui end
	return LocalPlayer:WaitForChild("PlayerGui")
end
function Env.httpGet(url)
	local ok, res = pcall(function() return game:HttpGet(url) end)
	if ok and type(res) == "string" and #res > 0 then return res end
	local reqFn = (type(request) == "function" and request) or (type(http_request) == "function" and http_request)
		or (syn and syn.request) or (http and http.request)
	if reqFn then
		local ok2, r = pcall(reqFn, { Url = url, Method = "GET" })
		if ok2 and type(r) == "table" and r.Body and #r.Body > 0 then return r.Body end
	end
	return nil
end
function Env.executor()
	for _, name in ipairs({ "identifyexecutor", "getexecutorname" }) do
		local fn = _G[name] or (getfenv and getfenv()[name])
		if type(fn) == "function" then
			local ok, n, v = pcall(fn)
			if ok and n then return tostring(n) .. (v and (" " .. tostring(v)) or "") end
		end
	end
	return nil
end
function Env.clipboardGet()
	local fn = getfenv and getfenv().getclipboard
	if type(fn) == "function" then
		local ok, v = pcall(fn)
		if ok and type(v) == "string" then return v end
	end
end
function Env.clipboardSet(s)
	local fn = getfenv and getfenv().setclipboard
	if type(fn) == "function" then return (pcall(fn, s)) end
	return false
end
-- Retorna true se abriu; "copied" se só copiou; false se nada funcionou.
function Env.openLink(url)
	if type(url) ~= "string" or not url:match("^https?://") then return false, "invalid" end
	if pcall(function() GuiService:OpenBrowserWindow(url) end) then return true end
	if Env.clipboardSet(url) then return "copied" end
	return false, "unsupported"
end

-- ════════════════════════════════════════════════════════════════
--  ÍCONES (RocketUI) — carregamento tolerante a falhas
-- ════════════════════════════════════════════════════════════════
local Icons = { raw = nil, idx = {}, ready = false, cache = {} }

local function normImage(v)
	if type(v) == "number" then return "rbxassetid://" .. v end
	if type(v) == "string" then
		if v:match("^%d+$") then return "rbxassetid://" .. v end
		return v
	end
end
local function decode(v)
	if type(v) == "string" or type(v) == "number" then
		local img = normImage(v)
		return img and { Image = img } or nil
	elseif type(v) == "table" then
		local img = normImage(v.Image or v.image or v.Id or v.id or v[1])
		if not img then return nil end
		return { Image = img,
			RectSize = v.ImageRectSize or v.RectSize or v.Size,
			RectOffset = v.ImageRectOffset or v.ImageRectPosition or v.RectOffset or v.Position }
	end
end
local function indexTable(t)
	for k, v in pairs(t) do
		if type(k) == "string" then
			Icons.idx[k:lower()] = v
			if type(v) == "table" and not (v.Image or v.Id or v.id) then
				for k2, v2 in pairs(v) do
					if type(k2) == "string" and Icons.idx[k2:lower()] == nil then Icons.idx[k2:lower()] = v2 end
				end
			end
		end
	end
end

function Icons.load()
	local env = type(getgenv) == "function" and getgenv() or _G
	if env.__CoiledTomIcons then -- evita downloads repetidos
		Icons.raw = env.__CoiledTomIcons
	else
		local done = false
		task.spawn(function()
			local src = Env.httpGet(Config.Icons.Url)
			if src and type(loadstring) == "function" then
				local fn = loadstring(src)
				if fn then
					local ok, res = pcall(fn)
					if ok and type(res) == "table" then Icons.raw = res; env.__CoiledTomIcons = res end
				end
			end
			done = true
		end)
		local t0 = os.clock()
		while not done and os.clock() - t0 < Config.Icons.Timeout do task.wait(0.05) end
	end
	if Icons.raw then indexTable(Icons.raw) end
	Icons.ready = true
end

function Icons.get(semantic)
	if semantic == nil then return nil end
	if Icons.cache[semantic] ~= nil then return Icons.cache[semantic] or nil end
	local cands = Config.Icons.Map[semantic] or { semantic }
	local found
	for _, cand in ipairs(cands) do
		local l = cand:lower()
		if Icons.idx[l] then found = decode(Icons.idx[l]) end
		if not found and Icons.raw then
			for _, fname in ipairs({ "GetIcon", "Get", "get" }) do
				if type(Icons.raw[fname]) == "function" then
					local ok, r = pcall(Icons.raw[fname], cand)
					if ok then found = decode(r) end
					if found then break end
				end
			end
		end
		if not found then
			for k, v in pairs(Icons.idx) do -- prefixos como "lucide-key"
				if k:sub(-(#l + 1)) == "-" .. l or k:sub(-(#l + 1)) == ":" .. l or k:sub(-(#l + 1)) == "." .. l then
					found = decode(v); if found then break end
				end
			end
		end
		if found then break end
	end
	Icons.cache[semantic] = found or false
	return found
end

local registry = {}
local function applyIcon(c)
	if not c.Parent then return end
	local d = Icons.get(c:GetAttribute("IconName"))
	local img, dot = c:FindFirstChild("Img"), c:FindFirstChild("Dot")
	if d then
		img.Image = d.Image
		img.ImageRectSize = d.RectSize or Vector2.zero
		img.ImageRectOffset = d.RectOffset or Vector2.zero
		img.Visible = true; dot.Visible = false
	else
		img.Visible = false; dot.Visible = true -- fallback consistente
	end
end
local function makeIcon(parent, name, size, color, props)
	local c = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(size, size), Parent = parent })
	for k, v in pairs(props or {}) do c[k] = v end
	c:SetAttribute("IconName", name)
	new("ImageLabel", { Name = "Img", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
		ImageColor3 = color or C.Text, Visible = false, Parent = c })
	local dot = new("Frame", { Name = "Dot", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(size * 0.38, size * 0.38), BackgroundColor3 = color or C.Text, Parent = c })
	corner(dot)
	table.insert(registry, c)
	if Icons.ready then applyIcon(c) end
	return c
end
local function setIconColor(c, color, t)
	local img, dot = c:FindFirstChild("Img"), c:FindFirstChild("Dot")
	if img then tw(img, t or 0.2, { ImageColor3 = color }) end
	if dot then tw(dot, t or 0.2, { BackgroundColor3 = color }) end
end

-- ════════════════════════════════════════════════════════════════
--  SONS
-- ════════════════════════════════════════════════════════════════
local Sfx = { cache = {} }
function Sfx.play(name)
	local A = Config.Audio
	if not A.Enabled then return end
	local id = normImage(A.Sounds[name])
	if not id or id == "" then return end
	local s = Sfx.cache[name]
	if not s then
		s = new("Sound", { SoundId = id, Parent = game:GetService("SoundService") })
		Sfx.cache[name] = s
	end
	s.Volume = math.clamp(A.Volume, 0, 1)
	pcall(function() s.TimePosition = 0; s:Play() end)
end

-- ════════════════════════════════════════════════════════════════
--  GUI RAIZ
-- ════════════════════════════════════════════════════════════════
local gui = new("ScreenGui", { Name = "CoiledTomKeySystem", ResetOnSpawn = false, IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999 })
gui.Parent = Env.parent()

-- Esferas ficam atrás do painel
local sphereLayer = new("Frame", { Name = "Spheres", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
	ZIndex = 1, Parent = gui })

-- ── Painel ──────────────────────────────────────────────────────
local panelPos = UDim2.fromScale(0.5, 0.5)
local panel = new("CanvasGroup", { Name = "Panel", AnchorPoint = Vector2.new(0.5, 0.5), Position = panelPos,
	Size = UDim2.fromOffset(W, H), BackgroundColor3 = C.Panel, GroupTransparency = 1, ZIndex = 5, Parent = gui })
corner(panel, 18)
stroke(panel, C.Stroke, 1.2, 0)
gradient(panel, Color3.fromHex("121220"), C.Bg, 90)
local panelScale = new("UIScale", { Parent = panel })
local panelAnim = new("NumberValue", { Value = 0.88 })
local function applyScale() panelScale.Scale = math.max(0.001, baseScale * panelAnim.Value) end
bind(panelAnim.Changed:Connect(applyScale))

-- linha de energia superior
local topLine = new("Frame", { Size = UDim2.new(1, -36, 0, 2), Position = UDim2.fromOffset(18, 0),
	BackgroundColor3 = C.Violet, BorderSizePixel = 0, Parent = panel })
new("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C.Purple),
	ColorSequenceKeypoint.new(0.6, C.Violet), ColorSequenceKeypoint.new(1, C.Orange) }), Parent = topLine })
new("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.25, 0), NumberSequenceKeypoint.new(0.75, 0), NumberSequenceKeypoint.new(1, 1) }) , Parent = topLine })

-- ── Barra de título ─────────────────────────────────────────────
local titleBar = new("Frame", { Size = UDim2.new(1, 0, 0, 54), BackgroundTransparency = 1, Parent = panel })

local brand = new("Frame", { Size = UDim2.fromOffset(34, 34), Position = UDim2.fromOffset(16, 10),
	BackgroundColor3 = Color3.new(1, 1, 1), Parent = titleBar })
corner(brand, 10); gradient(brand, C.Violet, C.Purple, 45); stroke(brand, C.Electric, 1, 0.55)
if Config.BrandImage ~= "" then
	new("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -6, 1, -6), Position = UDim2.fromOffset(3, 3),
		Image = normImage(Config.BrandImage), ScaleType = Enum.ScaleType.Crop, Parent = brand }, { new("UICorner", { CornerRadius = UDim.new(0, 8) }) })
else
	makeIcon(brand, Config.BrandIcon, 18, C.Text, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5) })
end
text(titleBar, Config.Name, 16, C.Text, Enum.Font.GothamBold, { Position = UDim2.fromOffset(60, 9),
	Size = UDim2.new(1, -230, 0, 20), TextTruncate = Enum.TextTruncate.AtEnd })
text(titleBar, Config.Subtitle, 12, C.Muted, Enum.Font.Gotham, { Position = UDim2.fromOffset(60, 29),
	Size = UDim2.new(1, -230, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd })

-- botões da barra de título
local function iconButton(parent, iconName, xFromRight, hoverColor)
	local b = new("TextButton", { Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(34, 34),
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -xFromRight, 0, 10), BackgroundColor3 = C.Card,
		BackgroundTransparency = 0.2, Parent = parent })
	corner(b, 10)
	local st = stroke(b, C.Stroke, 1, 0.3)
	local ic = makeIcon(b, iconName, 17, C.Muted, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5) })
	bind(b.MouseEnter:Connect(function()
		setIconColor(ic, hoverColor or C.Text, 0.15); tw(st, 0.15, { Color = hoverColor or C.Violet, Transparency = 0.2 })
	end))
	bind(b.MouseLeave:Connect(function()
		setIconColor(ic, C.Muted, 0.15); tw(st, 0.15, { Color = C.Stroke, Transparency = 0.3 })
	end))
	return b, ic
end
local closeBtn = iconButton(titleBar, "close", 14, C.Error)
local minBtn = iconButton(titleBar, "minimize", 54)
local audioBtn, audioIcon = iconButton(titleBar, "audio", 94)

-- ── Abas ────────────────────────────────────────────────────────
local tabBar = new("Frame", { Position = UDim2.fromOffset(0, 54), Size = UDim2.new(1, 0, 0, 40),
	BackgroundTransparency = 1, Parent = panel })
new("Frame", { Position = UDim2.new(0, 16, 1, -1), Size = UDim2.new(1, -32, 0, 1), BackgroundColor3 = C.Stroke,
	BorderSizePixel = 0, Parent = tabBar })
local indicatorHolder = new("Frame", { Position = UDim2.new(0, 16, 1, -2), Size = UDim2.new(1, -32, 0, 2),
	BackgroundTransparency = 1, Parent = tabBar })
local indicator = new("Frame", { Size = UDim2.fromScale(1 / 3, 1), BackgroundColor3 = C.Violet, BorderSizePixel = 0,
	Parent = indicatorHolder })
corner(indicator); gradient(indicator, C.Violet, C.Orange, 0)

local content = new("Frame", { Position = UDim2.fromOffset(0, 96), Size = UDim2.new(1, 0, 1, -96),
	BackgroundTransparency = 1, ClipsDescendants = true, Parent = panel })

local tabDefs = {
	{ id = "verify", label = "VERIFY KEY", icon = "verify" },
	{ id = "player", label = "PLAYER", icon = "player" },
	{ id = "credits", label = "CREDITS", icon = "credits" },
}
local pages, tabs = {}, {}
local activeTab = "verify"

for i, d in ipairs(tabDefs) do
	local b = new("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
		Size = UDim2.new(1 / 3, 0, 1, 0), Position = UDim2.new((i - 1) / 3, 0, 0, 0), Parent = tabBar })
	local row = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = b })
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), Parent = row })
	local ic = makeIcon(row, d.icon, 16, i == 1 and C.Text or C.Muted)
	local lb = text(row, d.label, 12, i == 1 and C.Text or C.Muted, Enum.Font.GothamBold,
		{ AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 16) })
	tabs[d.id] = { btn = b, icon = ic, label = lb, index = i }

	local pg = new("CanvasGroup", { Name = d.id, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		Visible = i == 1, GroupTransparency = i == 1 and 0 or 1, Parent = content })
	pages[d.id] = pg
end

local function selectTab(id)
	if id == activeTab or State == "Opening" or State == "Closing" or State == "Executing" or State == "Closed" then return end
	Sfx.play("Click")
	local old, new_ = activeTab, id
	local dirn = tabs[new_].index > tabs[old].index and 1 or -1
	activeTab = id
	for tid, t in pairs(tabs) do
		local on = tid == id
		tw(t.label, 0.2, { TextColor3 = on and C.Text or C.Muted })
		setIconColor(t.icon, on and C.Violet or C.Muted, 0.2)
	end
	tw(indicator, 0.35, { Position = UDim2.fromScale((tabs[id].index - 1), 0) }, Enum.EasingStyle.Back)
	local po, pn = pages[old], pages[new_]
	tw(po, 0.18, { GroupTransparency = 1, Position = UDim2.fromOffset(-18 * dirn, 0) })
	task.delay(0.18, function() if activeTab ~= old then po.Visible = false end end)
	pn.Position = UDim2.fromOffset(18 * dirn, 0); pn.GroupTransparency = 1; pn.Visible = true
	tw(pn, 0.3, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) })
end
for id, t in pairs(tabs) do bind(t.btn.Activated:Connect(function() selectTab(id) end)) end
setIconColor(tabs.verify.icon, C.Violet, 0)

-- ════════════════════════════════════════════════════════════════
--  COMPONENTES: botão, spinner
-- ════════════════════════════════════════════════════════════════
local function Button(parent, label, iconName, style, size, pos)
	local primary = style == "primary"
	local b = new("TextButton", { Text = "", AutoButtonColor = false, Size = size, Position = pos or UDim2.new(),
		BackgroundColor3 = primary and Color3.new(1, 1, 1) or C.Card, ClipsDescendants = true, Parent = parent })
	corner(b, 12)
	local st = stroke(b, primary and C.Electric or C.Stroke, 1, primary and 0.6 or 0.1)
	if primary then gradient(b, C.Violet, C.Purple, 90) end
	if style == "success" then
		b.BackgroundColor3 = Color3.new(1, 1, 1); gradient(b, C.Success, Color3.fromHex("0F9D6B"), 90)
		st.Color = C.Success; st.Transparency = 0.5
	end
	local sc = new("UIScale", { Parent = b })
	local row = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = b })
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), Parent = row })
	local ic = makeIcon(row, iconName, 18, C.Text)
	local lb = text(row, label, 14, C.Text, Enum.Font.GothamBold, { AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 18) })
	bind(b.MouseEnter:Connect(function() tw(sc, 0.15, { Scale = 1.02 }); tw(st, 0.15, { Transparency = 0, Color = primary and C.Electric or C.Violet }) end))
	bind(b.MouseLeave:Connect(function() tw(sc, 0.15, { Scale = 1 }); tw(st, 0.15, { Transparency = primary and 0.6 or 0.1, Color = primary and C.Electric or C.Stroke }) end))
	bind(b.MouseButton1Down:Connect(function() tw(sc, 0.08, { Scale = 0.96 }) end))
	bind(b.MouseButton1Up:Connect(function() tw(sc, 0.12, { Scale = 1.02 }) end))
	return b, lb, ic
end

local function Spinner(parent, size, color)
	local f = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(size, size), Parent = parent })
	local ring = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = f })
	corner(ring)
	local st = stroke(ring, color, 2.5, 0)
	new("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.55, 1), NumberSequenceKeypoint.new(1, 1) }), Parent = st })
	local t = TweenService:Create(ring, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1),
		{ Rotation = 360 })
	t:Play()
	f.Destroying:Connect(function() t:Cancel() end)
	return f
end

-- ════════════════════════════════════════════════════════════════
--  ABA 1 — VERIFY KEY
-- ════════════════════════════════════════════════════════════════
local vp = pages.verify
local vWrap = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = vp })
pad(vWrap, 18, 14, 18, 16)

text(vWrap, "SUA KEY", 11, C.Muted, Enum.Font.GothamBold, { Size = UDim2.new(1, 0, 0, 14) })

local keyBox = new("Frame", { Position = UDim2.fromOffset(0, 20), Size = UDim2.new(1, 0, 0, 46),
	BackgroundColor3 = C.Field, Parent = vWrap })
corner(keyBox, 12)
local keyStroke = stroke(keyBox, C.Stroke, 1.2, 0)
local keyIcon = makeIcon(keyBox, "key", 18, C.Muted, { Position = UDim2.new(0, 14, 0.5, -9) })
local hasPaste = Env.clipboardGet() ~= nil
local input = new("TextBox", { BackgroundTransparency = 1, Position = UDim2.fromOffset(42, 0),
	Size = UDim2.new(1, hasPaste and -92 or -54, 1, 0), Text = "", PlaceholderText = "Cole ou digite sua Key aqui",
	PlaceholderColor3 = Color3.fromHex("5A5A72"), TextColor3 = C.Text, Font = Enum.Font.GothamMedium, TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, TextTruncate = Enum.TextTruncate.AtEnd, Parent = keyBox })
if hasPaste then
	local pb = new("TextButton", { Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(32, 32), BackgroundColor3 = C.Card, Parent = keyBox })
	corner(pb, 8)
	makeIcon(pb, "paste", 16, C.Electric, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5) })
	bind(pb.Activated:Connect(function()
		Sfx.play("Click")
		local v = Env.clipboardGet()
		if v then input.Text = (v:gsub("^%s+", ""):gsub("%s+$", "")) end
	end))
end
bind(input.Focused:Connect(function()
	tw(keyStroke, 0.2, { Color = C.Violet }); setIconColor(keyIcon, C.Violet)
end))
bind(input.FocusLost:Connect(function()
	tw(keyStroke, 0.2, { Color = C.Stroke }); setIconColor(keyIcon, C.Muted)
end))

-- status
local statusRow = new("Frame", { Position = UDim2.fromOffset(0, 76), Size = UDim2.new(1, 0, 0, 22),
	BackgroundTransparency = 1, Parent = vWrap })
local statusIconHolder = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(18, 18),
	Position = UDim2.fromOffset(0, 2), Parent = statusRow })
local statusLabel = text(statusRow, "Aguardando sua Key.", 13, C.Muted, Enum.Font.GothamMedium,
	{ Position = UDim2.fromOffset(26, 0), Size = UDim2.new(1, -26, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd })

local function setStatus(kind, msg)
	local col = ({ error = C.Error, success = C.Success, loading = C.Electric, idle = C.Muted })[kind] or C.Muted
	statusIconHolder:ClearAllChildren()
	if kind == "loading" then Spinner(statusIconHolder, 16, col).Position = UDim2.fromOffset(1, 1)
	elseif kind == "error" then makeIcon(statusIconHolder, "error", 18, col)
	elseif kind == "success" then makeIcon(statusIconHolder, "success", 18, col)
	else makeIcon(statusIconHolder, "key", 18, col) end
	statusLabel.Text = msg
	statusLabel.TextColor3 = col
	statusLabel.TextTransparency = 1
	statusLabel.Position = UDim2.fromOffset(26, 6)
	tw(statusLabel, 0.3, { TextTransparency = 0, Position = UDim2.fromOffset(26, 0) })
end
local function shake(obj)
	local p = obj.Position
	task.spawn(function()
		for _, dx in ipairs({ 7, -7, 5, -5, 2, 0 }) do
			twWait(obj, 0.045, { Position = UDim2.new(p.X.Scale, p.X.Offset + dx, p.Y.Scale, p.Y.Offset) }, Enum.EasingStyle.Sine)
		end
	end)
end
setStatus("idle", "Aguardando sua Key.")

-- linha de botões
local btnRow = new("Frame", { Position = UDim2.fromOffset(0, 108), Size = UDim2.new(1, 0, 0, 46),
	BackgroundTransparency = 1, Parent = vWrap })
local verifyBtn, verifyLabel, verifyIcon = Button(btnRow, "Verify Key", "verify", "primary",
	UDim2.new(0.5, -5, 1, 0), UDim2.new())
local getBtn, getLabel = Button(btnRow, "Get Key", "link", "secondary",
	UDim2.new(0.5, -5, 1, 0), UDim2.new(0.5, 5, 0, 0))

local executeBtn = Button(vWrap, "Execute", "execute", "success", UDim2.new(1, 0, 0, 46), UDim2.fromOffset(0, 162))
executeBtn.Visible = false
local executeScale = executeBtn:FindFirstChildOfClass("UIScale")

-- ── Get Key: provider único ou dropdown ─────────────────────────
local Providers = {}
for _, p in ipairs(Config.KeyProviders) do table.insert(Providers, p) end

local dropdown, catcher
local dropOpen = false
local function closeDropdown(silent)
	if not dropOpen then return end
	dropOpen = false
	if not silent then Sfx.play("DropdownClose") end
	catcher.Visible = false
	local d = dropdown
	tw(d, 0.15, { GroupTransparency = 1 })
	task.delay(0.15, function() if not dropOpen then d.Visible = false end end)
end

local function openProvider(p)
	local ok, why = Env.openLink(p.Url)
	if ok == true then setStatus("idle", "Abrindo: " .. p.Name)
	elseif ok == "copied" then setStatus("success", "Link copiado! Cole no navegador.")
	elseif why == "invalid" then Sfx.play("Error"); setStatus("error", "URL inválida para \"" .. p.Name .. "\".")
	else Sfx.play("Error"); setStatus("error", "Este ambiente não consegue abrir links.") end
end

local rebuildDropdown
rebuildDropdown = function()
	if dropdown then dropdown:Destroy() end
	if catcher then catcher:Destroy() end
	catcher = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
		Visible = false, ZIndex = 20, AutoButtonColor = false, Parent = vWrap })
	bind(catcher.Activated:Connect(function() closeDropdown() end))
	local count = #Providers
	dropdown = new("CanvasGroup", { AnchorPoint = Vector2.new(1, 1), BackgroundColor3 = C.Card,
		Size = UDim2.fromOffset(200, math.min(count, 4) * 38 + 12), Position = UDim2.new(1, 0, 0, 100),
		Visible = false, GroupTransparency = 1, ZIndex = 21, Parent = vWrap })
	corner(dropdown, 12); stroke(dropdown, C.Violet, 1, 0.4)
	local list = new("ScrollingFrame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScrollBarThickness = 3,
		ScrollBarImageColor3 = C.Violet, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0, ZIndex = 22, Parent = dropdown })
	pad(list, 6)
	new("UIListLayout", { Padding = UDim.new(0, 2), Parent = list })
	for _, p in ipairs(Providers) do
		local it = new("TextButton", { Text = "", AutoButtonColor = false, Size = UDim2.new(1, 0, 0, 36),
			BackgroundColor3 = C.Violet, BackgroundTransparency = 1, ZIndex = 23, Parent = list })
		corner(it, 8)
		makeIcon(it, p.Icon or "link", 16, C.Electric, { Position = UDim2.new(0, 10, 0.5, -8), ZIndex = 24 })
		text(it, p.Name, 13, C.Text, Enum.Font.GothamMedium, { Position = UDim2.fromOffset(34, 0),
			Size = UDim2.new(1, -40, 1, 0), ZIndex = 24, TextTruncate = Enum.TextTruncate.AtEnd })
		bind(it.MouseEnter:Connect(function() tw(it, 0.12, { BackgroundTransparency = 0.82 }) end))
		bind(it.MouseLeave:Connect(function() tw(it, 0.12, { BackgroundTransparency = 1 }) end))
		bind(it.Activated:Connect(function()
			Sfx.play("Click"); closeDropdown(true); openProvider(p)
		end))
	end
end
rebuildDropdown()

bind(getBtn.Activated:Connect(function()
	if State ~= "Idle" and State ~= "Success" then return end
	Sfx.play("Click")
	if #Providers == 0 then
		Sfx.play("Error"); setStatus("error", "Nenhum link de Key configurado."); return
	elseif #Providers == 1 then
		openProvider(Providers[1]); return
	end
	if dropOpen then closeDropdown(); return end
	dropOpen = true; Sfx.play("DropdownOpen")
	catcher.Visible = true; dropdown.Visible = true
	dropdown.Position = UDim2.new(1, 0, 0, 106)
	tw(dropdown, 0.22, { GroupTransparency = 0, Position = UDim2.new(1, 0, 0, 100) }, Enum.EasingStyle.Back)
end))

-- ── Validação ───────────────────────────────────────────────────
local Messages = {
	valid = "Key validada com sucesso!",
	invalid = "Key inválida. Verifique e tente novamente.",
	expired = "Esta Key expirou. Obtenha uma nova.",
	error = "Falha ao validar. Tente novamente.",
	timeout = "Tempo esgotado ao contatar o verificador.",
	network = "Erro de rede. Verifique sua conexão.",
	malformed = "Resposta inválida do verificador.",
	not_configured = "Validador não configurado pelo proprietário.",
}

local function defaultHttpAdapter(key)
	local h = Config.Validation.Http
	if h.Url == "" or type(h.BuildUrl) ~= "function" or type(h.Parse) ~= "function" then
		return { ok = false, status = "not_configured" }
	end
	local okUrl, url = pcall(h.BuildUrl, h.Url, key)
	if not okUrl or type(url) ~= "string" then return { ok = false, status = "malformed" } end
	local body = Env.httpGet(url)
	if not body then return { ok = false, status = "network" } end
	local okJ, data = pcall(function() return HttpService:JSONDecode(body) end)
	local okP, res = pcall(h.Parse, okJ and data or nil, body)
	if not okP then return { ok = false, status = "malformed" } end
	return res
end

local function runValidator(key)
	local adapter = Config.Validation.Adapter or defaultHttpAdapter
	local result, done = nil, false
	task.spawn(function()
		local ok, res = pcall(adapter, key)
		result = ok and res or { ok = false, status = "error" }
		done = true
	end)
	local t0 = os.clock()
	while not done and os.clock() - t0 < Config.Validation.Timeout do task.wait(0.05) end
	if not done then return { ok = false, status = "timeout" } end
	if type(result) ~= "table" or type(result.ok) ~= "boolean" then return { ok = false, status = "malformed" } end
	return result
end

local function revealExecute()
	executeBtn.Visible = true
	executeScale.Scale = 0.85
	for _, d in ipairs(executeBtn:GetDescendants()) do
		if d:IsA("TextLabel") then d.TextTransparency = 1; tw(d, 0.3, { TextTransparency = 0 }) end
	end
	executeBtn.BackgroundTransparency = 1
	tw(executeBtn, 0.35, { BackgroundTransparency = 0 })
	tw(executeScale, 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
end

local function verify()
	if State ~= "Idle" then return end
	closeDropdown(true)
	local key = (input.Text:gsub("^%s+", ""):gsub("%s+$", ""))
	if key == "" then
		Sfx.play("Error"); setStatus("error", "Digite ou cole sua Key primeiro."); shake(keyBox); return
	end
	State = "Validating"
	Sfx.play("Validate")
	verifyLabel.Text = "Validando..."
	tw(verifyBtn, 0.2, { BackgroundTransparency = 0.4 })
	setStatus("loading", "Validando sua Key...")
	local res = runValidator(key)
	if State ~= "Validating" then return end -- fechou durante a validação
	tw(verifyBtn, 0.2, { BackgroundTransparency = 0 })
	verifyLabel.Text = "Verify Key"
	if res.ok and (res.status == nil or res.status == "valid") then
		State = "Success"; KeyValidated = true
		Sfx.play("Success")
		setStatus("success", res.message or Messages.valid)
		tw(keyStroke, 0.3, { Color = C.Success })
		input.TextEditable = false
		if Config.RequireKeyToExecute then revealExecute() end
	else
		State = "Idle"
		Sfx.play("Error")
		setStatus("error", res.message or Messages[res.status] or Messages.invalid)
		tw(keyStroke, 0.15, { Color = C.Error })
		task.delay(0.9, function() if State == "Idle" then tw(keyStroke, 0.3, { Color = C.Stroke }) end end)
		shake(keyBox)
	end
end
bind(verifyBtn.Activated:Connect(verify))
bind(input.FocusLost:Connect(function(enter) if enter then verify() end end))

-- ════════════════════════════════════════════════════════════════
--  ABA 2 — PLAYER
-- ════════════════════════════════════════════════════════════════
local pp = pages.player
local pScroll = new("ScrollingFrame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), BorderSizePixel = 0,
	ScrollBarThickness = 3, ScrollBarImageColor3 = C.Violet, CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = pp })
pad(pScroll, 18, 12, 18, 14)
new("UIListLayout", { Padding = UDim.new(0, 8), Parent = pScroll })

local function Card(parent, order, height)
	local c = new("Frame", { Size = UDim2.new(1, 0, 0, height or 48), BackgroundColor3 = C.Card, LayoutOrder = order, Parent = parent })
	corner(c, 12); stroke(c, C.Stroke, 1, 0.35)
	return c
end
local function InfoRow(order, iconName, imageUrl, title)
	local c = Card(pScroll, order)
	local lead
	if imageUrl then
		lead = new("ImageLabel", { Size = UDim2.fromOffset(34, 34), Position = UDim2.new(0, 8, 0.5, -17),
			BackgroundColor3 = C.Field, Image = imageUrl, ScaleType = Enum.ScaleType.Crop, Parent = c })
		corner(lead); stroke(lead, C.Violet, 1.2, 0.3)
	else
		local bg = new("Frame", { Size = UDim2.fromOffset(34, 34), Position = UDim2.new(0, 8, 0.5, -17),
			BackgroundColor3 = C.Field, Parent = c })
		corner(bg, 10)
		makeIcon(bg, iconName, 17, C.Electric, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5) })
		lead = bg
	end
	text(c, title, 11, C.Muted, Enum.Font.GothamBold, { Position = UDim2.fromOffset(52, 7), Size = UDim2.new(1, -62, 0, 14) })
	local val = text(c, "N/D", 14, C.Text, Enum.Font.GothamBold, { Position = UDim2.fromOffset(52, 23),
		Size = UDim2.new(1, -62, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd })
	return val, lead
end

local gameVal = InfoRow(1, "game", ("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.GameId), "EXPERIÊNCIA")
local playerVal = InfoRow(2, "player", ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(LocalPlayer.UserId), "JOGADOR")
local execVal = InfoRow(3, "executor", nil, "EXECUTOR")
local fpsVal = InfoRow(4, "fps", nil, "FPS")
local pingVal = InfoRow(5, "ping", nil, "PING")
local devVal = InfoRow(6, "device", nil, "ENTRADA / DISPOSITIVO")

playerVal.Text = ("%s  ·  @%s"):format(LocalPlayer.DisplayName, LocalPlayer.Name)
gameVal.Text = "Carregando..."
task.spawn(function()
	local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
	gameVal.Text = (ok and info and info.Name) or "N/D"
end)
execVal.Text = Env.executor() or "Não detectado"
do
	local t, k, g = UserInputService.TouchEnabled, UserInputService.KeyboardEnabled, UserInputService.GamepadEnabled
	devVal.Text = (t and not k) and "Celular / Tablet (toque)" or (g and not k and "Console / Controle")
		or (k and "Computador (teclado/mouse)") or "Não detectado"
end

-- FPS/Ping: leitura espaçada, nunca por frame pesado
local frames, fpsClock = 0, os.clock()
bind(RunService.Heartbeat:Connect(function() frames += 1 end))
task.spawn(function()
	while State ~= "Closed" do
		task.wait(1)
		local now = os.clock()
		local fps = frames / math.max(now - fpsClock, 0.001)
		frames, fpsClock = 0, now
		if activeTab == "player" and not Minimized then
			fpsVal.Text = ("%d FPS"):format(math.floor(fps + 0.5))
			local ok, ping = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
			pingVal.Text = (ok and type(ping) == "number") and ("%d ms"):format(math.floor(ping + 0.5)) or "N/D"
		end
	end
end)

-- Áudio
do
	local c = Card(pScroll, 7, 74)
	text(c, "ÁUDIO", 11, C.Muted, Enum.Font.GothamBold, { Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -90, 0, 14) })
	local tg = new("TextButton", { Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 8),
		Size = UDim2.fromOffset(44, 24), BackgroundColor3 = Config.Audio.Enabled and C.Violet or C.Field, Parent = c })
	corner(tg); stroke(tg, C.Stroke, 1, 0.3)
	local knob = new("Frame", { Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(0, 0.5),
		Position = Config.Audio.Enabled and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		BackgroundColor3 = C.Text, Parent = tg })
	corner(knob)
	local function refreshAudio()
		local on = Config.Audio.Enabled
		tw(tg, 0.2, { BackgroundColor3 = on and C.Violet or C.Field })
		tw(knob, 0.25, { Position = on and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }, Enum.EasingStyle.Back)
	end
	local function toggleAudio()
		Config.Audio.Enabled = not Config.Audio.Enabled
		refreshAudio()
		if Config.Audio.Enabled then Sfx.play("Click") end
	end
	bind(tg.Activated:Connect(toggleAudio))
	bind(audioBtn.Activated:Connect(toggleAudio))
	-- slider de volume
	local track = new("Frame", { Position = UDim2.new(0, 14, 0, 46), Size = UDim2.new(1, -28, 0, 6), BackgroundColor3 = C.Field, Parent = c })
	corner(track)
	local fill = new("Frame", { Size = UDim2.fromScale(Config.Audio.Volume, 1), BackgroundColor3 = C.Violet, Parent = track })
	corner(fill); gradient(fill, C.Violet, C.Orange, 0)
	local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Position = UDim2.new(0, 14, 0, 36),
		Size = UDim2.new(1, -28, 0, 26), Parent = c })
	local dragging = false
	local function setFromX(x)
		local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		Config.Audio.Volume = a; fill.Size = UDim2.fromScale(a, 1)
	end
	bind(hit.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true; setFromX(i.Position.X)
		end
	end))
	bind(UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			setFromX(i.Position.X)
		end
	end))
	bind(UserInputService.InputEnded:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
			dragging = false; Sfx.play("Click")
		end
	end))
end

-- ════════════════════════════════════════════════════════════════
--  ABA 3 — CREDITS
-- ════════════════════════════════════════════════════════════════
local cp = pages.credits
local cScroll = new("ScrollingFrame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), BorderSizePixel = 0,
	ScrollBarThickness = 3, ScrollBarImageColor3 = C.Violet, CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = cp })
pad(cScroll, 18, 12, 18, 14)
new("UIListLayout", { Padding = UDim.new(0, 8), Parent = cScroll })

local Credits = {}
for _, c in ipairs(Config.Credits) do table.insert(Credits, c) end

local RoleStyle = {
	owner = { C.Orange, "owner" }, proprietário = { C.Orange, "owner" }, proprietario = { C.Orange, "owner" },
	creator = { C.Violet, "credits" }, criador = { C.Violet, "credits" },
	developer = { C.Electric, "developer" }, desenvolvedor = { C.Electric, "developer" },
	admin = { C.Success, "admin" }, administrador = { C.Success, "admin" },
	["ui designer"] = { Color3.fromHex("F472B6"), "credits" }, designer = { Color3.fromHex("F472B6"), "credits" },
	contributor = { C.Muted, "player" }, colaborador = { C.Muted, "player" },
}

local function rebuildCredits()
	for _, ch in ipairs(cScroll:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
	if #Credits == 0 then
		local c = Card(cScroll, 1, 70)
		text(c, "Nenhum crédito configurado.\nEdite Config.Credits ou use AddCredit().", 13, C.Muted, Enum.Font.Gotham,
			{ Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = true })
		return
	end
	for i, cr in ipairs(Credits) do
		local style = RoleStyle[(cr.Role or ""):lower()] or { C.Electric, "credits" }
		local card = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = C.Card, LayoutOrder = i, Parent = cScroll })
		corner(card, 12); stroke(card, C.Stroke, 1, 0.35); pad(card, 10)
		local lead
		if cr.Image and cr.Image ~= "" then
			lead = new("ImageLabel", { Size = UDim2.fromOffset(40, 40), BackgroundColor3 = C.Field,
				Image = normImage(cr.Image), ScaleType = Enum.ScaleType.Crop, Parent = card })
			corner(lead)
		else
			lead = new("Frame", { Size = UDim2.fromOffset(40, 40), BackgroundColor3 = C.Field, Parent = card })
			corner(lead)
			makeIcon(lead, cr.Icon or style[2], 20, style[1], { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5) })
		end
		stroke(lead, style[1], 1.2, 0.35)
		local right = cr.Link and cr.Link ~= "" and 40 or 0
		local info = new("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(52, 0),
			Size = UDim2.new(1, -52 - right, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = card })
		new("UIListLayout", { Padding = UDim.new(0, 3), Parent = info })
		local top = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 1, Parent = info })
		new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8), Parent = top })
		text(top, cr.Name or "?", 14, C.Text, Enum.Font.GothamBold, { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0) })
		local badge = new("Frame", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 18),
			BackgroundColor3 = style[1], BackgroundTransparency = 0.82, Parent = top })
		corner(badge); stroke(badge, style[1], 1, 0.5); pad(badge, 8, 0, 8, 0)
		text(badge, cr.Role or "Contributor", 10, style[1], Enum.Font.GothamBold, { AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0) })
		if cr.Description and cr.Description ~= "" then
			text(info, cr.Description, 12, C.Muted, Enum.Font.Gotham, { Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, LayoutOrder = 2 })
		end
		if right > 0 then
			local lb = new("TextButton", { Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0), Size = UDim2.fromOffset(34, 34), BackgroundColor3 = C.Field, Parent = card })
			corner(lb, 10)
			makeIcon(lb, "link", 16, C.Electric, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5) })
			bind(lb.Activated:Connect(function()
				Sfx.play("Click")
				local ok, why = Env.openLink(cr.Link)
				if ok == "copied" then setStatus("success", "Link copiado!")
				elseif not ok then setStatus("error", why == "invalid" and "URL inválida." or "Não foi possível abrir o link.") end
			end))
		end
	end
end
rebuildCredits()

-- ════════════════════════════════════════════════════════════════
--  ESFERAS ORBITAIS
-- ════════════════════════════════════════════════════════════════
local Spheres = {}
local function resolveImage(v)
	if v == "auto:game" then return ("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.GameId) end
	if v == "auto:player" then return ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(LocalPlayer.UserId) end
	return normImage(v) or ""
end

local function layoutSpheres()
	local byRing = {}
	for i, s in ipairs(Spheres) do
		s.ringIdx = s.Ring or math.floor((i - 1) / Config.Orbit.PerRing)
		byRing[s.ringIdx] = byRing[s.ringIdx] or {}
		table.insert(byRing[s.ringIdx], s)
	end
	for r, list in pairs(byRing) do
		for j, s in ipairs(list) do
			s.angle = (j - 1) / #list * math.pi * 2 + r * 0.6
			s.dirEff = s.Direction or ((r % 2 == 0) and 1 or -1)
		end
	end
end

local function buildSphereGui(s)
	local holder = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
		Size = UDim2.fromOffset(0, 0), Visible = false, Parent = sphereLayer })
	local glow = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1.35, 1.35), BackgroundColor3 = s.BorderColor or C.Violet, BackgroundTransparency = 0.86, Parent = holder })
	corner(glow)
	local body = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.Panel, Parent = holder })
	corner(body)
	local st = stroke(body, Color3.new(1, 1, 1), 2, 0)
	new("UIGradient", { Color = ColorSequence.new(s.BorderColor or C.Violet, C.Orange), Rotation = 45, Parent = st })
	local img = new("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -6, 1, -6), BackgroundColor3 = C.Field, Image = "", ScaleType = Enum.ScaleType.Crop, Parent = body })
	corner(img)
	-- fallback visual (também usado enquanto/por falta de imagem)
	local fb = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), Visible = false, Parent = img })
	corner(fb); gradient(fb, C.Violet, C.Purple, 45)
	local fbIcon = makeIcon(fb, s.Icon or (s.UseBrand and Config.BrandIcon) or "key", 20, C.Text,
		{ AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5) })
	local function showFallback() fb.Visible = true end

	local url = resolveImage(s.UseBrand and Config.BrandImage ~= "" and Config.BrandImage or s.Image)
	if url == "" then showFallback()
	else
		img.Image = url
		task.spawn(function()
			local ok = pcall(function()
				ContentProvider:PreloadAsync({ img }, function(_, status)
					if status ~= Enum.AssetFetchStatus.Success then showFallback() end
				end)
			end)
			if not ok then showFallback() end
		end)
	end
	if Config.Orbit.ShowNames and s.Name then
		text(holder, s.Name, 11, C.Muted, Enum.Font.GothamMedium, { AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, 8), Size = UDim2.fromOffset(90, 14), TextXAlignment = Enum.TextXAlignment.Center })
	end
	s.gui = holder
end

local function addSphere(def)
	local s = {}
	for k, v in pairs(def) do s[k] = v end
	s.Size = s.Size or Config.Orbit.SphereSize
	s.Speed = s.Speed or 1
	table.insert(Spheres, s)
	buildSphereGui(s)
	layoutSpheres()
	return s
end
for _, d in ipairs(Config.Spheres) do addSphere(d) end

local function posToPx(u, vpx)
	return Vector2.new(vpx.X * u.X.Scale + u.X.Offset, vpx.Y * u.Y.Scale + u.Y.Offset)
end

-- Bolha de minimizar
local bubblePos = UDim2.new(1, -60, 0.5, 0)
local bubble = new("TextButton", { Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(0.5, 0.5),
	Position = bubblePos, Size = UDim2.fromOffset(BUBBLE, BUBBLE), BackgroundColor3 = Color3.new(1, 1, 1),
	Visible = false, ZIndex = 8, Parent = gui })
corner(bubble); gradient(bubble, C.Violet, C.Purple, 45); stroke(bubble, C.Orange, 1.6, 0.2)
local bubbleScale = new("UIScale", { Scale = 0.01, Parent = bubble })
if Config.BrandImage ~= "" then
	new("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4),
		Image = normImage(Config.BrandImage), ScaleType = Enum.ScaleType.Crop, Parent = bubble }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) })
else
	makeIcon(bubble, Config.BrandIcon, 26, C.Text, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5) })
end

-- Loop da órbita (único loop contínuo da animação)
local function orbitStep(dt)
	if State == "Closed" then return end
	local vpx = gui.AbsoluteSize
	local m = orb.minimized.Value
	local center = posToPx(panelPos, vpx):Lerp(posToPx(bubblePos, vpx), m)
	local half = Vector2.new(W / 2 * baseScale, H / 2 * baseScale):Lerp(Vector2.new(BUBBLE / 2, BUBBLE / 2), m)
	local ringScale = lerp(1, Config.Orbit.MinimizedScale, m)
	local k = orb.spread.Value * (1 - orb.absorb.Value)
	local sizeMul = orb.size.Value * (1 - orb.absorb.Value) * lerp(1, 0.78, m)
	local speedMul = orb.speed.Value
	local pw = 2 / Config.Orbit.Squareness
	for _, s in ipairs(Spheres) do
		s.angle += dt * Config.Orbit.BaseSpeed * s.Speed * s.dirEff * speedMul
		local r = (Config.Orbit.Gap + s.ringIdx * Config.Orbit.RingStep + s.Size * 0.5) * baseScale * ringScale
		local c, sn = math.cos(s.angle), math.sin(s.angle)
		local x = (half.X + r) * k * math.sign(c) * math.abs(c) ^ pw
		local y = (half.Y + r) * k * math.sign(sn) * math.abs(sn) ^ pw
		local depth = (sn + 1) / 2
		local sz = s.Size * baseScale * sizeMul * (0.88 + 0.12 * depth)
		local g = s.gui
		if sz < 1.5 then g.Visible = false
		else
			g.Visible = true
			g.Position = UDim2.fromOffset(center.X + x, center.Y + y)
			g.Size = UDim2.fromOffset(sz, sz)
		end
	end
end
bind(RunService.RenderStepped:Connect(orbitStep))

-- Escala responsiva
local function updateScale()
	local vpx = gui.AbsoluteSize
	if vpx.X < 10 then return end
	local reach = 2 * (Config.Orbit.Gap + Config.Orbit.SphereSize) + 24
	local s = math.min(vpx.X / (W + reach), vpx.Y / (H + reach))
	baseScale = math.clamp(s, Config.Window.MinScale, Config.Window.MaxScale)
	applyScale()
end
bind(gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale))
updateScale()

-- ════════════════════════════════════════════════════════════════
--  ARRASTAR (mouse e toque)
-- ════════════════════════════════════════════════════════════════
local function draggable(handle, getPos, setPos, onTap)
	local dragging, start, origin, moved = false, nil, nil, 0
	bind(handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			if State == "Opening" or State == "Closing" or State == "Executing" or State == "Closed" or Busy then return end
			dragging, start, origin, moved = true, i.Position, getPos(), 0
			local conn
			conn = i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false; conn:Disconnect()
					if onTap and moved < 8 then onTap() end
				end
			end)
		end
	end))
	bind(UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - start
			moved = math.max(moved, d.Magnitude)
			local vpx = gui.AbsoluteSize
			local p = origin
			local nx = p.X.Offset + d.X
			local ny = p.Y.Offset + d.Y
			-- mantém o centro dentro da tela
			local cx = vpx.X * p.X.Scale + nx
			local cy = vpx.Y * p.Y.Scale + ny
			nx += math.clamp(cx, 20, vpx.X - 20) - cx
			ny += math.clamp(cy, 20, vpx.Y - 20) - cy
			setPos(UDim2.new(p.X.Scale, nx, p.Y.Scale, ny))
		end
	end))
end
draggable(titleBar, function() return panelPos end, function(p) panelPos = p; panel.Position = p end)

-- ════════════════════════════════════════════════════════════════
--  MINIMIZAR / RESTAURAR
-- ════════════════════════════════════════════════════════════════
local function minimize()
	if Busy or Minimized or (State ~= "Idle" and State ~= "Success" and State ~= "Validating") then return end
	Busy = true; Minimized = true
	closeDropdown(true); Sfx.play("Minimize")
	tw(orb.minimized, 0.6, { Value = 1 }, Enum.EasingStyle.Quint)
	tw(panel, 0.45, { GroupTransparency = 1, Position = bubblePos }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	tw(panelAnim, 0.45, { Value = 0.05 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	task.wait(0.4)
	panel.Visible = false
	bubble.Visible = true
	tw(bubbleScale, 0.4, { Scale = 1 }, Enum.EasingStyle.Back)
	Busy = false
end
local function restore()
	if Busy or not Minimized then return end
	Busy = true
	Sfx.play("Restore")
	bubblePos = bubble.Position
	tw(bubbleScale, 0.25, { Scale = 0.01 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	panel.Position = bubblePos
	panel.Visible = true
	tw(orb.minimized, 0.6, { Value = 0 }, Enum.EasingStyle.Quint)
	tw(panel, 0.5, { GroupTransparency = 0, Position = panelPos }, Enum.EasingStyle.Quint)
	tw(panelAnim, 0.5, { Value = 1 }, Enum.EasingStyle.Back)
	task.wait(0.3)
	bubble.Visible = false
	Minimized = false
	Busy = false
end
bind(minBtn.Activated:Connect(minimize))
draggable(bubble, function() return bubble.Position end, function(p) bubble.Position = p; bubblePos = p end, restore)

-- ════════════════════════════════════════════════════════════════
--  ABERTURA
-- ════════════════════════════════════════════════════════════════
local T = Config.Timings
local function openSequence()
	State = "Opening"
	Sfx.play("Open")
	panel.Visible = true
	panelAnim.Value = 0.88
	panel.Position = UDim2.new(panelPos.X.Scale, panelPos.X.Offset, panelPos.Y.Scale, panelPos.Y.Offset + 18)

	-- barra de carregamento (representa a preparação da UI, não a validação)
	local bar = new("CanvasGroup", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(250, 44), BackgroundTransparency = 1, GroupTransparency = 1, ZIndex = 6, Parent = gui })
	local barText = text(bar, "Preparando interface...", 13, C.Text, Enum.Font.GothamMedium,
		{ Size = UDim2.new(1, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Center })
	local track = new("Frame", { Position = UDim2.fromOffset(0, 28), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = C.Card, Parent = bar })
	corner(track); stroke(track, C.Stroke, 1, 0.3)
	local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = Color3.new(1, 1, 1), Parent = track })
	corner(fill); gradient(fill, C.Violet, C.Orange, 0)

	-- 1-2: das posições centrais para a órbita inicial
	tw(orb.size, T.Burst, { Value = 1 }, Enum.EasingStyle.Back)
	tw(orb.spread, T.Burst, { Value = Config.Orbit.IntroSpread }, Enum.EasingStyle.Back)
	task.wait(T.Burst * 0.7)

	-- 3: carregamento real (ícones + imagens) em paralelo à barra
	local loaded = false
	task.spawn(function()
		Icons.load()
		for _, ic in ipairs(registry) do applyIcon(ic) end
		pcall(function()
			local assets = {}
			for _, s in ipairs(Spheres) do table.insert(assets, s.gui) end
			ContentProvider:PreloadAsync(assets)
		end)
		loaded = true
	end)
	tw(bar, 0.3, { GroupTransparency = 0 })
	tw(fill, T.Loading, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	task.delay(T.Loading * 0.5, function() barText.Text = "Carregando recursos..." end)
	task.wait(T.Loading)
	local t0 = os.clock()
	while not loaded and os.clock() - t0 < Config.Icons.Timeout + 3 do task.wait(0.05) end
	barText.Text = "Pronto!"
	task.wait(0.2)
	tw(bar, 0.25, { GroupTransparency = 1 })

	-- 4: convergem ao centro
	twWait(orb.spread, T.Converge, { Value = 0.02 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	bar:Destroy()

	-- 5-6: expandem para a órbita final enquanto o painel é revelado
	tw(orb.spread, T.Expand, { Value = 1 }, Enum.EasingStyle.Back)
	task.wait(T.Expand * 0.35)
	tw(panel, T.Reveal, { GroupTransparency = 0, Position = panelPos }, Enum.EasingStyle.Quint)
	tw(panelAnim, T.Reveal, { Value = 1 }, Enum.EasingStyle.Back)
	task.wait(T.Reveal)
	State = "Idle" -- 7: a órbita continua no RenderStepped
end

-- ════════════════════════════════════════════════════════════════
--  FECHAR / EXECUTAR
-- ════════════════════════════════════════════════════════════════
local API = {}
local function destroy()
	State = "Closed"
	for _, c in ipairs(Maid) do pcall(function() c:Disconnect() end) end
	table.clear(Maid)
	for _, s in pairs(Sfx.cache) do s:Destroy() end
	if gui then gui:Destroy() end
	local env = type(getgenv) == "function" and getgenv() or _G
	if env.CoiledTomKeySystem == API then env.CoiledTomKeySystem = nil end
end

local function closeSequence(execute)
	if State == "Opening" or State == "Closing" or State == "Executing" or State == "Closed" or Busy then return end
	if execute and not KeyValidated and Config.RequireKeyToExecute then return end
	State = execute and "Executing" or "Closing"
	Busy = true
	closeDropdown(true)
	Sfx.play(execute and "Execute" or "Close")

	-- se estiver minimizado (não ocorre pela UI, mas por segurança)
	if Minimized then bubble.Visible = false end

	-- 1-2: acelera e entra em espiral
	tw(orb.speed, T.SpinUp + T.Absorb * 0.5, { Value = T.SpeedBoost }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	task.wait(T.SpinUp)

	-- núcleo de energia (para onde tudo é absorvido)
	local vpx = gui.AbsoluteSize
	local center = posToPx(panelPos, vpx)
	local core = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(center.X, center.Y),
		Size = UDim2.fromOffset(0, 0), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 9, Parent = gui })
	corner(core); gradient(core, C.Electric, C.Violet, 45); stroke(core, C.Orange, 2, 0.1)

	-- 3-4: esferas encolhem e o painel é absorvido
	tw(orb.absorb, T.Absorb, { Value = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	task.delay(T.Absorb * 0.15, function()
		tw(panel, T.Absorb * 0.8, { GroupTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		tw(panelAnim, T.Absorb * 0.8, { Value = 0.06 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	end)
	task.delay(T.Absorb * 0.45, function()
		tw(core, T.Absorb * 0.55, { Size = UDim2.fromOffset(46 * baseScale, 46 * baseScale) }, Enum.EasingStyle.Quad)
	end)
	task.wait(T.Absorb)
	twWait(core, 0.25, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	-- 5-6: finaliza; só Execute chama o callback (uma vez)
	local callback = Config.OnExecute
	destroy()
	if execute and type(callback) == "function" then
		task.spawn(function()
			local ok, err = pcall(callback)
			if not ok then warn("[CoiledTom] Erro em OnExecute: " .. tostring(err)) end
		end)
	end
end

bind(closeBtn.Activated:Connect(function() closeSequence(false) end))
bind(executeBtn.Activated:Connect(function() closeSequence(true) end))

-- ════════════════════════════════════════════════════════════════
--  API PÚBLICA
-- ════════════════════════════════════════════════════════════════
API.AddSphere = addSphere
function API.AddKeyProvider(p)
	if type(p) ~= "table" or not p.Name or not p.Url then warn("[CoiledTom] AddKeyProvider: precisa de Name e Url"); return end
	table.insert(Providers, p)
	rebuildDropdown()
end
function API.AddCredit(c)
	if type(c) ~= "table" or not c.Name then warn("[CoiledTom] AddCredit: precisa de Name"); return end
	table.insert(Credits, c)
	rebuildCredits()
end
API.Destroy = destroy
do
	local env = type(getgenv) == "function" and getgenv() or _G
	env.CoiledTomKeySystem = API
end

task.spawn(openSequence)
return API
