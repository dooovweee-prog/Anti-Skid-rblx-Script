------------------------------------------------------------------------
-- §1  SAFE NATIVES  (captured before any possible hook)
------------------------------------------------------------------------
local safe = {
	rawget       = rawget,
	rawset       = rawset,
	setmetatable = setmetatable,
	getmetatable = getmetatable,
	pairs        = pairs,
	ipairs       = ipairs,
	next         = next,
	tostring     = tostring,
	tonumber     = tonumber,
	type         = type,
	pcall        = pcall,
	select       = select,
	unpack       = table.unpack or unpack,
	insert       = table.insert,
	remove       = table.remove,
	concat       = table.concat,
	sort         = table.sort,
	format       = string.format,
	find         = string.find,
	gmatch       = string.gmatch,
	gsub         = string.gsub,
	sub          = string.sub,
	lower        = string.lower,
	upper        = string.upper,
	byte         = string.byte,
	char         = string.char,
	len          = string.len,
	rep          = string.rep,
	floor        = math.floor,
	ceil         = math.ceil,
	abs          = math.abs,
	max          = math.max,
	min          = math.min,
	random       = math.random,
	clock        = os.clock,
	time         = os.time,
	sin          = math.sin,
	cos          = math.cos,
	sqrt         = math.sqrt,
	huge         = math.huge,
	pi           = math.pi,
	clamp        = math.clamp,
}

------------------------------------------------------------------------
-- §1b  SHORT CONSTRUCTOR ALIASES
------------------------------------------------------------------------
local V3   = Vector3.new
local CF   = CFrame.new
local CFA  = CFrame.Angles
local LOOK = CFrame.lookAt

------------------------------------------------------------------------
-- §2  SERVICES
------------------------------------------------------------------------
local svc = {}
do
	local names = {
		"PathfindingService","RunService","Players","Stats",
		"Lighting","ServerStorage","HttpService",
		"ReplicatedStorage","ServerScriptService",
	}
	for _, n in safe.ipairs(names) do
		local ok, s = safe.pcall(function() return game:GetService(n) end)
		if ok and s then svc[n] = s end
	end
	-- DataStoreService may not be available in all contexts
	safe.pcall(function() svc.DataStoreService = game:GetService("DataStoreService") end)
end

------------------------------------------------------------------------
-- §3  INTEGRITY WHITELISTS
------------------------------------------------------------------------
local SAFE_API = {
	["Instance.new"]              = Instance.new,
	["game.GetService"]           = game.GetService,
	["game.GetDescendants"]       = game.GetDescendants,
	["workspace.GetDescendants"]  = workspace.GetDescendants,
	["Players.GetPlayers"]        = svc.Players.GetPlayers,
	["RunService.Heartbeat"]      = svc.RunService.Heartbeat,
	["HttpService.JSONEncode"]    = svc.HttpService.JSONEncode,
	["HttpService.JSONDecode"]    = svc.HttpService.JSONDecode,
}

local SAFE_GLOBALS = {
	rawget = rawget, rawset = rawset, setmetatable = setmetatable,
	getmetatable = getmetatable, pairs = pairs, ipairs = ipairs,
	next = next, tostring = tostring, tonumber = tonumber,
	type = type, pcall = pcall, xpcall = xpcall, error = error,
	select = select, require = require,
	["math.abs"]     = math.abs,    ["math.floor"]   = math.floor,
	["math.ceil"]    = math.ceil,   ["math.random"]  = math.random,
	["math.huge"]    = math.huge,   ["math.sqrt"]    = math.sqrt,
	["math.sin"]     = math.sin,    ["math.cos"]     = math.cos,
	["math.max"]     = math.max,    ["math.min"]     = math.min,
	["string.format"]= string.format,["string.find"]  = string.find,
	["string.gmatch"]= string.gmatch,["string.gsub"]  = string.gsub,
	["string.byte"]  = string.byte,  ["string.char"]  = string.char,
	["string.sub"]   = string.sub,   ["string.len"]   = string.len,
	["string.rep"]   = string.rep,   ["string.lower"] = string.lower,
	["string.upper"] = string.upper,
	["table.insert"] = table.insert, ["table.remove"] = table.remove,
	["table.concat"] = table.concat, ["table.sort"]   = table.sort,
	["table.unpack"] = table.unpack,
	["os.clock"]     = os.clock,     ["os.time"]      = os.time,
}

------------------------------------------------------------------------
-- §4  CONFIGURATION  (one table → 1 register)
------------------------------------------------------------------------
local cfg = {
	OWNER_NAME               = "210000100001000015",
	SPAWN_POS                = V3(0, 5, 0),
	BOOT_TIME                = safe.clock(),
	VERSION                  = "v14.0.0",
	UI_REFRESH               = 0.06,
	TREE_REBUILD             = 1.5,
	MAX_LOG_ENTRIES           = 150,
	FIX_COOLDOWN             = 20,
	SCAN_INTERVAL            = 8,
	SCAN_DEBOUNCE            = 1.0,
	SCAN_NEW                 = true,
	LOG_ADDS                 = true,
	SPAM_WINDOW              = 3.0,
	SPAM_THRESHOLD_DECAL     = 6,
	SPAM_THRESHOLD_PART      = 20,
	SPAM_THRESHOLD_GEN       = 12,
	SPAM_WARN_COOLDOWN       = 10.0,
	EMERG_SPIKE_THRESHOLD    = 300,
	EMERG_COOLDOWN           = 10.0,
	EMERG_CLEANUP_TICK       = 0.04,
	EMERG_NUKE_PER_TICK      = 250,
	EMERG_KICK_STRIKES       = 2,
	HB_WINDOW                = 0.25,
	REMOTE_FLOOD_THRESHOLD   = 60,
	MAX_STRING_ARG           = 512,
	MAX_ARGS                 = 12,
	MAX_INSTANCE_DEPTH       = 6,
	ARG_FLOOD_WINDOW         = 2.0,
	ARG_FLOOD_MAX            = 40,
	CMD_FLOOD_MAX            = 8,
	SD_MAX_STRIKES           = 2,
	MAX_WALKSPEED            = 50,
	MAX_JUMPPOWER            = 100,
	GRAVITY_MIN              = 0,
	GRAVITY_MAX              = 400,
	SAFE_GRAVITY             = 196.2,
	PROFILER_INTERVAL        = 5.0,
	PROFILER_ROWS            = 28,
	INTEGRITY_INTERVAL       = 2.0,
	G_POLL_INTERVAL          = 5.0,
	WALK_SPEED               = 16,
	LOOK_SPEED               = 7,
	STARE_DURATION           = 1.5,
	APPROACH_DIST            = 3,
	WANDER_RANGE             = 40,
	PAUSE_MIN                = 0.6,
	PAUSE_MAX                = 3.0,
	BROWSE_SPEED             = 0.12,
	BROWSE_VARIANCE          = 0.15,
	HUNT_SPEED               = 0.05,
	IMMORTAL                 = true,
	REGEN_RATE               = 2.5,
	VOID_Y                   = -150,
	FADE_TIME                = 0.30,
	FADE_STEPS               = 15,
	NPC_WATCHDOG_TICK        = 0.10,
	HUD_WATCHDOG_TICK        = 0.20,
	PATROL_RADIUS            = 25,
	PATROL_POINTS            = 6,
	PPS                      = 85,
	CARD_W                   = 17,
	CARD_H                   = 5.8,
	CARD_ABOVE               = 4.0,
	GUI_FLOOD_WINDOW         = 2.0,
	GUI_FLOOD_MAX            = 50,
	SOUND_MAX_VOLUME         = 2.0,
	SOUND_MAX_RATE           = 2.0,
	PARTICLE_MAX_RATE        = 300,
	FX_FLOOD_WINDOW          = 2.0,
	FX_FLOOD_MAX             = 20,
	EXPLOSION_FLOOD_MAX      = 8,
	BODYFORCE_MAX_MAG        = 5000,
	MODEL_MAX_PARTS          = 2000,
	STRINGVALUE_MAX_BYTES    = 102400,
	ATTR_MAX_KEYS            = 64,
	DESCENDANT_DESTROY_WINDOW = 1.0,
	DESCENDANT_DESTROY_MAX   = 300,
}
cfg.CARD_PX = cfg.CARD_W * cfg.PPS
cfg.CARD_PY = cfg.CARD_H * cfg.PPS

------------------------------------------------------------------------
-- §5  DETECTION SIGNATURES  (all lowercase for case-insensitive match)
------------------------------------------------------------------------
local sig = {}

-- Helper: build a set from a list (all stored lowercase)
local function makeSet(list)
	local s = {}
	for _, v in safe.ipairs(list) do s[safe.lower(v)] = true end
	return s
end

-- Helper: case-insensitive name check against a set
local function nameInSet(name, set)
	return set[safe.lower(name)] ~= nil
end

-- Helper: case-insensitive substring check against a set
local function nameMatchesAny(name, set)
	local nl = safe.lower(name)
	for key in safe.pairs(set) do
		if safe.find(nl, key, 1, true) then return true, key end
	end
	return false, ""
end

sig.backdoor_names = makeSet({
	-- Classic loaders / admin systems
	"MainModule","Loader","MainLoader","HD Admin","Kohls Admin",
	"ACS_Engine","Adonis_Engine","Epix_Engine","VanX_Engine",
	-- Core exploit keywords
	"Backdoor","Execute","Executor","ExecCmd","SendRequest","HttpRequest",
	"RequestHttp","GetRequest","Disable","Kill","Kick","Ban",
	"NetworkServer","NetworkClient","Replicate","Sync",
	"Anti_Cheat","AntiCheat_Bypass","Bypass","Unban",
	"RemoteExec","RemoteFire","ServerExec","LoadSrc",
	-- Crashers / lag
	"CrashServer","Crasher","Lag","Freeze","Infinite","MemoryLeak",
	"DDoS","FloodBots","SpawnBots",
	-- Obfuscators
	"Obfuscate","Obfuscator","LuaObf","LuaEncode","LuaDecode",
	"ByteEncode","HexEncode","Base64Encode","Base64Decode",
	"XorCipher","AesCipher","RoLua","IronBrew","IronBrew2",
	"Moonsec","Moonsec2","Moonsec3","Prometheus","PrometheusObf",
	"LBI","ByteStringObf","Vmify","PSU","Luraph",
	-- Executors
	"Synapse","SynapseX","KRNL","Krnl","Electron","Electron_Executor",
	"Fluxus","Script-Ware","ScriptWare","JJSploit","JJsploit",
	"Sentinel","Sentinel_Executor","SirHurt","WRD","Coco_Z","CocoZ",
	"Delta","DeltaExecutor","Arceus","ArceusFix","ArcXR","Evon","Wave",
	"Oxygen","OxygenU","Vega","VegaX","Temple","Tempest","Crypt","Valyse",
	"Trigon","TrigonEvo","Nihon","Nihon_X","Horizon","Velocity","Celery",
	"Celery_Executor","Macsploit","MacSploit","KawaX","Xeno","Xeno_Executor",
	"Cryptic","CrypticExecutor","Codex","CodexExecutor","Nexus","NexusFix",
	"Blade","BladeExploit","BladeX","Aspect","AspectFix","Rift","Rift_Executor",
	-- NEW: modern executors & hubs (2024-2026)
	"Solara","SolaraExecutor","Solara_Executor",
	"Zorara","ZoraraExecutor","Zorara_X",
	"AWP","AWP_Executor","AWPExec",
	"Swift","SwiftExecutor","Swift_Executor",
	"Krampus","KrampusExec","Krampus_Executor",
	"Nezur","NezurExecutor","Nezur_X",
	"Seliware","SeliwareExec",
	"Comet","CometExecutor","Comet_Exec",
	"PolariHub","Polaria","PolariaHub","Polari_Hub","polaria_hub",
	"ScriptBlox","Script_Blox","ScriptBloxHub",
	"PasteHub","Paste_Hub","PasteHubExec",
	"RoHub","Ro_Hub","RoHubScript",
	"ScriptSearcher","Script_Searcher",
	"UniversalHub","Universal_Hub","UniversalScript",
	"RaspberryHub","Raspberry_Hub",
	"AzureHub","Azure_Hub","AzureExec",
	"NexusHub","Nexus_Hub",
	"InfinityHub","Infinity_Hub",
	"VoidHub","Void_Hub","VoidScript",
	"OwlHub","Owl_Hub","OwlHubV2",
	"KittenHub","Kitten_Hub",
	"LinoriaLib","Linoria_Lib","LinoriaHub",
	"WallyHub","Wally_Hub","WallyHubV2",
	"SiriusHub","Sirius_Hub","SiriusLib",
	"RayHub","Ray_Hub","RayHubV2",
	"VenomHub","Venom_Hub",
	"PhantomHub","Phantom_Hub",
	"NitroHub","Nitro_Hub",
	"ZenithHub","Zenith_Hub",
	"ProtoHub","Proto_Hub",
	"MidasHub","Midas_Hub",
	"TitanHub","Titan_Hub",
	"OrbitHub","Orbit_Hub",
	"CatalystHub","Catalyst_Hub",
	"VortexHub","Vortex_Hub",
	"EclipseHub","Eclipse_Hub",
	"GhostHub","Ghost_Hub",
	-- Anti-skid / skid protections
	"AntiSkid","Anti_Skid","SkidDetect","Skid_Detect",
	"AntiDecompile","Anti_Decompile","NoDecompile",
	"AntiDump","Anti_Dump","NoDump",
	"AntiTamper","Anti_Tamper","TamperGuard",
	"AntiDebug","Anti_Debug","DebugDetect",
	"VMProtect","VM_Protect","VmGuard",
	"ObfGuard","Obf_Guard","CodeProtect",
	"SkidGuard","Skid_Guard","AntiCopy","Anti_Copy",
	"AntiPaste","Anti_Paste","PasteGuard",
	"SourceGuard","Source_Guard","SourceProtect",
	"AntiHook","Anti_Hook","HookGuard",
	"IntegrityCheck","Integrity_Check","HashCheck",
	"ChecksumGuard","Checksum_Guard",
	-- Injection methods
	"Inject","InjectorScript","LiveInject","ClientInject","ServerInject",
	"RemoteInject","FireAll","FireServer","FireClient","InvokeServer",
	"InvokeClient","FireAllClients","FireServer_Hooked","RemoteBypass",
	"RemoteHook","EventHook","SignalHook","FunctionHook","MethodHook",
	-- Duping / currency
	"DupeScript","Duper","Dupe","CashDupe","CurrencyDupe","MoneyDupe",
	"GiveCash","GiveMoney","SetMoney","SetCash","InfMoney","InfCash",
	"InfGold","InfiniteCoins","InfiniteGems","InfiniteRobux","RobuxGen",
	"RobuxHack",
	-- Data manipulation
	"DataHack","DataEdit","DataOverwrite","DataWipe","DataDelete",
	"DeleteAllData","WipeData","CorruptData","StealData","DumpData",
	-- Lag / crash scripts
	"LagScript","LagServer","ServerLag","RenderLag","CrashGame","CrashClient",
	"MemCrash","MemoryCrash","MemoryOverflow","MemoryExploit","HeapOverflow",
	"StackOverflow","RecursiveCrash","InfiniteLoop","WhileLoop","BusyLoop",
	-- Flood scripts
	"SpawnFlood","PartFlood","InstanceFlood","ModelFlood","SoundFlood",
	"FX_Flood","ParticleFlood","ExplosionFlood","ScriptFlood","GuiFlood",
	"PartSpammer","InstanceSpammer","PartBomb","InstanceBomb","PartNuke",
	-- Kill / grief
	"KillAll","KillScript","KillBrick","KillBricks","KillAura","KillOthers",
	"KillPlayer","GriefScript","Grief","Griefer","BanAll","KickAll",
	"KickOthers","BanOthers","BanScript","ForceKick","ForceKickAll",
	"DeleteAll","DestroyAll","NukeWorkspace","DeleteWorkspace","ClearMap",
	"DeleteMap","RemoveMap","BreakGame","BreakScript","BreakServer",
	"DestroyServer","ShutdownServer","ForceShutdown","ForceShutdownAll",
	-- Teleport / bring
	"TpAll","TpScript","TeleportAll","ForceTeleport","TeleportExploit",
	"TeleportHack","TeleportBypass","BringAll","BringPlayer","BringOthers",
	-- Movement exploits
	"NoClipScript","NoclipScript","Noclip","NoClip","Fly","FlyScript",
	"FlyHack","FlyBypass","SpeedHack","SpeedScript","SpeedBypass",
	"InfJump","InfJumpScript","InfiniteJump","AntiGravity","LowGravity",
	-- Visual exploits
	"EspScript","ESP","WallhackScript","Wallhack","ChamsScript","Chams",
	"AimBot","Aimbot","AimbotScript","SilentAim","SilentAimScript",
	-- Automation
	"AutoFarm","AutoFarmScript","AutoClick","AutoClicker","MacroScript",
	-- Chat abuse
	"ChatSpam","ChatBot","ChatScript","SpamBot","MessageBot","MessageSpam",
	"FilterBypass","FilterHack","FilterExploit",
	-- HTTP backdoors
	"HttpBackdoor","HttpExec","HttpHook","HttpGet_Hook","HttpPost_Hook",
	"WebhookScript","DiscordWebhook","DiscordBotScript","PhoneHome",
	"C2Script","C2Server","CommandAndControl","RemoteControl","RemoteAdmin",
	-- Admin abuse
	"AdminScript","AdminBypass","AdminExploit","AdminHack","AdminAbuse",
	-- Asset injection
	"LoadModel","InsertModel","ModelLoader","AssetLoader","AssetInject",
	-- Metatable hooks
	"GetRawMeta","SetRawMeta","HookMeta","MetaHook","MetaBypass",
	"EnvironmentHook","EnvHook","FEnvHook","GetFEnv","SetFEnv",
	"HookFunction","FunctionHooker","FuncHook","CClosure","NewCClosure",
	-- Obfuscated names
	"a1b2c3","x0x0x0","hax","h4x","h4ck","xpl0it","expl01t","backdoor_v2",
	"bd_v2","bd_v3","bd_v4","bd_v5","back_door","back-door","Bk_dr",
	"bkdr","b4ckd00r",
	-- Script execution
	"execscript","execScript","Exec_Script","RunScript","run_script",
	"ScriptRun","CodeRun","CodeExec","RunCode","ExecCode",
	"AutoExec","auto_exec","InitScript","Init_Script","LaunchScript",
	"start_script","StartScript","bootstrap","Bootstrap","boot_strap",
	"InjectLoader","InjectScript","script_inject","ScriptInjector",
	-- GUI bombs
	"GuiBomb","GuiSpam","GuiFlood","GuiCrash","GuiInject","GuiHack",
	-- Audio bombs
	"SoundBomb","SoundSpam","SoundCrash","AudioBomb","AudioFlood",
	-- Particle bombs
	"ParticleBomb","FxBomb","FxFlood","ExplosionBomb","ExplosionSpam",
	-- Physics crashes
	"PhysicsCrash","PhysicsBomb","ForceSpam","VelocityBomb","GravityHack",
	-- Memory bombs
	"MemBomb","MemoryBomb","StringBomb","DataBomb","AttributeBomb",
	-- Known malicious actors
	"c00lkidd","c0olkidd","coolkidd","reviz","infiniteyield",
	"infinite_yield","inf_yield","dex","dexexplorer",
	-- Script hubs
	"scripthub","script_hub","exploithub","exploit_hub",
	"cheatmenu","cheat_menu","adminpanel","admin_panel",
	"adminmenu","admin_menu","gg_admin","gui_exploit",
	"exploitgui","hackgui","hack_gui","executorgui",
	"executor_gui","ownertools","owner_tools","modtools",
	"freegui","freehack","ggscript","troll_gui",
	"trollgui","greengui","kalogui","synxgui",
	"fluxusgui","krnlgui","jjgui","cococz",
	"cocozhack","trigon","nihon","delta_gui",
	-- Remote exploit names
	"adminremote","admin_remote","commandremote","command_remote",
	"execremote","exec_remote","loaderremote","loader_remote",
	"adminfire","admin_fire","execfire","exec_fire",
	"adminbind","admin_bind","execbind","command_bind",
	-- FE exploit prefixes
	"fe_kill","fe_fly","fe_noclip","fe_esp","fe_exploit","fe_bypass",
	"r6_kill","r15_kill","r6_exploit","r15_exploit",
	-- NEW: Additional exploit hubs & tools
	"VapeV4","Vape_V4","VapeClient",
	"ThunderClient","Thunder_Client","ThunderHub",
	"FrostHub","Frost_Hub","FrostWare",
	"ZephyrHub","Zephyr_Hub","ZephyrExec",
	"NebulaHub","Nebula_Hub","NebulaExec",
	"CarbonHub","Carbon_Hub","CarbonExec",
	"ShadowHub","Shadow_Hub","ShadowExec",
	"NeonHub","Neon_Hub","NeonExec",
	"AuroraHub","Aurora_Hub","AuroraExec",
	"MercuryHub","Mercury_Hub","MercuryExec",
	"NovaHub","Nova_Hub","NovaExec",
	"PulseHub","Pulse_Hub","PulseExec",
	"StormHub","Storm_Hub","StormExec",
	"ViperHub","Viper_Hub","ViperExec",
	"CobraHub","Cobra_Hub","CobraExec",
	"HydraHub","Hydra_Hub","HydraExec",
	"KrakenHub","Kraken_Hub","KrakenExec",
	"SerpentHub","Serpent_Hub","SerpentExec",
	"PegasusHub","Pegasus_Hub","PegasusExec",
	"GriffinHub","Griffin_Hub","GriffinExec",
	"PhoenixHub","Phoenix_Hub","PhoenixExec",
	"DragonHub","Dragon_Hub","DragonExec",
	-- Additional tools & scripts
	"RemoteSpy","Remote_Spy","SimpleSpy","Simple_Spy",
	"ScriptDumper","Script_Dumper","ScriptHub_V2",
	"UnnamedESP","Unnamed_ESP","BoxESP","Box_ESP",
	"TracerESP","Tracer_ESP","HighlightESP",
	"ServerHop","Server_Hop","AutoServerHop",
	"RejoinScript","Rejoin_Script","AutoRejoin",
	"AntiAFK","Anti_AFK","AntiIdleKick",
	"InfiniteStamina","Inf_Stamina","StaminaHack",
	"GodMode","God_Mode","GodModeScript",
	"InfiniteHealth","Inf_Health","HealthHack",
	"NoRagdoll","No_Ragdoll","RagdollBypass",
	"NoFallDamage","No_FallDamage","FallDamageBypass",
	"TPWalk","TP_Walk","TeleportWalk",
	"Bhop","BunnyHop","Bunny_Hop",
	"ClickTP","Click_TP","ClickTeleport",
	-- Anti-cheat bypasses
	"BypassAC","Bypass_AC","ACBypass","AC_Bypass",
	"AntiCheatBypass","AntiCheat_Bypass",
	"ByfronBypass","Byfron_Bypass","HyperionBypass","Hyperion_Bypass",
})

-- Code patterns scored for threat level
sig.suspicious_code = {
	{plain=false, pat="require%s*%(%s*%d+%s*%)",                     score=100, tag="require(assetId)"},
	{plain=false, pat="game%.HttpGet%s*%(",                          score=90,  tag="game.HttpGet"},
	{plain=false, pat="game%.HttpPost%s*%(",                         score=90,  tag="game.HttpPost"},
	{plain=true,  pat="loadstring",                                  score=80,  tag="loadstring"},
	{plain=true,  pat="getfenv",                                     score=70,  tag="getfenv"},
	{plain=true,  pat="setfenv",                                     score=70,  tag="setfenv"},
	{plain=true,  pat="getrawmetatable",                             score=90,  tag="getrawmetatable"},
	{plain=true,  pat="setrawmetatable",                             score=90,  tag="setrawmetatable"},
	{plain=true,  pat="hookmetamethod",                              score=95,  tag="hookmetamethod"},
	{plain=true,  pat="hookfunction",                                score=90,  tag="hookfunction"},
	{plain=true,  pat="newcclosure",                                 score=75,  tag="newcclosure"},
	{plain=true,  pat="clonefunction",                               score=75,  tag="clonefunction"},
	{plain=true,  pat="decompile",                                   score=80,  tag="decompile"},
	{plain=true,  pat="getscriptsource",                             score=80,  tag="getscriptsource"},
	{plain=true,  pat="getscriptclosure",                            score=80,  tag="getscriptclosure"},
	{plain=false, pat="Load%s*%(%s*Async%s*%)",                      score=60,  tag="LoadAsync"},
	{plain=true,  pat="HttpGet",                                     score=55,  tag="HttpGet"},
	{plain=true,  pat="HttpPost",                                    score=55,  tag="HttpPost"},
	{plain=true,  pat="GetAsync",                                    score=50,  tag="GetAsync"},
	{plain=true,  pat="PostAsync",                                   score=50,  tag="PostAsync"},
	{plain=true,  pat="InsertService",                               score=50,  tag="InsertService"},
	{plain=true,  pat="LoadAsset",                                   score=55,  tag="LoadAsset"},
	{plain=true,  pat="LoadLibrary",                                 score=60,  tag="LoadLibrary"},
	{plain=true,  pat="islclosure",                                  score=60,  tag="islclosure"},
	{plain=true,  pat="checkcaller",                                 score=60,  tag="checkcaller"},
	{plain=true,  pat="firesignal",                                  score=70,  tag="firesignal"},
	{plain=true,  pat="fireclickdetector",                           score=60,  tag="fireclickdetector"},
	{plain=true,  pat="getconnections",                              score=70,  tag="getconnections"},
	{plain=true,  pat="getsenv",                                     score=75,  tag="getsenv"},
	{plain=true,  pat="getrenv",                                     score=75,  tag="getrenv"},
	{plain=true,  pat="getgenv",                                     score=75,  tag="getgenv"},
	{plain=true,  pat="syn.request",                                 score=90,  tag="syn.request"},
	{plain=true,  pat="http.request",                                score=85,  tag="http.request"},
	{plain=true,  pat="writefile",                                   score=85,  tag="writefile"},
	{plain=true,  pat="readfile",                                    score=75,  tag="readfile"},
	{plain=true,  pat="saveinstance",                                score=80,  tag="saveinstance"},
	{plain=true,  pat="deletefile",                                  score=80,  tag="deletefile"},
	{plain=true,  pat="makefolder",                                  score=65,  tag="makefolder"},
	{plain=true,  pat="PromptPurchase",                              score=55,  tag="PromptPurchase"},
	{plain=true,  pat="PromptGamePass",                              score=55,  tag="PromptGamePass"},
	{plain=true,  pat="DataStoreService",                            score=35,  tag="DataStoreService"},
	{plain=true,  pat="SetAsync",                                    score=30,  tag="DataStore:SetAsync"},
	{plain=true,  pat="UpdateAsync",                                 score=30,  tag="DataStore:UpdateAsync"},
	{plain=true,  pat="RemoveAsync",                                 score=35,  tag="DataStore:RemoveAsync"},
	{plain=true,  pat="MessagingService",                            score=40,  tag="MessagingService"},
	{plain=true,  pat="TeleportService",                             score=35,  tag="TeleportService"},
	{plain=true,  pat="TeleportAsync",                               score=40,  tag="TeleportAsync"},
	{plain=false, pat="_G%.",                                        score=30,  tag="_G global"},
	{plain=false, pat="shared%.",                                    score=30,  tag="shared global"},
	{plain=false, pat="\\x%x%x%x%x",                                score=40,  tag="hex escape"},
	{plain=false, pat="string%.char%(%d+,%d+,%d+,%d+,%d+",          score=75,  tag="char-encoded string"},
	{plain=false, pat="%(function%(%)%)%(function%(%)%)%(",          score=65,  tag="nested anon flood"},
	{plain=false, pat="while%s+true%s+do%s*\n?%s*Instance%.new",    score=100, tag="instance flood loop"},
	{plain=false, pat="for%s+i%s*=%s*1%s*,%s*math%.huge",           score=90,  tag="math.huge loop"},
	{plain=false, pat="repeat%s+Instance%.new",                      score=90,  tag="repeat instance flood"},
	{plain=false, pat="Instance%.new%s*%([^%)]-%)%s*[;,]?%s*\n%s*Instance%.new",
		score=70, tag="consecutive Instance.new"},
	{plain=true,  pat="RemoteEvent:FireAllClients",                  score=65,  tag="FireAllClients"},
	{plain=true,  pat="RemoteFunction:InvokeAllClients",             score=70,  tag="InvokeAllClients"},
	{plain=false, pat="for%s*[%w_]+%s*in%s*pairs%s*%(%s*getfenv",   score=85,  tag="fenv dump"},
	{plain=false, pat="while%s+true%s+do%s*\n?%s*Instance%.new%s*%([\"']ScreenGui",
		score=100, tag="GUI flood loop"},
	{plain=false, pat="while%s+true%s+do%s*\n?%s*Instance%.new%s*%([\"']Sound",
		score=100, tag="Sound flood loop"},
	{plain=false, pat="while%s+true%s+do%s*\n?%s*Instance%.new%s*%([\"']Explosion",
		score=100, tag="Explosion flood loop"},
	{plain=false, pat="while%s+true%s+do%s*\n?%s*Instance%.new%s*%([\"']Particle",
		score=100, tag="Particle flood loop"},
	{plain=false, pat="while%s+true%s+do%s*\n?.*:Destroy%()",       score=95,  tag="mass-destroy loop"},
	{plain=false, pat="for%s+_?%s*,%s*v%s+in%s+[ip][pa][ai][ir][es].*%s*do%s*\n?.*:Destroy%()",
		score=90, tag="batch destroy loop"},
	{plain=false, pat="BodyVelocity.*Velocity%s*=%s*Vector3%.new%s*%(%s*[0-9]+[0-9][0-9]",
		score=85, tag="extreme BodyVelocity"},
	{plain=false, pat="workspace%.Gravity%s*=%s*0",                  score=95,  tag="gravity zero"},
	{plain=false, pat="workspace%.Gravity%s*=%s*%-",                 score=90,  tag="gravity negative"},
	{plain=false, pat="string%.rep%s*%([^,]+,%s*%d%d%d%d%d",        score=85,  tag="string memory bomb"},
	{plain=false, pat="for%s+i%s*=%s*1%s*,%s*%d%d%d%d.*\n.*Instance%.new",
		score=95, tag="mass instance create"},
	-- NEW: additional patterns
	{plain=true,  pat="request(",                                    score=70,  tag="request() call"},
	{plain=true,  pat="game:HttpGetAsync",                           score=85,  tag="HttpGetAsync"},
	{plain=true,  pat="game:HttpPostAsync",                          score=85,  tag="HttpPostAsync"},
	{plain=true,  pat="setclipboard",                                score=70,  tag="setclipboard"},
	{plain=true,  pat="getclipboard",                                score=70,  tag="getclipboard"},
	{plain=true,  pat="setidentity",                                 score=80,  tag="setidentity"},
	{plain=true,  pat="setthreadidentity",                           score=80,  tag="setthreadidentity"},
	{plain=true,  pat="getnamecallmethod",                           score=75,  tag="getnamecallmethod"},
	{plain=true,  pat="setnamecallmethod",                           score=80,  tag="setnamecallmethod"},
	{plain=true,  pat="debug.getupvalue",                            score=75,  tag="debug.getupvalue"},
	{plain=true,  pat="debug.setupvalue",                            score=80,  tag="debug.setupvalue"},
	{plain=true,  pat="debug.getconstant",                           score=75,  tag="debug.getconstant"},
	{plain=true,  pat="debug.setconstant",                           score=80,  tag="debug.setconstant"},
	{plain=true,  pat="debug.getproto",                              score=75,  tag="debug.getproto"},
	{plain=true,  pat="debug.getstack",                              score=75,  tag="debug.getstack"},
	{plain=true,  pat="debug.setstack",                              score=80,  tag="debug.setstack"},
	{plain=true,  pat="Drawing.new",                                 score=60,  tag="Drawing.new"},
	{plain=true,  pat="getinstances",                                score=65,  tag="getinstances"},
	{plain=true,  pat="getnilinstances",                             score=70,  tag="getnilinstances"},
	{plain=true,  pat="getscripts",                                  score=65,  tag="getscripts"},
	{plain=true,  pat="getrunningscripts",                           score=65,  tag="getrunningscripts"},
	{plain=true,  pat="getloadedmodules",                            score=65,  tag="getloadedmodules"},
	{plain=true,  pat="getcallingscript",                            score=60,  tag="getcallingscript"},
	{plain=true,  pat="isexecutorclosure",                           score=75,  tag="isexecutorclosure"},
	{plain=true,  pat="checkclosure",                                score=60,  tag="checkclosure"},
	{plain=true,  pat="replaceclosure",                              score=85,  tag="replaceclosure"},
	{plain=true,  pat="protectgui",                                  score=60,  tag="protectgui"},
	{plain=true,  pat="unprotectgui",                                score=60,  tag="unprotectgui"},
}

sig.dangerous_args = makeSet({
	"loadstring","require","getfenv","setfenv",
	"hookfunction","newcclosure","getrawmetatable","setrawmetatable",
	"HttpGet","HttpPost","GetAsync","PostAsync",
	"syn.request","http.request","writefile","readfile",
	"saveinstance","firesignal","getconnections",
	"getsenv","getrenv","getgenv",
	":kick",":ban",":kill",":crash",
	":shutdown",":delete",":insert",":exec",
	":exploit",":noclip",":fly",":speed",
	":god",":antigravity","loopkill","loopgod",
})

sig.admin_triggers = {
	":ff ",":unff ",":god ",":ungod ",":kill ",":respawn ",
	":kick ",":ban ",":jail ",":unjail ",":sit ",":unsit ",
	":freeze ",":unfreeze ",":fly ",":unfly ",":noclip ",
	":loopkill ",":crash ",":shutdown",":btools ",":punish ",
	":unpunish ",":fire ",":unfire ",":smoke ",":unsmoke ",
	":sparkles ",":unsparkles ",":bring ",":goto ",":tp ",
	":speed ",":jump ",":admin ",":unadmin ",":insert ",
	":delete ",":clear",":attach ",":lockdown",":unlockdown",
	"/kill ","/kick ","/ban ","/crash ","/delete ",
	"/fly ","/noclip ","/god ","/freeze ","/shutdown",
	";kill ",";kick ",";ban ",";crash ",";delete ",
	";fly ",";noclip ",";god ",";freeze ",";shutdown",
	";loopkill ",";unloopkill ",";ff ",";unff ",";tp ",
	";btools",";insert ",";clear",
	"!kill ","!kick ","!ban ","!crash ","!delete ",
}

sig.admin_gui_sigs = makeSet({
	"c00lkidd","c0olkidd","coolkidd","reviz","infiniteyield",
	"infinite_yield","inf_yield","dex","dexexplorer",
	"scripthub","script_hub","exploithub","exploit_hub",
	"cheatmenu","cheat_menu","adminpanel","admin_panel",
	"adminmenu","admin_menu","gg_admin","gui_exploit",
	"exploitgui","hackgui","hack_gui","executorgui",
	"executor_gui","ownertools","owner_tools","modtools",
	"freegui","freehack","ggscript","troll_gui",
	"trollgui","greengui","kalogui","synxgui",
	"fluxusgui","krnlgui","jjgui","cococz",
	"cocozhack","trigon","nihon","delta_gui",
	"adminremote","admin_remote","commandremote","command_remote",
	"execremote","exec_remote","loaderremote","loader_remote",
	"adminfire","admin_fire","execfire","exec_fire",
	"adminbind","admin_bind","execbind","command_bind",
	"guibomb","guispam","guiflood","guiinject",
	"soundbomb","soundspam","particlebomb","fxbomb",
	"physicsbomb","forcespam","membomb","stringbomb",
	-- NEW
	"polariahub","polaria_hub","polari_hub",
	"scriptblox","scriptbloxhub","pastehub",
	"owlhub","owl_hub","wallyhub","wally_hub",
	"siriushub","sirius_hub","linorialib","linoria_lib",
	"rayhub","ray_hub","venomhub","venom_hub",
	"universalhub","universal_hub","azurehub","azure_hub",
	"voidhub","void_hub","frosthub","frost_hub",
	"zephyrhub","zephyr_hub","shadowhub","shadow_hub",
	"neonhub","neon_hub","aurorahub","aurora_hub",
})

sig.ds_key_blacklist = {
	"global_","ban_","wipe_","delete_",
	"admin_","exploit_","../","..\\",
	"%00","null","undefined",
	"setasync","removeasync","updateasync",
}

sig.ss_exec_patterns = {
	"loadstring%s*%(","require%s*%(%s*%d+",
	"HttpGet%s*%(","syn%.request","http%.request",
	"getfenv%s*%(","setfenv%s*%(",
	"hookfunction%s*%(","getrawmetatable%s*%(",
}

sig.crash_patterns = {
	{ pat = "while%s+true%s+do[^e]",                                tag = "bare busy loop" },
	{ pat = "for%s+i%s*=%s*1%s*,%s*%d%d%d%d%d",                    tag = "large numeric loop" },
	{ pat = "InsertService.*LoadAsset",                              tag = "InsertService.LoadAsset" },
	{ pat = "game%.InsertService",                                   tag = "InsertService usage" },
	{ pat = "workspace%.Gravity%s*=%s*%-",                           tag = "negative gravity" },
	{ pat = "workspace%.Gravity%s*=%s*0[^%.]",                      tag = "zero gravity" },
	{ pat = "workspace%.FallenPartsDestroyHeight%s*=%s*%d%d%d%d%d", tag = "FPDH extreme" },
	{ pat = "string%.rep%s*%([^,]+,%s*%d%d%d%d%d",                  tag = "large string.rep" },
}

------------------------------------------------------------------------
-- §6  EMERGENCY / FLOOD CLASS SETS
------------------------------------------------------------------------
local EMERG_SAFE_CLASSES = makeSet({
	"Terrain","Model","Folder","Configuration","Player","Humanoid",
	"HumanoidDescription","Animator","Animation","AnimationController",
	"Motor6D","Weld","WeldConstraint","HingeConstraint","BallSocketConstraint",
	"RodConstraint","RopeConstraint","SpringConstraint","CylindricalConstraint",
	"Attachment","NoCollisionConstraint","PlayerGui","StarterGear","Backpack",
	"Sound","SoundGroup","Sky","Atmosphere","ColorCorrectionEffect",
	"BloomEffect","BlurEffect","SunRaysEffect",
})

local EMERG_FLOOD_CLASSES = makeSet({
	"Part","MeshPart","WedgePart","CornerWedgePart","TrussPart",
	"UnionOperation","SpawnLocation","Decal","Texture","SurfaceAppearance",
	"SpecialMesh","SelectionBox","SelectionSphere","Explosion","Fire",
	"Smoke","Sparkles","ParticleEmitter","Trail","Beam",
	"BillboardGui","SurfaceGui","ScreenGui","Frame","TextLabel",
	"TextButton","ImageLabel","ImageButton","ScrollingFrame","TextBox",
	"Script","LocalScript","ModuleScript","RemoteEvent","RemoteFunction",
	"BindableEvent","BindableFunction",
})

local GUI_FLOOD_CLASSES = makeSet({
	"ScreenGui","BillboardGui","SurfaceGui","Frame","TextLabel",
	"TextButton","ImageLabel","ImageButton","ScrollingFrame","TextBox",
})

local FX_CLASSES = makeSet({"Fire","Smoke","Sparkles"})

------------------------------------------------------------------------
-- §7  STATS TABLE  (1 register)
------------------------------------------------------------------------
local stats = {
	totalFixes = 0, fixAttempts = 0, patchesApplied = 0,
	backdoorsFound = 0, backdoorsRemoved = 0, backdoorsQuarantined = 0,
	workspaceAdds = 0, workspaceRemoves = 0, newScriptsAdded = 0, liveInjections = 0,
	spamBursts = 0, spamInstancesKilled = 0,
	instancesRemoved = 0, nanFixed = 0, jointsFixed = 0, velocityFixed = 0,
	fallenPartsRemoved = 0, lightingFixed = 0,
	emergencyTriggers = 0, emergencyNuked = 0, lockdownSeconds = 0,
	remoteFloods = 0, remoteCallsBlocked = 0,
	remoteCalls = 0, argViolations = 0, typeViolations = 0,
	stringViolations = 0, instanceViolations = 0, floodViolations = 0,
	chatCommandsBlocked = 0, chatCommandsSeen = 0, adminAbuseAttempts = 0,
	propertyViolations = 0, gravityResets = 0, lightingResets = 0,
	charViolations = 0, speedResets = 0, healthResets = 0, anchorResets = 0,
	dsViolations = 0, dsBlockedWrites = 0, networkOwnerViolations = 0,
	sdKicks = 0, sdStrikes = {},
	playersKicked = 0, playerStrikes = 0, playersJoined = 0,
	npcRespawns = 0, npcVoidEscapes = 0, npcPatrolSteps = 0, npcScriptsHunted = 0,
	hudRespawns = 0,
	integrityViolations = 0, stdlibHooks = 0, metatableHooks = 0, apiNulls = 0,
	globalPollutions = 0, gKeyChanges = 0,
	scansSinceFix = 0, sweepCount = 0, scriptsScanned = 0,
	profilerRuns = 0,
	guiBombsBlocked = 0, guiFloods = 0,
	audioBombsBlocked = 0, audioFloods = 0,
	particleBombsBlocked = 0,
	explosionBombsBlocked = 0,
	physicsAbuse = 0, bodyForceClamps = 0,
	memBombsBlocked = 0, stringValueTruncations = 0,
	massDestroyBlocked = 0, crashPatternsFound = 0,
	modelPartCapViolations = 0,
}

------------------------------------------------------------------------
-- §8  RUNTIME STATE TABLE  (1 register)
------------------------------------------------------------------------
local state = {
	fixedScripts       = {},
	consoleLog         = {},
	smoothFPS          = 60,
	explorerTree       = {},
	expSelected        = 1,
	expScroll          = 0,
	cursorPulse        = 0,
	lastTreeBuild      = 0,
	scriptMemory       = {},
	spamTracker        = {},
	profilerData       = {},
	profilerPrev       = {},
	profilerLastT      = safe.clock(),
	monitorDebounce    = {},
	remoteFireCounts   = {},
	serverPerf         = {
		fps = 60, memKb = 0, instances = 0,
		physicsMs = 0, netRxKbps = 0, netTxKbps = 0,
	},
	lastKnownInst      = 0,
	emergency          = {
		active = false, activeSince = 0, lastSpikeTime = 0,
		spikeCount = 0, sourcePlayer = nil, strikeMap = {},
		nukedTotal = 0, cleanupRunning = false, lockdownBlink = 0,
		snapshot = {}, floodQueue = {},
	},
	wrappedRemotes     = {},
	remoteCallTracker  = {},
	chatCmdTracker     = {},
	charConnections    = {},
	perPlayerRemote    = {},
	jointDestroyTracker = {},
	descendantDestroyTracker = { count = 0, windowStart = safe.clock() },
	guiFloodTracker    = {},
	fxFloodTracker     = {},
	guiGlobalTracker   = { count = 0, windowStart = safe.clock() },
	-- NPC refs (populated by buildNPC)
	npc                = {},
	-- HUD refs (populated by buildHUD)
	hud                = {},
	-- Patrol
	patrolPoints       = {},
	patrolIdx          = 1,
	isFollowing        = false,
	stareTimer         = 0,
	isVoidFading       = false,
	npcRespawning      = false,
	hudRespawning      = false,
	-- _G integrity
	gSnapshot          = {},
	gSnapshotDone      = false,
}

------------------------------------------------------------------------
-- §9  LOGGING
------------------------------------------------------------------------
local TAG_COLOR = {
	SYS  = Color3.fromRGB(100,180,255), WARN = Color3.fromRGB(255,200,60),
	ERR  = Color3.fromRGB(255,80,80),   OK   = Color3.fromRGB(80,255,140),
	FIX  = Color3.fromRGB(80,255,200),  SCAN = Color3.fromRGB(160,200,255),
	JOIN = Color3.fromRGB(255,220,100), SCPT = Color3.fromRGB(200,160,255),
	EDIT = Color3.fromRGB(100,255,220), DOOR = Color3.fromRGB(255,60,60),
	KILL = Color3.fromRGB(255,0,0),     VOID = Color3.fromRGB(200,100,255),
	IMRT = Color3.fromRGB(80,255,180),  WCHG = Color3.fromRGB(255,180,100),
	SPAM = Color3.fromRGB(255,100,50),  PROF = Color3.fromRGB(120,200,255),
	PHYS = Color3.fromRGB(255,160,60),  PATH = Color3.fromRGB(100,220,200),
	LOCK = Color3.fromRGB(255,30,30),   NUKE = Color3.fromRGB(255,80,0),
	KICK = Color3.fromRGB(255,60,120),  RFLOOD=Color3.fromRGB(255,100,200),
	INTG = Color3.fromRGB(255,50,200),  RESP = Color3.fromRGB(80,255,255),
	GPOL = Color3.fromRGB(255,150,50),  AI   = Color3.fromRGB(140,255,180),
	PATROL=Color3.fromRGB(100,200,255),
	SDEF = Color3.fromRGB(255,140,0),   SARG = Color3.fromRGB(255,80,80),
	SCMD = Color3.fromRGB(255,60,180),  SPROP= Color3.fromRGB(255,200,50),
	SCHAR= Color3.fromRGB(100,255,200), SDS  = Color3.fromRGB(180,100,255),
	SNET = Color3.fromRGB(100,180,255), SRFL = Color3.fromRGB(255,100,100),
	SOK  = Color3.fromRGB(80,255,140),  SWRN = Color3.fromRGB(255,200,60),
	GBOMB= Color3.fromRGB(255,80,200),  ABOMB= Color3.fromRGB(255,200,80),
	PBOMB= Color3.fromRGB(200,100,255), XBOMB= Color3.fromRGB(255,60,60),
	PBYS = Color3.fromRGB(255,160,60),  MBOMB= Color3.fromRGB(180,80,255),
	CRASH= Color3.fromRGB(255,30,30),
}

local function uptime()
	local t = safe.floor(safe.clock() - cfg.BOOT_TIME)
	return safe.format("%02d:%02d", safe.floor(t / 60) % 60, t % 60)
end

local function addLog(tag, msg)
	safe.insert(state.consoleLog, { tag = tag, msg = msg, ts = uptime() })
	while #state.consoleLog > cfg.MAX_LOG_ENTRIES do safe.remove(state.consoleLog, 1) end
	print(safe.format("[Monitor %s][%s][%s] %s", cfg.VERSION, tag, uptime(), msg))
end

------------------------------------------------------------------------
-- §10  UTILITIES
------------------------------------------------------------------------
local function safeFullName(inst)
	local ok, n = safe.pcall(function() return inst:GetFullName() end)
	return ok and n or inst.Name
end

local function isScript(i)
	return i:IsA("Script") or i:IsA("LocalScript") or i:IsA("ModuleScript")
end

local function getVault()
	local v = svc.ServerStorage:FindFirstChild("__QuarantineVault__")
	if not v then v = Instance.new("Folder"); v.Name = "__QuarantineVault__"; v.Parent = svc.ServerStorage end
	return v
end

local function getSSQuarantine()
	local v = svc.ServerStorage:FindFirstChild("__SS_Quarantine__")
	if not v then v = Instance.new("Folder"); v.Name = "__SS_Quarantine__"; v.Parent = svc.ServerStorage end
	return v
end

------------------------------------------------------------------------
-- §11  FORWARD DECLARATIONS  (functions that reference each other)
------------------------------------------------------------------------
local triggerEmergency  -- forward
local analyzeScript     -- forward
local fixScript         -- forward
local checkNewScript    -- forward

------------------------------------------------------------------------
-- §12  GLOBAL / STDLIB / METATABLE INTEGRITY
------------------------------------------------------------------------
local function snapshotG()
	state.gSnapshot = {}
	safe.pcall(function()
		for k, v in safe.pairs(_G) do state.gSnapshot[k] = safe.type(v) end
	end)
	state.gSnapshotDone = true
end

local function auditGlobals()
	if not state.gSnapshotDone then return end
	safe.pcall(function()
		for k, v in safe.pairs(_G) do
			local snap = safe.rawget(state.gSnapshot, k)
			if snap == nil then
				stats.globalPollutions += 1
				addLog("GPOL", safe.format("NEW _G key: '%s' (%s)", safe.tostring(k), safe.type(v)))
				if safe.type(v) == "function" then
					addLog("WARN", safe.format("_G['%s'] is a function — possible injection", safe.tostring(k)))
					triggerEmergency("_G function injection: " .. safe.tostring(k), nil)
				end
			end
		end
		for k, t in safe.pairs(state.gSnapshot) do
			local cur = safe.rawget(_G, k)
			if cur ~= nil and safe.type(cur) ~= t then
				stats.integrityViolations += 1
				stats.gKeyChanges += 1
				addLog("INTG", safe.format("_G['%s'] type changed: was %s now %s", safe.tostring(k), t, safe.type(cur)))
			end
		end
	end)
end

local function auditStdLibs()
	for name, ref in safe.pairs(SAFE_GLOBALS) do
		safe.pcall(function()
			local cur
			if safe.find(name, ".", 1, true) then
				local lib, fn = name:match("^([^.]+)%.(.+)$")
				local libTbl = safe.rawget(_G, lib)
				if libTbl and safe.type(libTbl) == "table" then cur = safe.rawget(libTbl, fn) end
			else
				cur = safe.rawget(_G, name)
			end
			if cur == nil then return end
			if cur ~= ref then
				stats.integrityViolations += 1
				stats.stdlibHooks += 1
				addLog("INTG", safe.format("STDLIB HOOK: '%s' replaced!", name))
				safe.pcall(function()
					if safe.find(name, ".", 1, true) then
						local lib, fn = name:match("^([^.]+)%.(.+)$")
						local libTbl = safe.rawget(_G, lib)
						if libTbl then safe.rawset(libTbl, fn, ref) end
					else
						safe.rawset(_G, name, ref)
					end
				end)
				addLog("INTG", "  -> '" .. name .. "' restored")
				triggerEmergency("stdlib hook: " .. name, nil)
			end
		end)
	end
end

local function auditRobloxAPI()
	for name, ref in safe.pairs(SAFE_API) do
		safe.pcall(function()
			local obj, method = name:match("^([^.]+)%.(.+)$")
			if not obj then return end
			local tbl
			if obj == "Instance" then tbl = Instance
			elseif obj == "game" then tbl = game
			elseif obj == "workspace" then tbl = workspace
			elseif obj == "Players" then tbl = svc.Players
			elseif obj == "RunService" then tbl = svc.RunService
			elseif obj == "HttpService" then tbl = svc.HttpService end
			if not tbl then return end
			local cur = tbl[method]
			if cur == nil then
				stats.integrityViolations += 1
				stats.apiNulls += 1
				addLog("INTG", safe.format("API NIL: %s.%s", obj, method))
				triggerEmergency("API nil: " .. name, nil)
			elseif safe.type(cur) ~= safe.type(ref) then
				stats.integrityViolations += 1
				addLog("INTG", safe.format("API TYPE: %s.%s was %s", obj, method, safe.type(ref)))
				triggerEmergency("API type change: " .. name, nil)
			end
		end)
	end
end

local function auditMetatables()
	local toCheck = {
		{ name = "_G",     tbl = _G },
		{ name = "math",   tbl = math },
		{ name = "string", tbl = string },
		{ name = "table",  tbl = table },
		{ name = "os",     tbl = os },
		{ name = "shared", tbl = shared },
	}
	for _, entry in safe.ipairs(toCheck) do
		safe.pcall(function()
			local mt = safe.getmetatable(entry.tbl)
			if mt and safe.type(mt) == "table" then
				stats.integrityViolations += 1
				stats.metatableHooks += 1
				addLog("INTG", safe.format("METATABLE on '%s'", entry.name))
				safe.pcall(function() safe.setmetatable(entry.tbl, nil) end)
				triggerEmergency("metatable on " .. entry.name, nil)
			end
		end)
	end
end

------------------------------------------------------------------------
-- §13  NPC BUILD  (fully extracted helpers — no register overflow)
------------------------------------------------------------------------
local PART_COLORS = {
	Torso = "Bright blue", Head = "Bright yellow",
	["Left Arm"] = "Bright yellow", ["Right Arm"] = "Bright yellow",
	["Left Leg"] = "Bright green",  ["Right Leg"] = "Bright green",
}

local ANIM_IDS = {
	idle  = "rbxassetid://180435571",
	walk  = "rbxassetid://180426354",
	jump  = "rbxassetid://125750702",
	fall  = "rbxassetid://180436148",
	climb = "rbxassetid://180436334",
	sit   = "rbxassetid://178130996",
}

local function makePart(parent, name, size, colorName, transparency, noCollide)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.BrickColor = colorName and BrickColor.new(colorName) or BrickColor.new("Medium stone grey")
	p.Material = Enum.Material.SmoothPlastic
	p.Transparency = transparency or 0
	p.CanCollide = not noCollide
	p.Parent = parent
	return p
end

local function makeMotor(name, p0, p1, c0, c1)
	local m = Instance.new("Motor6D")
	m.Name = name; m.Part0 = p0; m.Part1 = p1; m.C0 = c0; m.C1 = c1; m.Parent = p0
end

local function buildMotors(parts)
	local PI = safe.pi
	makeMotor("RootJoint", parts.hrp, parts.torso,
		CF(0,0,0) * CFA(-PI/2,0,PI), CF(0,0,0) * CFA(-PI/2,0,PI))
	makeMotor("Neck", parts.torso, parts.head,
		CF(0,1,0) * CFA(-PI/2,0,PI), CF(0,-0.5,0) * CFA(-PI/2,0,PI))
	makeMotor("Right Shoulder", parts.torso, parts.rArm,
		CF(1.5,0.5,0) * CFA(0,PI/2,0), CF(0,0.5,0) * CFA(0,PI/2,0))
	makeMotor("Left Shoulder", parts.torso, parts.lArm,
		CF(-1.5,0.5,0) * CFA(0,-PI/2,0), CF(0,0.5,0) * CFA(0,-PI/2,0))
	makeMotor("Right Hip", parts.torso, parts.rLeg,
		CF(0.5,-1,0) * CFA(0,PI/2,0), CF(0,1,0) * CFA(0,PI/2,0))
	makeMotor("Left Hip", parts.torso, parts.lLeg,
		CF(-0.5,-1,0) * CFA(0,-PI/2,0), CF(0,1,0) * CFA(0,-PI/2,0))
end

local function loadAnims(animator)
	local tracks = {}
	for aname, aid in safe.pairs(ANIM_IDS) do
		local a = Instance.new("Animation"); a.AnimationId = aid
		local ok, t = safe.pcall(function() return animator:LoadAnimation(a) end)
		if ok and t then
			t.Looped = (aname ~= "jump" and aname ~= "fall")
			tracks[aname] = t
		else
			addLog("WARN", safe.format("LoadAnimation failed for '%s'", aname))
		end
	end
	return tracks
end

local function setupAnimController(hum, tracks)
	local currentAnim = ""

	local function playAnim(name, fade)
		if currentAnim == name then return end
		fade = fade or 0.12
		for _, t in safe.pairs(tracks) do
			if t.IsPlaying then t:Stop(fade) end
		end
		if tracks[name] then tracks[name]:Play(fade); currentAnim = name end
	end

	playAnim("idle", 0)

	hum.Running:Connect(function(s)
		if s > 0.5 then playAnim("walk") else playAnim("idle") end
	end)
	hum.Jumping:Connect(function() playAnim("jump", 0.05) end)
	hum.Seated:Connect(function() playAnim("sit") end)
	hum.Climbing:Connect(function(s)
		if safe.abs(s) > 0.1 then playAnim("climb") else playAnim("idle") end
	end)
	hum.FreeFalling:Connect(function()
		task.delay(0.3, function()
			if hum and hum.Parent and hum:GetState() == Enum.HumanoidStateType.Freefall then
				playAnim("fall")
			end
		end)
	end)
	hum.HealthChanged:Connect(function(hp)
		if not cfg.IMMORTAL then return end
		if hp < 1 then
			task.defer(function()
				if hum and hum.Parent then
					hum.Health = hum.MaxHealth
					addLog("IMRT", "fatal damage blocked")
				end
			end)
		end
	end)

	return playAnim
end

local function buildNPC()
	local m = Instance.new("Model"); m.Name = "Noob_v14"

	local parts = {
		hrp   = makePart(m, "HumanoidRootPart", V3(2,2,1), nil, 1, true),
		torso = makePart(m, "Torso",      V3(2,2,1), PART_COLORS.Torso),
		head  = makePart(m, "Head",        V3(2,1,1), PART_COLORS.Head),
		lArm  = makePart(m, "Left Arm",   V3(1,2,1), PART_COLORS["Left Arm"]),
		rArm  = makePart(m, "Right Arm",  V3(1,2,1), PART_COLORS["Right Arm"]),
		lLeg  = makePart(m, "Left Leg",   V3(1,2,1), PART_COLORS["Left Leg"]),
		rLeg  = makePart(m, "Right Leg",  V3(1,2,1), PART_COLORS["Right Leg"]),
	}

	local face = Instance.new("Decal")
	face.Texture = "rbxasset://textures/face.png"; face.Parent = parts.head

	local hum = Instance.new("Humanoid")
	hum.RigType = Enum.HumanoidRigType.R6
	hum.WalkSpeed = cfg.WALK_SPEED
	hum.MaxHealth = 100; hum.Health = 100
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	hum.HealthDisplayType   = Enum.HumanoidHealthDisplayType.AlwaysOff
	hum.Parent = m

	local animator = Instance.new("Animator"); animator.Parent = hum
	m.PrimaryPart = parts.hrp

	-- CRITICAL: parent BEFORE LoadAnimation
	m.Parent = workspace
	m:PivotTo(CF(cfg.SPAWN_POS))

	buildMotors(parts)
	local tracks = loadAnims(animator)
	local playAnim = setupAnimController(hum, tracks)

	local bodyParts = { parts.torso, parts.head, parts.lArm, parts.rArm, parts.lLeg, parts.rLeg }
	local origAlpha = {}
	for _, p in safe.ipairs(bodyParts) do origAlpha[p] = p.Transparency end

	return {
		model = m, parts = parts, face = face,
		hum = hum, animator = animator,
		tracks = tracks, playAnim = playAnim,
		bodyParts = bodyParts, origAlpha = origAlpha,
	}
end

local function installNPC(n)
	state.npc = n
	state.isVoidFading = false
end

installNPC(buildNPC())

local function rebuildPatrolPoints()
	state.patrolPoints = {}
	for i = 0, cfg.PATROL_POINTS - 1 do
		local angle = (i / cfg.PATROL_POINTS) * 2 * safe.pi
		safe.insert(state.patrolPoints, V3(
			cfg.SPAWN_POS.X + safe.cos(angle) * cfg.PATROL_RADIUS,
			cfg.SPAWN_POS.Y,
			cfg.SPAWN_POS.Z + safe.sin(angle) * cfg.PATROL_RADIUS))
	end
	state.patrolIdx = 1
end
rebuildPatrolPoints()

------------------------------------------------------------------------
-- §14  PLAYER TRACING & STRIKE SYSTEM
------------------------------------------------------------------------
local function traceSourcePlayer(inst)
	local cur = inst
	for _ = 1, 8 do
		if not cur or not cur.Parent then break end
		if cur.Parent == svc.Players then return cur end
		cur = cur.Parent
	end
	for _, pl in safe.ipairs(svc.Players:GetPlayers()) do
		if pl.Name ~= cfg.OWNER_NAME and pl.Character then
			local ok, res = safe.pcall(function() return inst:IsDescendantOf(pl.Character) end)
			if ok and res then return pl end
		end
	end
	return nil
end

local function strikePlayer(pl, reason)
	if not pl or pl.Name == cfg.OWNER_NAME then return end
	local em = state.emergency
	local n = (em.strikeMap[pl.Name] or 0) + 1
	em.strikeMap[pl.Name] = n
	stats.playerStrikes += 1
	addLog("KICK", safe.format("strike %d/%d: %s | %s", n, cfg.EMERG_KICK_STRIKES, pl.Name, reason or ""))
	if n >= cfg.EMERG_KICK_STRIKES then
		stats.playersKicked += 1
		addLog("KICK", safe.format("KICKING %s (persistent abuse)", pl.Name))
		safe.pcall(function()
			pl:Kick(safe.format("[Monitor %s] Abuse detected: %s", cfg.VERSION, reason or "repeated violation"))
		end)
		em.strikeMap[pl.Name] = 0
	end
end

local function sdStrike(player, reason)
	if not player or player.Name == cfg.OWNER_NAME then return end
	local n = (stats.sdStrikes[player.Name] or 0) + 1
	stats.sdStrikes[player.Name] = n
	addLog("SWRN", safe.format("SD STRIKE %d/%d → %s | %s", n, cfg.SD_MAX_STRIKES, player.Name, reason))
	if n >= cfg.SD_MAX_STRIKES then
		stats.sdKicks += 1
		addLog("SRFL", safe.format("SD KICK: %s — %s", player.Name, reason))
		safe.pcall(function()
			player:Kick(safe.format("[Monitor %s] Server-side abuse: %s", cfg.VERSION, reason))
		end)
		stats.sdStrikes[player.Name] = 0
	end
end

------------------------------------------------------------------------
-- §15  EMERGENCY LOCKDOWN SYSTEM
------------------------------------------------------------------------
local function emergencyCleanupTick()
	local em = state.emergency
	if not em.active then return 0 end
	local nuked = 0
	local budget = cfg.EMERG_NUKE_PER_TICK
	local kept = {}
	for _, entry in safe.ipairs(em.floodQueue) do
		if budget <= 0 then
			safe.insert(kept, entry)
		else
			local inst = entry.inst
			if inst and inst.Parent and not em.snapshot[inst] then
				local underPlayers = false
				safe.pcall(function() underPlayers = inst:IsDescendantOf(svc.Players) end)
				if not underPlayers then
					if isScript(inst) then
						local a = analyzeScript(inst)
						if a.score >= 60 then
							safe.pcall(function()
								inst.Disabled = true
								inst:SetAttribute("Quarantined", true)
								inst.Name = "[BACKDOOR]_" .. inst.Name
								inst.Parent = getVault()
							end)
							nuked += 1; budget -= 1
							stats.backdoorsFound += 1
							stats.backdoorsRemoved += 1
							addLog("KILL", "[LOCKDOWN] quarantined: " .. inst.Name)
						end
					elseif nameInSet(inst.ClassName, EMERG_FLOOD_CLASSES) then
						safe.pcall(function() inst:Destroy() end)
						nuked += 1; budget -= 1
					end
				end
			end
		end
	end
	em.floodQueue = kept
	return nuked
end

triggerEmergency = function(reason, sourcePlr)
	local em = state.emergency
	em.lastSpikeTime = safe.clock()
	em.spikeCount = (em.spikeCount or 0) + 1
	if sourcePlr then em.sourcePlayer = sourcePlr end

	if not em.active then
		em.active = true
		em.activeSince = safe.clock()
		em.floodQueue = {}
		stats.emergencyTriggers += 1
		addLog("LOCK", "!!! EMERGENCY LOCKDOWN !!! reason: " .. reason)

		-- Snapshot current instances
		em.snapshot = {}
		safe.pcall(function()
			em.snapshot[game] = true
			for _, inst in safe.ipairs(game:GetDescendants()) do em.snapshot[inst] = true end
		end)

		-- Anchor NPC
		safe.pcall(function() state.npc.parts.hrp.Anchored = true end)

		if not em.cleanupRunning then
			em.cleanupRunning = true
			task.spawn(function()
				while em.active do
					task.wait(cfg.EMERG_CLEANUP_TICK)
					local n = emergencyCleanupTick()
					if n > 0 then
						em.nukedTotal += n
						stats.emergencyNuked += n
						stats.instancesRemoved += n
						addLog("NUKE", safe.format("removed %d flood instances (total %d)", n, em.nukedTotal))
					end
				end
				em.cleanupRunning = false
			end)
		end

		if sourcePlr then strikePlayer(sourcePlr, "emergency trigger: " .. reason) end
	else
		if sourcePlr then strikePlayer(sourcePlr, "sustained emergency: " .. reason) end
		addLog("LOCK", "sustained: " .. reason)
	end
end

local function checkEmergencyRecovery()
	local em = state.emergency
	if not em.active then return end
	if safe.clock() - em.lastSpikeTime > cfg.EMERG_COOLDOWN then
		local dur = safe.floor(safe.clock() - em.activeSince)
		stats.lockdownSeconds += dur
		em.active = false
		em.spikeCount = 0
		em.sourcePlayer = nil
		em.snapshot = {}
		em.floodQueue = {}
		addLog("LOCK", "!!! LOCKDOWN LIFTED !!! rate normalised")
		addLog("OK", safe.format("total removed: %d  duration: %ds", em.nukedTotal, dur))
		em.nukedTotal = 0
		safe.pcall(function() state.npc.parts.hrp.Anchored = false end)
	end
end

------------------------------------------------------------------------
-- §16  SCRIPT ANALYSIS ENGINE
------------------------------------------------------------------------
local function nameIsRandomized(s)
	if #s < 8 then return false end
	local v, c, d = 0, 0, 0
	for i = 1, #s do
		local ch = safe.sub(s, i, i)
		if ch:match("[aeiouAEIOU]") then v += 1
		elseif ch:match("[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]") then c += 1
		elseif ch:match("%d") then d += 1 end
	end
	local r = v / safe.max(1, c)
	return r < 0.15 or r > 3.0 or d / #s > 0.4
end

local function scanSource(src, scriptName)
	local threats, score = {}, 0

	-- require(assetId)
	for id in safe.gmatch(src, "require%s*%(%s*(%d+)%s*%)") do
		safe.insert(threats, { level = "CRITICAL", detail = "require(" .. id .. ")", pts = 100 })
		score += 100
	end

	-- Code patterns
	for _, e in safe.ipairs(sig.suspicious_code) do
		local found
		if e.plain then
			found = safe.find(src, e.pat, 1, true) ~= nil
		else
			found = safe.find(src, e.pat) ~= nil
		end
		if found then
			local level = e.score >= 80 and "CRITICAL" or (e.score >= 50 and "HIGH" or "MEDIUM")
			safe.insert(threats, { level = level, detail = e.tag, pts = e.score })
			score += e.score
		end
	end

	-- Long lines
	local lc, tl = 0, 0
	for line in safe.gmatch(src .. "\n", "([^\n]*)\n") do lc += 1; tl += #line end
	if lc > 0 and tl / lc > 200 then
		safe.insert(threats, { level = "MEDIUM", detail = safe.format("avg line %d chars", safe.floor(tl/lc)), pts = 30 })
		score += 30
	end

	-- Randomized name
	if nameIsRandomized(scriptName) then
		safe.insert(threats, { level = "HIGH", detail = "randomized name: " .. scriptName, pts = 60 })
		score += 60
	end

	-- Backdoor name match (case-insensitive)
	local matched, matchedSig = nameMatchesAny(scriptName, sig.backdoor_names)
	if matched then
		safe.insert(threats, { level = "CRITICAL", detail = "matches sig: " .. matchedSig, pts = 150 })
		score += 150
	end

	return threats, score
end

local FIX_RULES = {
	{
		id = "no_yield_loop", label = "while true without yield",
		detect = function(s) return safe.find(s, "while true do", 1, true) ~= nil and safe.find(s, "task.wait", 1, true) == nil and safe.find(s, "wait(", 1, true) == nil end,
		fix = function(s) return (s:gsub("(while true do%s*\n)", "%1\t\ttask.wait(0)\n")) end,
	},
	{
		id = "deprecated_wait", label = "bare wait() (deprecated)",
		detect = function(s) return safe.find(s, "[^%.]wait%(") ~= nil end,
		fix = function(s) return (s:gsub("([^%.%a])wait%(", "%1task.wait(")) end,
	},
	{
		id = "print_spam", label = "excessive print() calls (>5)",
		detect = function(s) local n = 0; for _ in safe.gmatch(s, "print%(") do n += 1 end; return n > 5 end,
		fix = function(s) return (s:gsub("(\t*)print%(", "%1--print(")) end,
	},
	{
		id = "spawn_legacy", label = "spawn() / delay() legacy calls",
		detect = function(s) return safe.find(s, "[^%a]spawn%(") ~= nil or safe.find(s, "[^%a]delay%(") ~= nil end,
		fix = function(s)
			s = (s:gsub("([^%a])spawn%(", "%1task.spawn("))
			s = (s:gsub("([^%a])delay%(", "%1task.delay("))
			return s
		end,
	},
}

analyzeScript = function(inst)
	local r = { lines = 0, rules = {}, preview = {}, hasSource = false, threats = {}, score = 0 }
	local ok, src = safe.pcall(function() return inst.Source end)
	if not ok or safe.type(src) ~= "string" or #src == 0 then
		r.preview[1] = "[source unavailable]"
		return r
	end
	r.hasSource = true
	local lines = {}
	for line in safe.gmatch(src .. "\n", "(.-)\n") do safe.insert(lines, line) end
	r.lines = #lines
	r.source = src
	for i = 1, safe.min(12, #lines) do
		local ln = safe.sub(lines[i], 1, 60)
		if #lines[i] > 60 then ln = ln .. "..." end
		r.preview[i] = safe.format("%3d| %s", i, ln)
	end
	r.threats, r.score = scanSource(src, inst.Name)
	for _, rule in safe.ipairs(FIX_RULES) do
		local det = false
		safe.pcall(function() det = rule.detect(src) end)
		if det then safe.insert(r.rules, { id = rule.id, label = rule.label, fixFn = rule.fix }) end
	end
	return r
end

------------------------------------------------------------------------
-- §17  QUARANTINE & FIX
------------------------------------------------------------------------
local function quarantineScript(inst)
	return safe.pcall(function()
		inst.Disabled = true
		inst:SetAttribute("Quarantined", true)
		inst:SetAttribute("QuarantineTime", safe.clock())
		inst:SetAttribute("QuarantineReason", "backdoor signature matched")
		inst.Name = "[BACKDOOR]_" .. inst.Name
		safe.pcall(function() inst.Parent = getVault() end)
		stats.backdoorsQuarantined += 1
	end)
end

local function quarantineServerScript(inst, reason)
	safe.pcall(function()
		inst.Disabled = true
		inst:SetAttribute("SSQuarantined", true)
		inst:SetAttribute("SSQuarantineReason", reason)
		inst:SetAttribute("SSQuarantineTime", safe.clock())
		inst.Name = "[SSEXEC]_" .. inst.Name
		inst.Parent = getSSQuarantine()
	end)
	addLog("SRFL", safe.format("SS QUARANTINE: '%s' reason: %s", inst.Name, reason))
	stats.remoteCallsBlocked += 1
end

fixScript = function(inst)
	local fn = safeFullName(inst)
	if state.fixedScripts[fn] and (safe.clock() - state.fixedScripts[fn]) < cfg.FIX_COOLDOWN then return 0 end
	local a = analyzeScript(inst)
	if a.score >= 100 then
		stats.backdoorsFound += 1
		if quarantineScript(inst) then
			stats.backdoorsRemoved += 1
			addLog("KILL", safe.format("quarantined '%s' score=%d", inst.Name, a.score))
			return 1
		else
			addLog("ERR", "quarantine failed: " .. inst.Name)
			return 0
		end
	end
	if not a.hasSource or #a.rules == 0 then return 0 end
	local src = a.source
	local pc = 0
	local pids = {}
	for _, rule in safe.ipairs(a.rules) do
		if rule.fixFn then
			local ns = ""
			local ok2 = safe.pcall(function() ns = rule.fixFn(src) end)
			if ok2 and ns ~= src and #ns > 0 then src = ns; pc += 1; safe.insert(pids, rule.id) end
		end
	end
	if pc == 0 then return 0 end
	local ok3 = safe.pcall(function()
		inst.Disabled = true
		local f = Instance.new(inst.ClassName)
		f.Name = inst.Name .. "_fixed"
		f.Source = "-- [monitor " .. cfg.VERSION .. "] patches: " .. safe.concat(pids, ", ") .. "\n\n" .. src
		f.Disabled = false
		f.Parent = inst.Parent
	end)
	if ok3 then
		state.fixedScripts[fn] = safe.clock()
		stats.totalFixes += 1
		stats.patchesApplied += pc
		addLog("EDIT", safe.format("patched '%s' (%d rule(s))", inst.Name, pc))
		return pc
	else
		stats.fixAttempts += 1
		addLog("ERR", "patch failed: " .. inst.Name)
		return 0
	end
end

------------------------------------------------------------------------
-- §18  SCRIPT HELPERS
------------------------------------------------------------------------
local function getAllScripts()
	local list = {}
	safe.pcall(function()
		for _, s in safe.ipairs(game:GetDescendants()) do
			if (s:IsA("Script") or s:IsA("LocalScript") or s:IsA("ModuleScript"))
				and not s.Name:find("_fixed$")
				and not s.Name:find("%[BACKDOOR%]")
				and not s.Name:find("%[SSEXEC%]")
				and s ~= script
			then
				safe.insert(list, s)
			end
		end
	end)
	return list
end

local function scriptMemRecord(inst, issues, fixes)
	local k = safeFullName(inst)
	local e = state.scriptMemory[k] or { visits = 0, issuesFound = 0, fixesApplied = 0, lastFixTime = 0 }
	e.visits += 1
	e.issuesFound += (issues or 0)
	e.fixesApplied += (fixes or 0)
	if fixes and fixes > 0 then e.lastFixTime = safe.clock() end
	state.scriptMemory[k] = e
end

local function pickPriorityScript(list)
	if #list == 0 then return nil end
	local best, bestScore = list[1], -1
	for _, inst in safe.ipairs(list) do
		local e = state.scriptMemory[safeFullName(inst)]
		local s = not e and 1.0 or (e.issuesFound > e.fixesApplied and 0.8 or 0)
		s += safe.random() * 0.2
		if s > bestScore then bestScore = s; best = inst end
	end
	return best
end

------------------------------------------------------------------------
-- §19  ANTI-SPAM TRACKER
------------------------------------------------------------------------
local function getSpamThreshold(cls)
	local factor = state.emergency.active and 0.4 or 1.0
	if cls == "Decal" or cls == "Texture" or cls == "SurfaceAppearance" then
		return safe.max(2, safe.floor(cfg.SPAM_THRESHOLD_DECAL * factor))
	elseif cls == "Part" or cls == "MeshPart" or cls == "UnionOperation" or cls == "CornerWedgePart" then
		return safe.max(4, safe.floor(cfg.SPAM_THRESHOLD_PART * factor))
	else
		return safe.max(3, safe.floor(cfg.SPAM_THRESHOLD_GEN * factor))
	end
end

local function trackSpam(inst)
	local npc = state.npc
	if inst == npc.model or (npc.model and inst:IsDescendantOf(npc.model)) then return end
	local nm = inst.Name or ""
	if nm:find("_fixed$") or nm:find("%[BACKDOOR%]") or nm:find("%[SSEXEC%]") then return end
	local par = inst.Parent
	if not par then return end
	local pk = ""
	safe.pcall(function() pk = par:GetFullName() end)
	if pk == "" then pk = par.Name end
	local cls = inst.ClassName
	local key = pk .. "|" .. cls
	local now = safe.clock()
	local tracker = state.spamTracker
	if not tracker[key] then tracker[key] = { count = 0, windowStart = now, lastWarn = 0, staged = {} } end
	local e = tracker[key]
	if now - e.windowStart > cfg.SPAM_WINDOW then e.count = 0; e.windowStart = now; e.staged = {} end
	e.count += 1
	safe.insert(e.staged, inst)

	if e.count >= getSpamThreshold(cls) and (now - e.lastWarn) > cfg.SPAM_WARN_COOLDOWN then
		e.lastWarn = now
		local rm = 0
		for _, s in safe.ipairs(e.staged) do
			if s and s.Parent then safe.pcall(function() s:Destroy() end); rm += 1 end
		end
		e.staged = {}; e.count = 0
		stats.spamBursts += 1
		stats.spamInstancesKilled += rm
		stats.instancesRemoved += rm
		addLog("SPAM", safe.format("burst: removed %d x %s from '%s'", rm, cls, pk:match("[^%.]+$") or pk))
	end
end

------------------------------------------------------------------------
-- §20  NPC WATCHDOG & RESPAWN
------------------------------------------------------------------------
local function respawnNPC()
	if state.npcRespawning then return end
	state.npcRespawning = true
	addLog("RESP", "NPC deletion detected — rebuilding...")
	stats.npcRespawns += 1
	safe.pcall(function()
		if state.npc.model and state.npc.model.Parent then state.npc.model:Destroy() end
	end)
	task.wait(0.05)
	installNPC(buildNPC())
	rebuildPatrolPoints()
	addLog("RESP", safe.format("NPC respawned #%d", stats.npcRespawns))
	state.npcRespawning = false
end

local function respawnHUD()
	if state.hudRespawning then return end
	state.hudRespawning = true
	addLog("RESP", "HUD deletion detected — rebuilding...")
	stats.hudRespawns += 1
	safe.pcall(function()
		if state.hud.card and state.hud.card.Parent then state.hud.card:Destroy() end
	end)
	task.wait(0.05)
	-- buildHUD is defined later; it assigns to state.hud
	state.hud = {} -- placeholder, will be rebuilt below
	state.hudRespawning = false
end

local function armPartGuard(part)
	part.AncestryChanged:Connect(function(_, newParent)
		if newParent == nil and not state.npcRespawning then
			addLog("RESP", safe.format("NPC part '%s' deleted — rebuild", part.Name))
			task.spawn(respawnNPC)
		end
	end)
end

local function armAllPartGuards()
	local p = state.npc.parts
	if not p then return end
	for _, part in safe.ipairs({ p.hrp, p.torso, p.head, p.lArm, p.rArm, p.lLeg, p.rLeg }) do
		if part then safe.pcall(armPartGuard, part) end
	end
end
armAllPartGuards()

-- Re-arm when NPC model changes
task.spawn(function()
	local lastModel = state.npc.model
	while true do
		task.wait(0.5)
		if state.npc.model ~= lastModel then
			lastModel = state.npc.model
			armAllPartGuards()
			addLog("RESP", "part guards re-armed on new NPC")
		end
	end
end)

-- NPC watchdog loop
task.spawn(function()
	while true do
		task.wait(cfg.NPC_WATCHDOG_TICK)
		if not state.npcRespawning then
			local npc = state.npc
			if not npc.model or not npc.model.Parent then
				task.spawn(respawnNPC)
			elseif not npc.hum or not npc.hum.Parent then
				task.spawn(respawnNPC)
			elseif not npc.parts.hrp or not npc.parts.hrp.Parent then
				task.spawn(respawnNPC)
			elseif cfg.IMMORTAL and npc.hum and npc.hum.Parent then
				safe.pcall(function()
					if npc.hum:GetState() == Enum.HumanoidStateType.Dead then
						npc.hum.Health = npc.hum.MaxHealth
						npc.model:PivotTo(CF(cfg.SPAWN_POS))
						addLog("IMRT", "dead state — force healed")
					elseif npc.hum.Health < npc.hum.MaxHealth then
						npc.hum.Health = safe.min(npc.hum.MaxHealth, npc.hum.Health + cfg.REGEN_RATE * cfg.NPC_WATCHDOG_TICK)
					end
				end)
			end
		end
	end
end)

------------------------------------------------------------------------
-- §21  HUD BUILD  (split into sub-builders to stay under register limit)
------------------------------------------------------------------------
local function mkFrame(parent, name, x, y, w, h, bg, tr, zi)
	local f = Instance.new("Frame")
	f.Name = name or "F"
	f.Position = UDim2.new(0, x, 0, y)
	f.Size = UDim2.new(0, w, 0, h)
	f.BackgroundColor3 = bg or Color3.new(0, 0, 0)
	f.BackgroundTransparency = tr or 0
	f.BorderSizePixel = 0
	f.ZIndex = zi or 2
	f.Parent = parent
	return f
end

local function mkLabel(parent, x, y, w, h, txt, sz, col, xa, zi)
	local l = Instance.new("TextLabel")
	l.Position = UDim2.new(0, x, 0, y)
	l.Size = UDim2.new(0, w, 0, h)
	l.BackgroundTransparency = 1
	l.Text = txt or ""
	l.TextSize = sz or 9
	l.TextColor3 = col or Color3.new(1, 1, 1)
	l.Font = Enum.Font.Code
	l.TextXAlignment = xa or Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.TextTruncate = Enum.TextTruncate.AtEnd
	l.BorderSizePixel = 0
	l.ZIndex = zi or 3
	l.Parent = parent
	return l
end

-- Explorer tree building
local ROOT_SERVICES = {
	"Workspace","Players","Lighting","ReplicatedStorage",
	"ServerScriptService","ServerStorage","StarterGui","StarterPack","StarterPlayer",
}
local EXPLORER_SKIP_NAMES = { Noob_v14 = true, NoobCard = true }
local EXPLORER_SKIP_CLASS = { Terrain = true }

local CLASS_ICON = {
	Model = "[M]", Part = "[P]", Humanoid = "[H]", Animator = "[A]", Motor6D = "[J]",
	Decal = "[D]", Script = "[S]", LocalScript = "[L]", ModuleScript = "[R]",
	Players = "[Pl]", Player = "[Pl]", Lighting = "[Lt]", Folder = "[F]",
	Workspace = "[W]", DataModel = "[G]", RemoteEvent = "[Re]", RemoteFunction = "[Rf]",
	MeshPart = "[MP]", BasePart = "[BP]", ScreenGui = "[UI]", Frame = "[Fr]",
	Sound = "[Au]", Explosion = "[Ex]", ParticleEmitter = "[Px]",
}
local function instIcon(i) return CLASS_ICON[i.ClassName] or "[?]" end

local function rebuildExplorerTree()
	local tree = {}
	safe.insert(tree, { inst = game, depth = 0 })
	local stack = {}
	for i = #ROOT_SERVICES, 1, -1 do
		local ok, s = safe.pcall(function() return game:GetService(ROOT_SERVICES[i]) end)
		if ok and s then safe.insert(stack, { inst = s, depth = 1 }) end
	end
	while #stack > 0 do
		local entry = safe.remove(stack)
		local inst = entry.inst
		local depth = entry.depth
		if EXPLORER_SKIP_NAMES[inst.Name] or EXPLORER_SKIP_CLASS[inst.ClassName] then continue end
		safe.insert(tree, { inst = inst, depth = depth })
		if depth < 4 then
			local ok, children = safe.pcall(function() return inst:GetChildren() end)
			if ok and children then
				for i2 = #children, 1, -1 do
					safe.insert(stack, { inst = children[i2], depth = depth + 1 })
				end
			end
		end
	end
	state.explorerTree = tree
end

------------------------------------------------------------------------
-- §21a  SHARED HUD COLORS  (one table, avoids duplicate Color3 locals)
------------------------------------------------------------------------
local HC = {
	BG       = Color3.fromRGB(28,28,28),
	BG_ALT   = Color3.fromRGB(35,35,35),
	HDR      = Color3.fromRGB(45,45,45),
	COL_HDR  = Color3.fromRGB(42,42,42),
	ACCENT   = Color3.fromRGB(0,99,177),
	DIV      = Color3.fromRGB(60,60,60),
	SB_COL   = Color3.fromRGB(0,84,166),
	T_PRI    = Color3.fromRGB(230,230,230),
	T_SEC    = Color3.fromRGB(155,155,155),
	T_DIM    = Color3.fromRGB(85,85,85),
	C_RED    = Color3.fromRGB(208,58,48),
	C_BLU    = Color3.fromRGB(55,148,232),
	EXP_SEL  = Color3.fromRGB(0,84,166),
	EXP_BAR  = Color3.fromRGB(0,140,255),
	C_LOCK   = Color3.fromRGB(220,30,30),
	C_GRN    = Color3.fromRGB(80,255,140),
	C_YLW    = Color3.fromRGB(255,200,60),
	C_PRP    = Color3.fromRGB(200,160,255),
	C_ORG    = Color3.fromRGB(255,180,100),
	C_CYN    = Color3.fromRGB(80,255,255),
	C_PINK   = Color3.fromRGB(255,80,200),
}

------------------------------------------------------------------------
-- §21b  SUB-BUILDER: Explorer panel
------------------------------------------------------------------------
local function buildExplorerPanel(root, xEXP, PW_EXP, CON_Y, CON_H)
	local EXP_ROW_H = 13
	local EXP_VIS = safe.floor(CON_H / EXP_ROW_H)
	local expRows = {}
	for i = 1, EXP_VIS do
		local ry = CON_Y + (i - 1) * EXP_ROW_H
		mkFrame(root, "ExBg"..i, xEXP, ry, PW_EXP, EXP_ROW_H, i%2==0 and HC.BG_ALT or HC.BG, 0, 2)
		local hl  = mkFrame(root, "ExHL"..i,  xEXP, ry, PW_EXP, EXP_ROW_H, HC.EXP_SEL, 1, 3)
		local bar = mkFrame(root, "ExBar"..i, xEXP, ry, 2, EXP_ROW_H, HC.EXP_BAR, 1, 4)
		local la  = mkLabel(root, xEXP+5, ry, PW_EXP-8, EXP_ROW_H, "", 8, HC.T_SEC, Enum.TextXAlignment.Left, 5)
		expRows[i] = { hl=hl, bar=bar, la=la }
	end
	local function updateExplorer(now, pulse)
		if now - state.lastTreeBuild > cfg.TREE_REBUILD then
			safe.pcall(rebuildExplorerTree); state.lastTreeBuild = now
		end
		local tree = state.explorerTree
		local treeLen = #tree
		if treeLen == 0 then return end
		state.expSelected = safe.clamp(state.expSelected, 1, treeLen)
		if state.expSelected > state.expScroll + EXP_VIS then
			state.expScroll = state.expSelected - EXP_VIS
		elseif state.expSelected <= state.expScroll then
			state.expScroll = safe.max(0, state.expSelected - 1)
		end
		for i = 1, EXP_VIS do
			local er = expRows[i]
			local ti = state.expScroll + i
			if ti <= treeLen then
				local entry = tree[ti]
				er.la.Text = safe.rep("  ", entry.depth) .. instIcon(entry.inst) .. " " .. entry.inst.Name
				er.la.TextColor3 = HC.T_SEC
				if ti == state.expSelected then
					er.hl.BackgroundTransparency = 0.70
					er.bar.BackgroundTransparency = 0.05 + (1 - pulse) * 0.6
					er.bar.BackgroundColor3 = HC.EXP_BAR
					er.la.TextColor3 = Color3.new(1,1,1)
				else
					er.hl.BackgroundTransparency = 1
					er.bar.BackgroundTransparency = 1
				end
			else
				er.la.Text = ""; er.hl.BackgroundTransparency = 1; er.bar.BackgroundTransparency = 1
			end
		end
	end
	return updateExplorer
end

------------------------------------------------------------------------
-- §21c  SUB-BUILDER: Processes panel  (profiler data)
------------------------------------------------------------------------
local function buildProcessesPanel(root, xPROC, PW_PROC, CON_Y, CON_H, chY, COLH)
	mkFrame(root, "ChBgP", xPROC, chY, PW_PROC, COLH, HC.COL_HDR, 0, 7)
	mkLabel(root, xPROC+4,   chY, 80, COLH, "Name",  7, HC.T_SEC, Enum.TextXAlignment.Left, 8)
	mkLabel(root, xPROC+86,  chY, 36, COLH, "Inst",  7, HC.T_SEC, Enum.TextXAlignment.Left, 8)
	mkLabel(root, xPROC+124, chY, 36, COLH, "Parts", 7, HC.T_SEC, Enum.TextXAlignment.Left, 8)
	mkLabel(root, xPROC+162, chY, 36, COLH, "Scrpt", 7, HC.T_SEC, Enum.TextXAlignment.Left, 8)
	mkLabel(root, xPROC+200, chY, 36, COLH, "Rmt",   7, HC.T_SEC, Enum.TextXAlignment.Left, 8)
	mkLabel(root, xPROC+238, chY, 45, COLH, "Δ/s",   7, HC.T_SEC, Enum.TextXAlignment.Left, 8)
	local ROW_H = 12
	local VIS = safe.floor(CON_H / ROW_H)
	local rows = {}
	for i = 1, VIS do
		local ry = CON_Y + (i-1)*ROW_H
		if i%2==0 then mkFrame(root, "PrBg"..i, xPROC, ry, PW_PROC, ROW_H, HC.BG_ALT, 0, 2) end
		rows[i] = {
			nameL = mkLabel(root, xPROC+4,   ry, 80, ROW_H, "", 7, HC.T_SEC, Enum.TextXAlignment.Left, 4),
			instL = mkLabel(root, xPROC+86,  ry, 36, ROW_H, "", 7, HC.C_BLU, Enum.TextXAlignment.Left, 4),
			partL = mkLabel(root, xPROC+124, ry, 36, ROW_H, "", 7, HC.T_SEC, Enum.TextXAlignment.Left, 4),
			scrpL = mkLabel(root, xPROC+162, ry, 36, ROW_H, "", 7, HC.C_PRP, Enum.TextXAlignment.Left, 4),
			rmtL  = mkLabel(root, xPROC+200, ry, 36, ROW_H, "", 7, HC.C_ORG, Enum.TextXAlignment.Left, 4),
			growL = mkLabel(root, xPROC+238, ry, 45, ROW_H, "", 7, HC.T_DIM, Enum.TextXAlignment.Left, 4),
		}
	end
	local function updateProc()
		local pData = state.profilerData
		for i = 1, VIS do
			local r = rows[i]; local e = pData[i]
			if e then
				r.nameL.Text = safe.sub(e.name, 1, 13)
				r.instL.Text = safe.tostring(e.instCount)
				r.partL.Text = safe.tostring(e.partCount)
				r.scrpL.Text = safe.tostring(e.scriptCount)
				r.rmtL.Text  = safe.tostring(e.remoteCount)
				local gr = e.growRate or 0
				r.growL.Text = gr > 0.5 and safe.format("+%.1f",gr) or (gr < -0.5 and safe.format("%.1f",gr) or "—")
				r.growL.TextColor3 = gr > 5 and HC.C_RED or (gr > 1 and HC.C_YLW or HC.T_DIM)
				r.nameL.TextColor3 = e.scriptCount > 3 and HC.C_PRP or HC.T_SEC
			else
				r.nameL.Text=""; r.instL.Text=""; r.partL.Text=""
				r.scrpL.Text=""; r.rmtL.Text=""; r.growL.Text=""
			end
		end
	end
	return updateProc
end

------------------------------------------------------------------------
-- §21d  SUB-BUILDER: Performance panel  (stats + perf)
------------------------------------------------------------------------
local function buildPerfPanel(root, xPERF, PW_PERF, CON_Y, CON_H, chY, COLH)
	mkFrame(root, "ChBgF", xPERF, chY, PW_PERF, COLH, HC.COL_HDR, 0, 7)
	mkLabel(root, xPERF+4, chY, PW_PERF-6, COLH, "Server Performance", 7, HC.C_BLU, Enum.TextXAlignment.Left, 8)
	local ROW_H = 13
	local VIS = safe.floor(CON_H / ROW_H)
	local rows = {}
	for i = 1, VIS do
		local ry = CON_Y + (i-1)*ROW_H
		if i%2==0 then mkFrame(root,"PfBg"..i, xPERF, ry, PW_PERF, ROW_H, HC.BG_ALT, 0, 2) end
		rows[i] = {
			keyL = mkLabel(root, xPERF+4,   ry, 100, ROW_H, "", 7, HC.T_DIM, Enum.TextXAlignment.Left, 4),
			valL = mkLabel(root, xPERF+106, ry, PW_PERF-110, ROW_H, "", 7, HC.T_PRI, Enum.TextXAlignment.Left, 4),
		}
	end
	local function updatePerf()
		local p = state.serverPerf
		local entries = {
			{"Server FPS",      safe.format("%.1f", p.fps),             p.fps < 30 and HC.C_RED or (p.fps < 50 and HC.C_YLW or HC.C_GRN)},
			{"Memory",          safe.format("%.1f MB", p.memKb/1024),   p.memKb > 512000 and HC.C_RED or HC.T_PRI},
			{"Instances",       safe.tostring(p.instances),              p.instances > 200000 and HC.C_YLW or HC.T_PRI},
			{"Physics ms",      safe.format("%.2f", p.physicsMs),        p.physicsMs > 8 and HC.C_RED or HC.T_PRI},
			{"Net Rx KB/s",     safe.format("%.1f", p.netRxKbps),        HC.T_PRI},
			{"Net Tx KB/s",     safe.format("%.1f", p.netTxKbps),        HC.T_PRI},
			{"─────────",       "──────────",                             HC.T_DIM},
			{"Total Fixes",     safe.tostring(stats.totalFixes),         HC.C_BLU},
			{"Backdoors Found", safe.tostring(stats.backdoorsFound),     stats.backdoorsFound>0 and HC.C_RED or HC.C_GRN},
			{"Backdoors Killed",safe.tostring(stats.backdoorsRemoved),   stats.backdoorsRemoved>0 and HC.C_ORG or HC.C_GRN},
			{"Spam Bursts",     safe.tostring(stats.spamBursts),         stats.spamBursts>0 and HC.C_ORG or HC.T_PRI},
			{"Live Injections", safe.tostring(stats.liveInjections),     stats.liveInjections>0 and HC.C_RED or HC.C_GRN},
			{"Lockdown Events", safe.tostring(stats.emergencyTriggers),  stats.emergencyTriggers>0 and HC.C_RED or HC.T_PRI},
			{"Emergency Nuked", safe.tostring(stats.emergencyNuked),     stats.emergencyNuked>0 and HC.C_ORG or HC.T_PRI},
			{"Players Kicked",  safe.tostring(stats.playersKicked+stats.sdKicks), (stats.playersKicked+stats.sdKicks)>0 and HC.C_PINK or HC.T_PRI},
			{"Remote Blocked",  safe.tostring(stats.remoteCallsBlocked), stats.remoteCallsBlocked>0 and HC.C_PINK or HC.T_PRI},
			{"Chat Blocked",    safe.tostring(stats.chatCommandsBlocked),stats.chatCommandsBlocked>0 and HC.C_PINK or HC.T_PRI},
			{"Char Violations", safe.tostring(stats.charViolations),     stats.charViolations>0 and HC.C_YLW or HC.T_PRI},
			{"GUI Bombs",       safe.tostring(stats.guiBombsBlocked),    stats.guiBombsBlocked>0 and HC.C_PINK or HC.T_PRI},
			{"Physics Abuse",   safe.tostring(stats.physicsAbuse),       stats.physicsAbuse>0 and HC.C_ORG or HC.T_PRI},
			{"Mem Bombs",       safe.tostring(stats.memBombsBlocked),    stats.memBombsBlocked>0 and HC.C_PRP or HC.T_PRI},
			{"Integrity Viols", safe.tostring(stats.integrityViolations),stats.integrityViolations>0 and HC.C_PINK or HC.C_GRN},
			{"Crash Patterns",  safe.tostring(stats.crashPatternsFound), stats.crashPatternsFound>0 and HC.C_RED or HC.T_PRI},
			{"NPC Respawns",    safe.tostring(stats.npcRespawns),        stats.npcRespawns>0 and HC.C_CYN or HC.T_PRI},
			{"Scripts Scanned", safe.tostring(stats.scriptsScanned),     HC.C_BLU},
			{"Sweep Count",     safe.tostring(stats.sweepCount),         HC.T_PRI},
			{"Profiler Runs",   safe.tostring(stats.profilerRuns),       HC.T_PRI},
			{"Lockdown Time",   safe.format("%.0fs", stats.lockdownSeconds), stats.lockdownSeconds>0 and HC.C_RED or HC.T_PRI},
		}
		for i = 1, VIS do
			local r = rows[i]; local e = entries[i]
			if e then
				r.keyL.Text = e[1]; r.valL.Text = e[2]; r.valL.TextColor3 = e[3] or HC.T_PRI
			else
				r.keyL.Text = ""; r.valL.Text = ""
			end
		end
	end
	return updatePerf
end

------------------------------------------------------------------------
-- §21e  SUB-BUILDER: Details panel  (selected instance analysis)
------------------------------------------------------------------------
local function buildDetailsPanel(root, xDET, PW_DET, CON_Y, CON_H, chY, COLH)
	mkFrame(root, "ChBgD", xDET, chY, PW_DET, COLH, HC.COL_HDR, 0, 7)
	mkLabel(root, xDET+4, chY, PW_DET-6, COLH, "Script Details / Threats", 7, HC.C_BLU, Enum.TextXAlignment.Left, 8)
	local ROW_H = 11
	local VIS = safe.floor(CON_H / ROW_H)
	local rows = {}
	for i = 1, VIS do
		local ry = CON_Y + (i-1)*ROW_H
		if i%2==0 then mkFrame(root,"DtBg"..i, xDET, ry, PW_DET, ROW_H, HC.BG_ALT, 0, 2) end
		rows[i] = { la = mkLabel(root, xDET+4, ry, PW_DET-8, ROW_H, "", 7, HC.T_SEC, Enum.TextXAlignment.Left, 4) }
	end
	-- Cache to avoid re-analyzing every frame
	local detCache = { lastInst = nil, lines = {} }
	local function rebuildDetails(selInst)
		local lines = {}
		if not selInst then
			safe.insert(lines, { text = "No instance selected.", col = HC.T_DIM })
			return lines
		end
		safe.insert(lines, { text = "Selected: " .. selInst.Name, col = HC.T_PRI })
		safe.insert(lines, { text = "Class: " .. selInst.ClassName, col = HC.T_SEC })
		safe.insert(lines, { text = "Path: " .. safeFullName(selInst), col = HC.T_DIM })
		safe.insert(lines, { text = "", col = HC.T_DIM })
		if isScript(selInst) then
			local a = analyzeScript(selInst)
			local sc = a.score >= 100 and HC.C_RED or (a.score >= 50 and HC.C_YLW or HC.C_GRN)
			safe.insert(lines, { text = safe.format("Threat Score: %d", a.score), col = sc })
			safe.insert(lines, { text = safe.format("Lines: %d  Rules: %d", a.lines, #a.rules), col = HC.T_SEC })
			safe.insert(lines, { text = "", col = HC.T_DIM })
			if #a.threats > 0 then
				safe.insert(lines, { text = "── Threats ──", col = HC.C_RED })
				for _, th in safe.ipairs(a.threats) do
					local tc = th.level=="CRITICAL" and HC.C_RED or (th.level=="HIGH" and HC.C_YLW or HC.T_SEC)
					safe.insert(lines, { text = safe.format("  [%s] %s (+%d)", th.level, th.detail, th.pts), col = tc })
				end
			else
				safe.insert(lines, { text = "No threats detected.", col = HC.C_GRN })
			end
			if #a.rules > 0 then
				safe.insert(lines, { text = "", col = HC.T_DIM })
				safe.insert(lines, { text = "── Fix Rules ──", col = Color3.fromRGB(100,255,220) })
				for _, rule in safe.ipairs(a.rules) do
					safe.insert(lines, { text = "  [" .. rule.id .. "] " .. rule.label, col = Color3.fromRGB(100,255,220) })
				end
			end
			if a.hasSource and #a.preview > 0 then
				safe.insert(lines, { text = "", col = HC.T_DIM })
				safe.insert(lines, { text = "── Source Preview ──", col = HC.T_DIM })
				for _, ln in safe.ipairs(a.preview) do safe.insert(lines, { text = ln, col = HC.T_DIM }) end
			end
		else
			safe.insert(lines, { text = "(not a script — no analysis)", col = HC.T_DIM })
			safe.pcall(function()
				if selInst:IsA("BasePart") then
					safe.insert(lines, { text = safe.format("Pos: %.1f, %.1f, %.1f", selInst.Position.X, selInst.Position.Y, selInst.Position.Z), col = HC.T_SEC })
					safe.insert(lines, { text = safe.format("Size: %.1f, %.1f, %.1f", selInst.Size.X, selInst.Size.Y, selInst.Size.Z), col = HC.T_SEC })
					safe.insert(lines, { text = "Anchored: " .. safe.tostring(selInst.Anchored), col = HC.T_SEC })
				elseif selInst:IsA("Model") then
					local ok, desc = safe.pcall(function() return selInst:GetDescendants() end)
					if ok then safe.insert(lines, { text = "Descendants: " .. #desc, col = HC.T_SEC }) end
				end
			end)
		end
		return lines
	end
	local function updateDetails()
		local tree = state.explorerTree
		local selEntry = tree[state.expSelected]
		local selInst = selEntry and selEntry.inst or nil
		-- Only re-analyze when selection changes
		if selInst ~= detCache.lastInst then
			detCache.lastInst = selInst
			detCache.lines = rebuildDetails(selInst)
		end
		for i = 1, VIS do
			local r = rows[i]; local e = detCache.lines[i]
			if e then r.la.Text = e.text; r.la.TextColor3 = e.col or HC.T_SEC
			else r.la.Text = "" end
		end
	end
	return updateDetails
end

------------------------------------------------------------------------
-- §21f  SUB-BUILDER: Event Log panel
------------------------------------------------------------------------
local function buildLogPanel(root, xSVC, PW_SVC, CON_Y, CON_H, chY, COLH)
	mkFrame(root, "ChBgS", xSVC, chY, PW_SVC, COLH, HC.COL_HDR, 0, 7)
	mkLabel(root, xSVC+4,  chY, 44, COLH, "Time",  7, HC.T_SEC, Enum.TextXAlignment.Left, 8)
	mkLabel(root, xSVC+50, chY, 34, COLH, "Tag",   7, HC.T_SEC, Enum.TextXAlignment.Left, 8)
	mkLabel(root, xSVC+86, chY, PW_SVC-90, COLH, "Event", 7, HC.T_SEC, Enum.TextXAlignment.Left, 8)
	local ROW_H = 10
	local VIS = safe.floor(CON_H / ROW_H)
	local rows = {}
	for i = 1, VIS do
		local ry = CON_Y + (i-1)*ROW_H
		if i%2==0 then mkFrame(root,"SvBg"..i, xSVC, ry, PW_SVC, ROW_H, HC.BG_ALT, 0, 2) end
		local tagDot = mkFrame(root,"SvDot"..i, xSVC+4, ry+3, 4, ROW_H-6, HC.T_DIM, 1, 3)
		do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = tagDot end
		local rowL = mkLabel(root, xSVC+12, ry, PW_SVC-16, ROW_H, "", 7, HC.T_SEC, Enum.TextXAlignment.Left, 4)
		rows[i] = { tagDot=tagDot, rowL=rowL }
	end
	local function updateLog(isLock)
		local logLen = #state.consoleLog
		local startI = safe.max(1, logLen - VIS + 1)
		for i = 1, VIS do
			local li = startI + i - 1
			local sr = rows[i]
			if not sr then break end
			if li > logLen then
				sr.tagDot.BackgroundTransparency = 1; sr.rowL.Text = ""
			else
				local e = state.consoleLog[li]
				local tc = TAG_COLOR[e.tag] or HC.T_SEC
				sr.tagDot.BackgroundColor3 = tc; sr.tagDot.BackgroundTransparency = 0
				sr.rowL.Text = safe.format("[%s][%s] %s", e.ts, e.tag, e.msg)
				sr.rowL.TextColor3 = isLock and HC.C_LOCK or tc
			end
		end
	end
	return updateLog
end

------------------------------------------------------------------------
-- §21g  MAIN buildHUD  (shell: card, title, tabs → calls sub-builders)
------------------------------------------------------------------------
local function buildHUD()
	local TH   = 22
	local TABH = 19
	local COLH = 14
	local SBH  = 8
	local DW   = 1
	local CON_Y = TH + TABH + COLH + 3
	local CON_H = cfg.CARD_PY - CON_Y - SBH

	local PW_EXP  = 195
	local PW_PROC = 285
	local PW_PERF = 210
	local PW_DET  = 305
	local PW_SVC  = cfg.CARD_PX - PW_EXP - PW_PROC - PW_PERF - PW_DET - DW*4
	local xEXP  = 0
	local xPROC = PW_EXP + DW
	local xPERF = xPROC + PW_PROC + DW
	local xDET  = xPERF + PW_PERF + DW
	local xSVC  = xDET + PW_DET + DW

	-- Card part
	local card = Instance.new("Part")
	card.Name = "NoobCard"; card.Size = V3(cfg.CARD_W, cfg.CARD_H, 0.03)
	card.Transparency = 1; card.Anchored = true; card.CanCollide = false; card.CastShadow = false
	card.Parent = workspace

	local sgui = Instance.new("SurfaceGui")
	sgui.Face = Enum.NormalId.Front
	sgui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sgui.PixelsPerStud = cfg.PPS; sgui.LightInfluence = 0; sgui.AlwaysOnTop = false
	sgui.Parent = card

	local root = Instance.new("Frame")
	root.Name = "Root"; root.Size = UDim2.new(0,cfg.CARD_PX,0,cfg.CARD_PY)
	root.Position = UDim2.new(0,0,0,0); root.BackgroundColor3 = HC.BG
	root.BackgroundTransparency = 0; root.BorderSizePixel = 0; root.ZIndex = 1; root.Parent = sgui

	-- Lockdown overlay
	local lockOverlay = mkFrame(root,"LockOverlay",0,0,cfg.CARD_PX,cfg.CARD_PY,HC.C_LOCK,0.88,20)
	lockOverlay.Visible = false
	local lockLabel = mkLabel(lockOverlay,0,0,cfg.CARD_PX,cfg.CARD_PY,"!!! EMERGENCY LOCKDOWN !!!",30,Color3.new(1,1,1),Enum.TextXAlignment.Center,21)
	lockLabel.TextYAlignment = Enum.TextYAlignment.Center

	-- Top accent
	local accentTop = mkFrame(root,"AccentTop",0,0,cfg.CARD_PX,2,HC.ACCENT,0,10)

	-- Title bar
	local titleBar = mkFrame(root,"TitleBar",0,2,cfg.CARD_PX,TH-2,HC.HDR,0,8)
	local dot = mkFrame(titleBar,"Dot",7,6,8,8,HC.C_BLU,0,9)
	do local c = Instance.new("UICorner"); c.CornerRadius=UDim.new(1,0); c.Parent=dot end
	mkLabel(titleBar,22,0,460,TH-2,safe.format("Monitor %s  --  v14 Full Defense",cfg.VERSION),8,HC.T_PRI,Enum.TextXAlignment.Left,9)
	local timeL = mkLabel(titleBar,480,0,700,TH-2,"",7,HC.T_SEC,Enum.TextXAlignment.Left,9)

	-- Lockdown badge
	local lockBadge = mkFrame(titleBar,"LockBadge",cfg.CARD_PX-109,3,50,14,Color3.fromRGB(150,0,0),0,9)
	do local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,3);c.Parent=lockBadge end
	mkLabel(lockBadge,0,0,50,14,"LOCKDOWN",6,Color3.fromRGB(255,80,80),Enum.TextXAlignment.Center,10)
	lockBadge.Visible = false

	-- Integrity badge
	local intgBadge = mkFrame(titleBar,"IntgBadge",cfg.CARD_PX-56,3,50,14,Color3.fromRGB(120,0,100),0,9)
	do local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,3);c.Parent=intgBadge end
	local intgLbl = mkLabel(intgBadge,0,0,50,14,"INTG OK",6,Color3.fromRGB(80,255,200),Enum.TextXAlignment.Center,10)

	-- Tab bar
	mkFrame(root,"TitleBorder",0,TH,cfg.CARD_PX,1,HC.DIV,0,9)
	mkFrame(root,"TabBg",0,TH+1,cfg.CARD_PX,TABH,HC.HDR,0,7)
	local tabDefs = {
		{x=xEXP, w=PW_EXP, label="Explorer",   active=true},
		{x=xPROC,w=PW_PROC,label="Processes",   active=true},
		{x=xPERF,w=PW_PERF,label="Performance", active=true},
		{x=xDET, w=PW_DET, label="Details",     active=true},
		{x=xSVC, w=PW_SVC, label="Event Log",   active=true},
	}
	for i, tab in safe.ipairs(tabDefs) do
		mkLabel(root,tab.x+5,TH+2,tab.w-8,TABH-2,tab.label,8,HC.T_PRI,Enum.TextXAlignment.Left,8)
		mkFrame(root,"TabUL"..i,tab.x,TH+TABH,tab.w,2,HC.ACCENT,0,9)
	end
	mkFrame(root,"TabBorder",0,TH+TABH+1,cfg.CARD_PX,1,HC.DIV,0,9)

	-- Column headers
	local chY = TH + TABH + 2
	for _, xd in safe.ipairs({PW_EXP, xPERF, xDET, xSVC}) do
		mkFrame(root,"VDiv"..xd, xd, TH, DW, cfg.CARD_PY-TH, HC.DIV, 0, 5)
	end
	-- Also add divider between Processes and Performance
	mkFrame(root,"VDivProc", xPROC-1, TH, DW, cfg.CARD_PY-TH, HC.DIV, 0, 5)

	mkFrame(root,"ChBgE",xEXP,chY,PW_EXP,COLH,HC.COL_HDR,0,7)
	mkLabel(root,xEXP+4,chY,PW_EXP-6,COLH,"Workspace Hierarchy",7,HC.C_BLU,Enum.TextXAlignment.Left,8)
	mkFrame(root,"ChBorder",0,chY+COLH,cfg.CARD_PX,1,HC.DIV,0,9)

	-- Status bar
	mkFrame(root,"StatusBar",0,cfg.CARD_PY-SBH,cfg.CARD_PX,SBH,HC.SB_COL,0,9)
	local sbLabel = mkLabel(root,4,cfg.CARD_PY-SBH,cfg.CARD_PX-8,SBH,"",6,Color3.new(1,1,1),Enum.TextXAlignment.Left,10)

	-- Build sub-panels (each in its own scope with its own locals)
	local updateExplorer = buildExplorerPanel(root, xEXP, PW_EXP, CON_Y, CON_H)
	local updateProc     = buildProcessesPanel(root, xPROC, PW_PROC, CON_Y, CON_H, chY, COLH)
	local updatePerf     = buildPerfPanel(root, xPERF, PW_PERF, CON_Y, CON_H, chY, COLH)
	local updateDetails  = buildDetailsPanel(root, xDET, PW_DET, CON_Y, CON_H, chY, COLH)
	local updateLog      = buildLogPanel(root, xSVC, PW_SVC, CON_Y, CON_H, chY, COLH)

	-- Master refresh
	local function refresh(now)
		local em = state.emergency
		local elapsed = safe.floor(safe.clock() - cfg.BOOT_TIME)
		local pulse = 0.5 + safe.sin(state.cursorPulse) * 0.5
		local totalIntg = stats.integrityViolations + stats.globalPollutions

		-- Integrity badge
		if totalIntg > 0 then
			intgLbl.Text = safe.format("INTG:%d", totalIntg)
			intgLbl.TextColor3 = HC.C_RED
			intgBadge.BackgroundColor3 = Color3.fromRGB(180,0,100)
		else
			intgLbl.Text = "INTG OK"
			intgLbl.TextColor3 = Color3.fromRGB(80,255,200)
			intgBadge.BackgroundColor3 = Color3.fromRGB(0,100,60)
		end

		-- Lockdown visuals
		em.lockdownBlink = (em.lockdownBlink or 0) + 0.25
		local blinkOn = em.active and (safe.sin(em.lockdownBlink * 10) > 0)
		lockBadge.Visible = em.active
		lockOverlay.Visible = em.active and blinkOn
		accentTop.BackgroundColor3 = em.active and HC.C_LOCK or HC.ACCENT
		titleBar.BackgroundColor3 = em.active and Color3.fromRGB(80,0,0) or HC.HDR

		-- Time / status line
		local perf = state.serverPerf
		local extra
		if em.active then
			extra = safe.format("  [!LOCK nuked:%d]", stats.emergencyNuked)
		else
			extra = safe.format("  intg:%d gui:%d audio:%d phys:%d mem:%d",
				stats.integrityViolations, stats.guiBombsBlocked,
				stats.audioBombsBlocked, stats.physicsAbuse, stats.memBombsBlocked)
		end
		timeL.Text = safe.format("owner:%s  up %02d:%02d:%02d  fps:%.0f  mem:%.0fMB  inst:%d%s",
			cfg.OWNER_NAME, safe.floor(elapsed/3600), safe.floor(elapsed/60)%60, elapsed%60,
			perf.fps, perf.memKb/1024, perf.instances, extra)

		dot.BackgroundColor3 = em.active and Color3.fromRGB(200,30,30)
			or Color3.fromRGB(safe.floor(30+pulse*25), safe.floor(100+pulse*60), safe.floor(180+pulse*50))

		-- Sub-panel updates
		safe.pcall(updateExplorer, now, pulse)
		safe.pcall(updateProc)
		safe.pcall(updatePerf)
		safe.pcall(updateDetails)
		safe.pcall(updateLog, em.active)

		-- Status bar
		sbLabel.Text = safe.format(
			"  Inst:%d Fix:%d BD:%d Spam:%d RemBlk:%d ChatBlk:%d CharViol:%d PropViol:%d DSViol:%d NETOW:%d GUIBmb:%d AuBmb:%d PhysAb:%d MemBmb:%d Kicks:%d INTG:%d%s",
			perf.instances, stats.totalFixes, stats.backdoorsRemoved, stats.spamBursts,
			stats.remoteCallsBlocked, stats.chatCommandsBlocked, stats.charViolations,
			stats.propertyViolations, stats.dsViolations, stats.networkOwnerViolations,
			stats.guiBombsBlocked, stats.audioBombsBlocked, stats.physicsAbuse,
			stats.memBombsBlocked, stats.playersKicked+stats.sdKicks, stats.integrityViolations,
			em.active and "  [!LOCKDOWN]" or "")
	end

	return { card = card, refresh = refresh }
end

-- Build and install HUD
do
	local h = buildHUD()
	state.hud = h
	respawnHUD = function()
		if state.hudRespawning then return end
		state.hudRespawning = true
		addLog("RESP", "HUD deletion detected — rebuilding...")
		stats.hudRespawns += 1
		safe.pcall(function()
			if state.hud.card and state.hud.card.Parent then state.hud.card:Destroy() end
		end)
		task.wait(0.05)
		state.hud = buildHUD()
		addLog("RESP", safe.format("HUD respawned #%d", stats.hudRespawns))
		state.hudRespawning = false
	end
end

-- HUD watchdog
task.spawn(function()
	task.wait(1)
	while true do
		task.wait(cfg.HUD_WATCHDOG_TICK)
		if not state.hudRespawning then
			if not state.hud.card or not state.hud.card.Parent then
				task.spawn(respawnHUD)
			end
		end
	end
end)

------------------------------------------------------------------------
-- §22  VOID ESCAPE
------------------------------------------------------------------------
local function getOwnerOrAnyPos()
	for _, pl in safe.ipairs(svc.Players:GetPlayers()) do
		if pl.Name == cfg.OWNER_NAME then
			local c = pl.Character
			if c then
				local ph = c:FindFirstChild("HumanoidRootPart")
				if ph then return ph.Position + V3(3, 2, 0) end
			end
		end
	end
	for _, pl in safe.ipairs(svc.Players:GetPlayers()) do
		local c = pl.Character
		if c then
			local ph = c:FindFirstChild("HumanoidRootPart")
			if ph then return ph.Position + V3(3, 2, 0) end
		end
	end
	return cfg.SPAWN_POS
end

local function setNpcTransparency(alpha)
	local npc = state.npc
	if not npc.bodyParts then return end
	for _, p in safe.ipairs(npc.bodyParts) do
		local o = npc.origAlpha and npc.origAlpha[p] or 0
		p.Transparency = o + (1 - o) * alpha
	end
	if npc.face then npc.face.Transparency = alpha end
end

local function voidEscape()
	local npc = state.npc
	if state.isVoidFading or not npc.parts.hrp or not npc.parts.hrp.Parent then return end
	state.isVoidFading = true
	stats.npcVoidEscapes += 1
	addLog("VOID", safe.format("void at Y=%.1f — teleporting", npc.parts.hrp.Position.Y))
	local step = cfg.FADE_TIME / cfg.FADE_STEPS
	for i = 1, cfg.FADE_STEPS do setNpcTransparency(i / cfg.FADE_STEPS); task.wait(step) end
	local dest = getOwnerOrAnyPos()
	safe.pcall(function() npc.model:PivotTo(CF(dest)) end)
	safe.pcall(function() npc.hum:MoveTo(dest) end)
	addLog("VOID", safe.format("arrived %.0f %.0f %.0f", dest.X, dest.Y, dest.Z))
	task.wait(0.05)
	for i = cfg.FADE_STEPS, 0, -1 do setNpcTransparency(i / cfg.FADE_STEPS); task.wait(step) end
	state.isVoidFading = false
end

------------------------------------------------------------------------
-- §23  NPC PATHFINDING
------------------------------------------------------------------------
local PATH_PARAMS = { AgentRadius = 2, AgentHeight = 5, AgentCanJump = true, WaypointSpacing = 3, Costs = { Water = 10 } }

local function shouldAbortPath()
	return state.isFollowing or state.emergency.active or state.npcRespawning
end

local function walkToPath(dest, abortCheck)
	local npc = state.npc
	if not npc.parts.hrp or not npc.parts.hrp.Parent or not npc.hum or not npc.hum.Parent then return false end
	local path = svc.PathfindingService:CreatePath(PATH_PARAMS)
	local ok = safe.pcall(function() path:ComputeAsync(npc.parts.hrp.Position, dest) end)
	if not ok or path.Status ~= Enum.PathStatus.Success then
		safe.pcall(function() npc.hum:MoveTo(dest) end)
		local done = false
		local conn
		safe.pcall(function() conn = npc.hum.MoveToFinished:Connect(function() done = true; conn:Disconnect() end) end)
		local elapsed = 0
		while not done and elapsed < 5 do
			elapsed += svc.RunService.Heartbeat:Wait()
			if abortCheck and abortCheck() then
				safe.pcall(function() if conn then conn:Disconnect() end end)
				return false
			end
		end
		return done
	end
	for _, wp in safe.ipairs(path:GetWaypoints()) do
		if abortCheck and abortCheck() then return false end
		if wp.Action == Enum.PathWaypointAction.Jump then safe.pcall(function() npc.hum.Jump = true end) end
		safe.pcall(function() npc.hum:MoveTo(wp.Position) end)
		local done = false
		local conn
		local elapsed = 0
		safe.pcall(function() conn = npc.hum.MoveToFinished:Connect(function() done = true; conn:Disconnect() end) end)
		while not done and elapsed < 4 do
			elapsed += svc.RunService.Heartbeat:Wait()
			if abortCheck and abortCheck() then
				safe.pcall(function() if conn then conn:Disconnect() end end)
				return false
			end
		end
	end
	return true
end

local function randomWanderPoint()
	local a = safe.random() * 2 * safe.pi
	local d = safe.random(5, safe.max(6, safe.ceil(cfg.WANDER_RANGE)))
	return V3(cfg.SPAWN_POS.X + safe.cos(a) * d, cfg.SPAWN_POS.Y, cfg.SPAWN_POS.Z + safe.sin(a) * d)
end

local function getOwnerRootPart()
	local npc = state.npc
	for _, p in safe.ipairs(svc.Players:GetPlayers()) do
		if p.Name == cfg.OWNER_NAME then
			local c = p.Character
			if not c then return nil, 0 end
			local ph = c:FindFirstChild("HumanoidRootPart")
			if not ph then return nil, 0 end
			return ph, (ph.Position - npc.parts.hrp.Position).Magnitude
		end
	end
	return nil, 0
end

local function chooseBehavior()
	if state.emergency.active then return "huntBackdoor" end
	if stats.scansSinceFix > 4 then return "huntBackdoor" end
	local r = safe.random()
	if r < 0.30 then return "fixScript"
	elseif r < 0.50 then return "explore"
	elseif r < 0.70 then return "huntBackdoor"
	elseif r < 0.85 then return "patrol"
	else return "wander" end
end

-- Owner following
svc.RunService.Heartbeat:Connect(function(dt)
	local npc = state.npc
	if not npc.hum or not npc.hum.Parent or not npc.parts.hrp or not npc.parts.hrp.Parent then return end
	if state.emergency.active then return end
	local ownerPart, ownerDist = getOwnerRootPart()
	if ownerPart then
		state.isFollowing = true
		state.stareTimer = cfg.STARE_DURATION
		local lookPos = V3(ownerPart.Position.X, npc.parts.hrp.Position.Y, ownerPart.Position.Z)
		safe.pcall(function()
			npc.parts.hrp.CFrame = npc.parts.hrp.CFrame:Lerp(LOOK(npc.parts.hrp.Position, lookPos), safe.min(1, cfg.LOOK_SPEED * dt))
			if ownerDist > cfg.APPROACH_DIST + 2 then
				npc.hum:MoveTo(ownerPart.Position)
			else
				npc.hum:MoveTo(npc.parts.hrp.Position)
			end
		end)
	else
		if state.stareTimer > 0 then
			state.stareTimer -= dt
		else
			state.isFollowing = false
		end
	end
end)

-- Main behavior loop
task.spawn(function()
	task.wait(2)
	while true do
		if shouldAbortPath() then
			repeat task.wait(0.1) until not shouldAbortPath()
			task.wait(0.3)
		end
		task.wait(safe.random() * (cfg.PAUSE_MAX - cfg.PAUSE_MIN) + cfg.PAUSE_MIN)
		if shouldAbortPath() then continue end
		local beh = chooseBehavior()
		if beh == "patrol" then
			local wp = state.patrolPoints[state.patrolIdx]
			if wp then
				stats.npcPatrolSteps += 1
				addLog("PATROL", safe.format("patrol %d/%d", state.patrolIdx, #state.patrolPoints))
				walkToPath(wp, shouldAbortPath)
				state.patrolIdx = (state.patrolIdx % #state.patrolPoints) + 1
			end
		elseif beh == "huntBackdoor" or beh == "fixScript" then
			local tree = state.explorerTree
			local treeLen = #tree
			if treeLen > 0 and tree[state.expSelected] then
				local selInst = tree[state.expSelected].inst
				if selInst and isScript(selInst) then
					stats.npcScriptsHunted += 1
					local ok, ancestor = safe.pcall(function()
						local cur = selInst
						for _ = 1, 8 do
							if not cur or not cur.Parent then return nil end
							if cur:IsA("Model") and cur.Parent == workspace then return cur end
							cur = cur.Parent
						end
						return nil
					end)
					if ok and ancestor and ancestor.PrimaryPart then
						walkToPath(ancestor.PrimaryPart.Position + V3(0, 0, 3), shouldAbortPath)
					end
				end
			end
		elseif beh == "wander" then
			walkToPath(randomWanderPoint(), shouldAbortPath)
		end
	end
end)

------------------------------------------------------------------------
-- §24  HUD CARD MOVEMENT + VOID DETECTION + PERF HEARTBEAT
------------------------------------------------------------------------
local hbState = { instCount = svc.Stats.InstanceCount, lastTime = safe.clock(), accum = 0 }

svc.RunService.Heartbeat:Connect(function(dt)
	state.smoothFPS = state.smoothFPS * 0.93 + (1 / safe.max(dt, 0.001)) * 0.07
	state.serverPerf.fps = state.smoothFPS
	local now = safe.clock()
	local npc = state.npc

	-- Instance spike detection
	local cur = svc.Stats.InstanceCount
	local delta = cur - hbState.instCount
	hbState.instCount = cur
	hbState.accum += safe.max(0, delta)
	if now - hbState.lastTime >= cfg.HB_WINDOW then
		if hbState.accum > cfg.EMERG_SPIKE_THRESHOLD then
			triggerEmergency(safe.format("spike +%d inst in %.2fs", hbState.accum, now - hbState.lastTime), nil)
		end
		hbState.accum = 0
		hbState.lastTime = now
	end

	-- ═══ CARD MOVEMENT: follow NPC head + face nearest player ═══
	safe.pcall(function()
		if not state.hud.card or not state.hud.card.Parent then return end
		if not npc.parts or not npc.parts.head or not npc.parts.head.Parent then return end

		local hp = npc.parts.head.Position + V3(0, cfg.CARD_ABOVE, 0)

		-- Find the nearest player with a character to face toward
		local bestPart, bestDist = nil, safe.huge
		for _, p in safe.ipairs(svc.Players:GetPlayers()) do
			if p.Character then
				local ph = p.Character:FindFirstChild("HumanoidRootPart")
				if ph then
					local d = (ph.Position - hp).Magnitude
					-- Prioritise owner, otherwise pick closest
					if p.Name == cfg.OWNER_NAME then
						bestPart = ph; bestDist = -1; break
					elseif d < bestDist then
						bestPart = ph; bestDist = d
					end
				end
			end
		end

		if bestPart then
			local lookTarget = V3(bestPart.Position.X, hp.Y, bestPart.Position.Z)
			state.hud.card.CFrame = LOOK(hp, lookTarget)
		else
			-- No players — just face the NPC's look direction
			if npc.parts.hrp and npc.parts.hrp.Parent then
				local fwd = npc.parts.hrp.CFrame.LookVector
				state.hud.card.CFrame = LOOK(hp, hp + V3(fwd.X, 0, fwd.Z))
			else
				state.hud.card.CFrame = CF(hp)
			end
		end
	end)

	-- ═══ VOID CHECK ═══
	safe.pcall(function()
		if not state.emergency.active and not state.isVoidFading
			and npc.parts.hrp and npc.parts.hrp.Parent
			and npc.parts.hrp.Position.Y < cfg.VOID_Y
		then
			task.spawn(voidEscape)
		end
	end)
end)

------------------------------------------------------------------------
-- §25  SERVER PERFORMANCE POLLING
------------------------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0.5)
		state.serverPerf.memKb = gcinfo()
		state.serverPerf.instances = svc.Stats.InstanceCount
		safe.pcall(function()
			local ps = svc.Stats:FindFirstChild("PhysicsStepTimeMs")
			if ps then state.serverPerf.physicsMs = ps:GetValue() / 1000 end
			local rx = svc.Stats:FindFirstChild("DataReceiveKbps")
			if rx then state.serverPerf.netRxKbps = rx:GetValue() end
			local tx = svc.Stats:FindFirstChild("DataSendKbps")
			if tx then state.serverPerf.netTxKbps = tx:GetValue() end
		end)
		checkEmergencyRecovery()
		if state.emergency.active then stats.lockdownSeconds += 0.5 end
	end
end)

------------------------------------------------------------------------
-- §26  DESCENDANT MONITORING
------------------------------------------------------------------------
local function classifyInstance(inst)
	local c = inst.ClassName
	if c == "Script" or c == "LocalScript" or c == "ModuleScript" then return "SCRIPT" end
	if c == "RemoteEvent" or c == "RemoteFunction" then return "REMOTE" end
	if c == "BindableEvent" or c == "BindableFunction" then return "BINDABLE" end
	return nil
end

checkNewScript = function(inst)
	stats.newScriptsAdded += 1
	stats.scriptsScanned += 1
	local a = analyzeScript(inst)
	if a.score >= 100 then
		stats.liveInjections += 1
		addLog("DOOR", safe.format("live injection '%s' score=%d", inst.Name, a.score))
		triggerEmergency("live injection: " .. inst.Name, traceSourcePlayer(inst))
		local n = fixScript(inst)
		if n > 0 then
			stats.totalFixes += n
			addLog("KILL", "injection quarantined: " .. inst.Name)
		end
	elseif #a.threats > 0 then
		addLog("WARN", safe.format("suspicious '%s' score=%d", inst.Name, a.score))
	elseif #a.rules > 0 then
		addLog("SCPT", safe.format("'%s' has %d issue(s)", inst.Name, #a.rules))
	else
		addLog("OK", "new script '" .. inst.Name .. "' passed scan")
	end
end

workspace.DescendantAdded:Connect(function(inst)
	if not cfg.SCAN_NEW then return end
	local npc = state.npc
	if inst == npc.model or (npc.model and inst:IsDescendantOf(npc.model)) then return end
	local nm = inst.Name or ""
	if nm:find("_fixed$") or nm:find("%[BACKDOOR%]") or nm:find("%[SSEXEC%]") or nm == "NoobCard" then return end
	stats.workspaceAdds += 1
	local em = state.emergency
	if em.active and nameInSet(inst.ClassName, EMERG_FLOOD_CLASSES) and not em.snapshot[inst] then
		safe.insert(em.floodQueue, { inst = inst, addedAt = safe.clock() })
		return
	end
	trackSpam(inst)
	local kind = classifyInstance(inst)
	if not kind then return end
	if cfg.LOG_ADDS and not em.active then
		local pn = ""
		safe.pcall(function() pn = inst.Parent and inst.Parent.Name or "?" end)
		addLog("WCHG", safe.format("+%s '%s' in '%s'", kind, inst.Name, pn))
	end
	if kind == "SCRIPT" and not state.monitorDebounce[inst] then
		state.monitorDebounce[inst] = true
		task.delay(em.active and 0 or cfg.SCAN_DEBOUNCE, function()
			state.monitorDebounce[inst] = nil
			if inst and inst.Parent then checkNewScript(inst) end
		end)
	elseif kind == "REMOTE" or kind == "BINDABLE" then
		local matched, matchedSig = nameMatchesAny(inst.Name, sig.backdoor_names)
		if matched then
			addLog("DOOR", safe.format("suspicious %s '%s' (sig: %s)", kind, inst.Name, matchedSig))
			stats.backdoorsFound += 1
			triggerEmergency("suspicious " .. kind .. ": " .. inst.Name, traceSourcePlayer(inst))
		end
	end
end)

workspace.DescendantRemoving:Connect(function(inst)
	stats.workspaceRemoves += 1
	local now = safe.clock()
	local dt = state.descendantDestroyTracker
	if now - dt.windowStart > cfg.DESCENDANT_DESTROY_WINDOW then
		dt.count = 0; dt.windowStart = now
	end
	dt.count += 1
	if dt.count >= cfg.DESCENDANT_DESTROY_MAX then
		stats.massDestroyBlocked += 1
		addLog("CRASH", safe.format("MASS DESTROY DETECTED: %d removals/%.1fs", dt.count, cfg.DESCENDANT_DESTROY_WINDOW))
		triggerEmergency("mass-destroy attack: workspace", nil)
		dt.count = 0
	end
end)

game.DescendantAdded:Connect(function(inst)
	if not cfg.SCAN_NEW then return end
	if inst:IsDescendantOf(workspace) then return end
	local npc = state.npc
	if inst == npc.model or (npc.model and inst:IsDescendantOf(npc.model)) then return end
	local kind = classifyInstance(inst)
	if kind == "SCRIPT" and not state.monitorDebounce[inst] then
		state.monitorDebounce[inst] = true
		task.delay(state.emergency.active and 0 or cfg.SCAN_DEBOUNCE, function()
			state.monitorDebounce[inst] = nil
			if inst and inst.Parent then checkNewScript(inst) end
		end)
	end
end)

------------------------------------------------------------------------
-- §27  REMOTE FLOOD MONITOR
------------------------------------------------------------------------
local function monitorRemote(remote)
	if not remote:IsA("RemoteEvent") then return end
	remote.OnServerEvent:Connect(function(player)
		local now = safe.clock()
		local key = remote.Name .. "_" .. player.Name
		if not state.perPlayerRemote[key] then state.perPlayerRemote[key] = { count = 0, windowStart = now } end
		local e = state.perPlayerRemote[key]
		if now - e.windowStart > 1.0 then e.count = 0; e.windowStart = now end
		e.count += 1
		if e.count >= cfg.REMOTE_FLOOD_THRESHOLD then
			stats.remoteFloods += 1
			stats.remoteCallsBlocked += e.count
			addLog("RFLOOD", safe.format("remote flood: '%s' %d/s from %s", remote.Name, e.count, player.Name))
			triggerEmergency("remote flood: " .. remote.Name, player)
			e.count = 0
		end
	end)
end

task.spawn(function()
	task.wait(2)
	for _, inst in safe.ipairs(game:GetDescendants()) do
		if inst:IsA("RemoteEvent") then safe.pcall(monitorRemote, inst) end
	end
end)
game.DescendantAdded:Connect(function(inst)
	if inst:IsA("RemoteEvent") then
		task.delay(0.5, function()
			if inst and inst.Parent then safe.pcall(monitorRemote, inst) end
		end)
	end
end)

------------------------------------------------------------------------
-- §28  PROFILER
------------------------------------------------------------------------
local PROFILER_ROOTS = { "Workspace", "ServerScriptService", "ReplicatedStorage", "ServerStorage", "Lighting" }

local function rebuildProfiler()
	local now = safe.clock()
	local dt = safe.max(0.001, now - state.profilerLastT)
	local raw = {}
	for _, sn in safe.ipairs(PROFILER_ROOTS) do
		local ok, s = safe.pcall(function() return game:GetService(sn) end)
		if not ok or not s then continue end
		local ok2, ch = safe.pcall(function() return s:GetChildren() end)
		if not ok2 then continue end
		for _, child in safe.ipairs(ch) do
			if child == state.npc.model then continue end
			local ok3, desc = safe.pcall(function() return child:GetDescendants() end)
			if not ok3 then continue end
			local ic, pc, sc, dc, rc = #desc + 1, 0, 0, 0, 0
			for _, d in safe.ipairs(desc) do
				if d:IsA("BasePart") then pc += 1
				elseif isScript(d) then sc += 1
				elseif d:IsA("Decal") or d:IsA("Texture") then dc += 1
				elseif d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then rc += 1 end
			end
			local path = sn .. "." .. child.Name
			local prev = state.profilerPrev[path] or ic
			state.profilerPrev[path] = ic
			safe.insert(raw, {
				name = child.Name, service = sn, instCount = ic,
				partCount = pc, scriptCount = sc, decalCount = dc,
				remoteCount = rc, growRate = (ic - prev) / dt,
			})
		end
	end
	safe.sort(raw, function(a, b) return a.instCount > b.instCount end)
	state.profilerData = {}
	for i = 1, safe.min(cfg.PROFILER_ROWS, #raw) do state.profilerData[i] = raw[i] end
	state.profilerLastT = now
	stats.profilerRuns += 1
end

task.spawn(function()
	task.wait(4)
	while true do
		task.wait(cfg.PROFILER_INTERVAL)
		if not state.emergency.active then safe.pcall(rebuildProfiler) end
	end
end)

------------------------------------------------------------------------
-- §29  WORLD SWEEP
------------------------------------------------------------------------
local function worldSweep()
	local npc = state.npc
	stats.sweepCount += 1
	addLog("SCAN", safe.format("world sweep #%d", stats.sweepCount))

	-- Purge fallen parts
	local fell = 0
	safe.pcall(function()
		for _, p in safe.ipairs(workspace:GetDescendants()) do
			if p:IsA("BasePart") and not p.Anchored and p.Position.Y < -400
				and p ~= npc.parts.hrp and p ~= npc.parts.torso and p ~= npc.parts.head then
				p:Destroy(); fell += 1
			end
		end
	end)

	-- Fix NaN positions
	local nans = 0
	safe.pcall(function()
		for _, p in safe.ipairs(workspace:GetDescendants()) do
			if p:IsA("BasePart") then
				local x = p.Position.X
				if x ~= x or safe.abs(x) == safe.huge then
					p.CFrame = CF(cfg.SPAWN_POS + V3(safe.random(-5, 5), 2, safe.random(-5, 5)))
					p.AssemblyLinearVelocity = Vector3.zero
					nans += 1
				end
			end
		end
	end)

	-- Fix broken joints
	local joints = 0
	safe.pcall(function()
		for _, j in safe.ipairs(workspace:GetDescendants()) do
			if j:IsA("JointInstance") and (not j.Part0 or not j.Part1) then j:Destroy(); joints += 1 end
		end
	end)

	-- Clamp runaway velocities
	local runaway = 0
	safe.pcall(function()
		for _, p in safe.ipairs(workspace:GetDescendants()) do
			if p:IsA("BasePart") and not p.Anchored and p ~= npc.parts.hrp then
				if p.AssemblyLinearVelocity.Magnitude > 800 then
					p.AssemblyLinearVelocity = Vector3.zero
					p.AssemblyAngularVelocity = Vector3.zero
					runaway += 1
				end
			end
		end
	end)

	-- Fix lighting
	local ltf = {}
	safe.pcall(function()
		if svc.Lighting.ClockTime < 0 or svc.Lighting.ClockTime > 24 then svc.Lighting.ClockTime = 14; safe.insert(ltf, "ClockTime=14") end
		if svc.Lighting.Brightness < 0 then svc.Lighting.Brightness = 1; safe.insert(ltf, "Brightness=1") end
		if svc.Lighting.FogEnd < 0 then svc.Lighting.FogEnd = 100000; safe.insert(ltf, "FogEnd=100000") end
	end)

	-- Instance spike
	local spike = svc.Stats.InstanceCount - state.lastKnownInst
	state.lastKnownInst = svc.Stats.InstanceCount

	if fell > 0 then stats.fallenPartsRemoved += fell; stats.totalFixes += fell; addLog("FIX", safe.format("purged %d fallen parts", fell)) end
	if nans > 0 then stats.nanFixed += nans; stats.totalFixes += nans; addLog("FIX", safe.format("corrected %d NaN/Inf", nans)) end
	if joints > 0 then stats.jointsFixed += joints; stats.totalFixes += joints; addLog("FIX", safe.format("removed %d null joints", joints)) end
	if runaway > 0 then stats.velocityFixed += runaway; stats.totalFixes += runaway; addLog("FIX", safe.format("clamped %d velocities", runaway)) end
	if #ltf > 0 then stats.lightingFixed += #ltf; stats.totalFixes += #ltf; addLog("FIX", "lighting: " .. safe.concat(ltf, " ")) end
	if spike > 500 then addLog("WARN", safe.format("instance spike +%d", spike)); triggerEmergency("maintenance spike +" .. spike, nil) end
end

task.spawn(function()
	task.wait(8)
	while true do
		task.wait(14 + safe.random() * 4)
		if not state.emergency.active then safe.pcall(worldSweep) end
	end
end)

------------------------------------------------------------------------
-- §30  SCHEDULED SCRIPT SCANNER
------------------------------------------------------------------------
task.spawn(function()
	task.wait(6)
	while true do
		local interval = state.emergency.active and 2.0 or (cfg.SCAN_INTERVAL + safe.random() * 5)
		task.wait(interval)
		addLog("SCAN", "scheduled scan...")
		local scriptList = getAllScripts()
		addLog("SCAN", safe.format("%d scripts in scope", #scriptList))
		local target = pickPriorityScript(scriptList)
		if not target then
			addLog("OK", "no scripts require attention")
			stats.scansSinceFix += 1
			continue
		end
		local a = analyzeScript(target)
		stats.scriptsScanned += 1
		addLog("SCPT", safe.format("inspecting '%s' score=%d threats=%d", target.Name, a.score, #a.threats))
		scriptMemRecord(target, #a.rules + #a.threats, 0)
		if a.score >= 100 then
			addLog("DOOR", safe.format("critical: '%s' score=%d", target.Name, a.score))
			triggerEmergency("critical script: " .. target.Name, traceSourcePlayer(target))
			task.wait(0.3)
			local n = fixScript(target)
			if n > 0 then stats.scansSinceFix = 0; stats.totalFixes += n; addLog("KILL", "quarantined: " .. target.Name) end
		elseif #a.threats > 0 then
			addLog("WARN", safe.format("suspicious: '%s' score=%d", target.Name, a.score))
		elseif #a.rules > 0 then
			task.wait(0.5)
			local n = fixScript(target)
			scriptMemRecord(target, 0, n)
			if n > 0 then stats.scansSinceFix = 0; stats.totalFixes += n; addLog("EDIT", safe.format("%d patch(es) '%s'", n, target.Name)) end
		else
			scriptMemRecord(target, 0, 0)
			addLog("OK", safe.format("'%s' clean", target.Name))
			stats.scansSinceFix += 1
		end
	end
end)

------------------------------------------------------------------------
-- §31  EXPLORER BROWSER
------------------------------------------------------------------------
task.spawn(function()
	task.wait(3)
	while true do
		local beh = chooseBehavior()
		local speed = (beh == "fixScript" or beh == "huntBackdoor" or state.emergency.active)
			and cfg.HUNT_SPEED or cfg.BROWSE_SPEED + safe.random() * cfg.BROWSE_VARIANCE
		task.wait(speed)
		local tree = state.explorerTree
		local treeLen = #tree
		if treeLen == 0 then continue end
		if beh == "fixScript" or beh == "huntBackdoor" or state.emergency.active then
			local scriptNodes = {}
			for i, e in safe.ipairs(tree) do
				if e and e.inst and isScript(e.inst) then safe.insert(scriptNodes, { idx = i, inst = e.inst }) end
			end
			if #scriptNodes > 0 then
				local insts = {}
				for _, sn in safe.ipairs(scriptNodes) do safe.insert(insts, sn.inst) end
				local tgt = pickPriorityScript(insts)
				if tgt then
					for i, e in safe.ipairs(tree) do
						if e and e.inst == tgt then state.expSelected = i; break end
					end
				end
			end
		elseif beh == "explore" then
			if safe.random() < 0.6 then state.expSelected = safe.random(1, treeLen)
			else state.expSelected = safe.min(state.expSelected + 1, treeLen) end
		else
			if safe.random() < 0.5 then state.expSelected = safe.min(state.expSelected + 1, treeLen)
			else state.expSelected = safe.max(state.expSelected - 1, 1) end
		end
	end
end)

------------------------------------------------------------------------
-- §32  PLAYER EVENTS
------------------------------------------------------------------------
svc.Players.PlayerAdded:Connect(function(p)
	stats.playersJoined += 1
	addLog("JOIN", safe.format("connected: %s  userId=%d  age=%dd", p.Name, p.UserId, p.AccountAge))
	if p.Name == cfg.OWNER_NAME then addLog("JOIN", "OWNER online: " .. cfg.OWNER_NAME) end
end)
svc.Players.PlayerRemoving:Connect(function(p)
	addLog("JOIN", "disconnected: " .. p.Name)
	state.emergency.strikeMap[p.Name] = nil
	stats.sdStrikes[p.Name] = nil
	state.remoteCallTracker[p.Name] = nil
	state.chatCmdTracker[p.Name] = nil
	if state.charConnections[p.Name] then
		for _, conn in safe.ipairs(state.charConnections[p.Name]) do safe.pcall(function() conn:Disconnect() end) end
		state.charConnections[p.Name] = nil
	end
	for k in safe.pairs(state.perPlayerRemote) do
		if safe.find(k, p.Name, 1, true) then state.perPlayerRemote[k] = nil end
	end
end)

------------------------------------------------------------------------
-- §33  INTEGRITY AUDIT TASKS
------------------------------------------------------------------------
task.spawn(function()
	task.wait(3)
	snapshotG()
	local n = 0; for _ in safe.pairs(state.gSnapshot) do n += 1 end
	addLog("INTG", safe.format("_G snapshot: %d keys tracked", n))
end)
task.spawn(function()
	task.wait(5)
	while true do
		task.wait(cfg.INTEGRITY_INTERVAL)
		safe.pcall(auditStdLibs)
		safe.pcall(auditRobloxAPI)
		safe.pcall(auditMetatables)
	end
end)
task.spawn(function()
	task.wait(8)
	while true do task.wait(cfg.G_POLL_INTERVAL); safe.pcall(auditGlobals) end
end)

------------------------------------------------------------------------
-- §34  HUD UI LOOP
------------------------------------------------------------------------
task.spawn(function()
	while true do
		state.cursorPulse += 0.18
		safe.pcall(function()
			if state.hud.refresh then state.hud.refresh(safe.clock()) end
		end)
		task.wait(cfg.UI_REFRESH)
	end
end)

------------------------------------------------------------------------
-- §35  ARGUMENT SANITISER
------------------------------------------------------------------------
local function stringIsDangerous(s)
	if safe.type(s) ~= "string" then return false end
	local sl = safe.lower(s)
	for key in safe.pairs(sig.dangerous_args) do
		if safe.find(sl, key, 1, true) then return true end
	end
	return false
end

local function instanceIsSafe(inst)
	if not inst or not inst.Parent then return false end
	local cur = inst
	local depth = 0
	while cur and cur ~= game do
		depth += 1
		if depth > cfg.MAX_INSTANCE_DEPTH then return false end
		local cn = cur.ClassName
		if cn == "ServerStorage" or cn == "ServerScriptService" then return false end
		cur = cur.Parent
	end
	return true
end

local function validateArgs(player, remoteName, args)
	local argc = safe.select("#", safe.unpack(args))
	if argc > cfg.MAX_ARGS then return false, safe.format("too many args (%d > %d)", argc, cfg.MAX_ARGS) end
	for i, arg in safe.ipairs(args) do
		local t = safe.type(arg)
		if t == "string" then
			if #arg > cfg.MAX_STRING_ARG then
				stats.stringViolations += 1
				return false, safe.format("arg %d string too long (%d chars)", i, #arg)
			end
			if stringIsDangerous(arg) then
				stats.stringViolations += 1
				return false, safe.format("arg %d contains dangerous payload: %.60s", i, arg)
			end
		elseif t == "userdata" then
			local ok, isInst = safe.pcall(function() return arg:IsA("Instance") end)
			if ok and isInst and not instanceIsSafe(arg) then
				stats.instanceViolations += 1
				return false, safe.format("arg %d Instance in forbidden ancestry", i)
			end
		elseif t == "number" then
			if arg ~= arg or safe.abs(arg) == safe.huge then
				stats.typeViolations += 1
				return false, safe.format("arg %d is NaN or Inf", i)
			end
		elseif t == "table" then
			stats.typeViolations += 1
			return false, safe.format("arg %d is a table (forbidden from client)", i)
		end
	end
	return true, "ok"
end

------------------------------------------------------------------------
-- §36  REMOTE WRAPPER + FLOOD GUARD
------------------------------------------------------------------------
local function checkRemoteFlood(player, remoteName)
	local now = safe.clock()
	local pn = player.Name
	if not state.remoteCallTracker[pn] then state.remoteCallTracker[pn] = {} end
	local pt = state.remoteCallTracker[pn]
	if not pt[remoteName] then pt[remoteName] = { count = 0, windowStart = now } end
	local e = pt[remoteName]
	if now - e.windowStart > cfg.ARG_FLOOD_WINDOW then e.count = 0; e.windowStart = now end
	e.count += 1
	if e.count >= cfg.ARG_FLOOD_MAX then
		stats.floodViolations += 1
		e.count = 0
		return false, safe.format("%d calls in %.1fs on '%s'", cfg.ARG_FLOOD_MAX, cfg.ARG_FLOOD_WINDOW, remoteName)
	end
	return true, "ok"
end

local function wrapRemote(remote)
	if state.wrappedRemotes[remote] then return end
	state.wrappedRemotes[remote] = true
	if remote:IsA("RemoteEvent") then
		remote.OnServerEvent:Connect(function(player, ...)
			stats.remoteCalls += 1
			if player.Name ~= cfg.OWNER_NAME then
				local floodOk, floodReason = checkRemoteFlood(player, remote.Name)
				if not floodOk then
					stats.remoteCallsBlocked += 1
					addLog("SRFL", safe.format("REMOTE FLOOD blocked: %s on '%s' — %s", player.Name, remote.Name, floodReason))
					sdStrike(player, "remote flood: " .. remote.Name)
					return
				end
				local args = {...}
				local argOk, argReason = validateArgs(player, remote.Name, args)
				if not argOk then
					stats.remoteCallsBlocked += 1
					stats.argViolations += 1
					addLog("SARG", safe.format("ARG BLOCKED [%s → %s]: %s", player.Name, remote.Name, argReason))
					sdStrike(player, "bad remote arg: " .. argReason)
					return
				end
			end
		end)
	elseif remote:IsA("RemoteFunction") then
		local original = remote.OnServerInvoke
		remote.OnServerInvoke = function(player, ...)
			stats.remoteCalls += 1
			if player.Name ~= cfg.OWNER_NAME then
				local floodOk, floodReason = checkRemoteFlood(player, remote.Name .. "_fn")
				if not floodOk then
					stats.remoteCallsBlocked += 1
					addLog("SRFL", safe.format("RFUNC FLOOD blocked: %s '%s'", player.Name, remote.Name))
					sdStrike(player, "remote function flood: " .. remote.Name)
					return nil
				end
				local args = {...}
				local argOk, argReason = validateArgs(player, remote.Name, args)
				if not argOk then
					stats.remoteCallsBlocked += 1
					stats.argViolations += 1
					addLog("SARG", safe.format("RFUNC ARG BLOCKED [%s → %s]: %s", player.Name, remote.Name, argReason))
					sdStrike(player, "bad rfunc arg: " .. argReason)
					return nil
				end
			end
			if original then return original(player, ...) end
			return nil
		end
	end
end

-- Initial remote wrap
task.spawn(function()
	task.wait(1)
	for _, inst in safe.ipairs(game:GetDescendants()) do
		if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") then safe.pcall(wrapRemote, inst) end
	end
	local n = 0; for _ in safe.pairs(state.wrappedRemotes) do n += 1 end
	addLog("SDEF", safe.format("wrapped %d existing remotes", n))
end)

-- Wrap new remotes
game.DescendantAdded:Connect(function(inst)
	if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") then
		task.delay(0.2, function()
			if inst and inst.Parent then safe.pcall(wrapRemote, inst) end
		end)
	end
end)

-- Periodic re-wrap integrity check
task.spawn(function()
	task.wait(10)
	while true do
		task.wait(30)
		local total, newlyWrapped = 0, 0
		for _, inst in safe.ipairs(game:GetDescendants()) do
			if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") then
				total += 1
				if not state.wrappedRemotes[inst] then safe.pcall(wrapRemote, inst); newlyWrapped += 1 end
			end
		end
		if newlyWrapped > 0 then
			addLog("SDEF", safe.format("integrity re-wrap: %d new remotes (%d total)", newlyWrapped, total))
		end
	end
end)

------------------------------------------------------------------------
-- §37  CHAT COMMAND INTERCEPTION
------------------------------------------------------------------------
local ADMIN_WHITELIST = { [cfg.OWNER_NAME] = true }

local function scanChatMessage(player, message)
	if ADMIN_WHITELIST[player.Name] then return false, "" end
	local ml = safe.lower(message)
	for _, pat in safe.ipairs(sig.admin_triggers) do
		if safe.find(ml, pat, 1, true) then return true, pat end
	end
	return false, ""
end

local function checkChatFlood(player)
	local now = safe.clock()
	local pn = player.Name
	if not state.chatCmdTracker[pn] then state.chatCmdTracker[pn] = { count = 0, windowStart = now } end
	local e = state.chatCmdTracker[pn]
	if now - e.windowStart > cfg.ARG_FLOOD_WINDOW then e.count = 0; e.windowStart = now end
	e.count += 1
	return e.count >= cfg.CMD_FLOOD_MAX
end

local function hookPlayerChat(player)
	player.Chatted:Connect(function(msg)
		stats.chatCommandsSeen += 1
		local flagged, pattern = scanChatMessage(player, msg)
		if flagged then
			stats.chatCommandsBlocked += 1
			stats.adminAbuseAttempts += 1
			addLog("SCMD", safe.format("ADMIN CMD BLOCKED: %s said '%.60s' (matched: %s)", player.Name, msg, pattern))
			sdStrike(player, "admin command attempt: " .. pattern)
		elseif checkChatFlood(player) then
			addLog("SCMD", safe.format("CHAT FLOOD: %s (%d msgs/%.1fs)", player.Name, cfg.CMD_FLOOD_MAX, cfg.ARG_FLOOD_WINDOW))
			sdStrike(player, "chat flood")
		end
	end)
end

for _, player in safe.ipairs(svc.Players:GetPlayers()) do hookPlayerChat(player) end
svc.Players.PlayerAdded:Connect(hookPlayerChat)

------------------------------------------------------------------------
-- §38  CHARACTER / HUMANOID PROPERTY GUARD
------------------------------------------------------------------------
local function guardHumanoid(player, hum2, hrp2)
	if not hum2 or not hrp2 then return end
	if hum2.WalkSpeed > cfg.MAX_WALKSPEED and player.Name ~= cfg.OWNER_NAME then
		addLog("SCHAR", safe.format("WalkSpeed reset: %s had %.0f", player.Name, hum2.WalkSpeed))
		hum2.WalkSpeed = 16; stats.speedResets += 1; stats.charViolations += 1
	end
	if hum2.JumpPower > cfg.MAX_JUMPPOWER and player.Name ~= cfg.OWNER_NAME then
		addLog("SCHAR", safe.format("JumpPower reset: %s had %.0f", player.Name, hum2.JumpPower))
		hum2.JumpPower = 50; stats.speedResets += 1
	end
	local hp = hum2.Health
	if hp ~= hp or hp < 0 then
		addLog("SCHAR", safe.format("Health corrected: %s had %.2f", player.Name, hp))
		hum2.Health = hum2.MaxHealth; stats.healthResets += 1; stats.charViolations += 1
	end
	if hrp2.Anchored and player.Name ~= cfg.OWNER_NAME then
		addLog("SCHAR", safe.format("HRP unanchored: %s was frozen", player.Name))
		hrp2.Anchored = false; stats.anchorResets += 1; stats.charViolations += 1
		sdStrike(player, "character anchored externally")
	end
end

local function startCharacterGuard(player)
	local function onCharAdded(char)
		if state.charConnections[player.Name] then
			for _, c in safe.ipairs(state.charConnections[player.Name]) do safe.pcall(function() c:Disconnect() end) end
		end
		state.charConnections[player.Name] = {}
		local hum2 = char:WaitForChild("Humanoid", 5)
		local hrp2 = char:WaitForChild("HumanoidRootPart", 5)
		if not hum2 or not hrp2 then return end
		local conns = state.charConnections[player.Name]
		safe.insert(conns, svc.RunService.Heartbeat:Connect(function()
			if not char.Parent then return end
			safe.pcall(guardHumanoid, player, hum2, hrp2)
		end))
		safe.insert(conns, hum2:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			safe.pcall(guardHumanoid, player, hum2, hrp2)
		end))
		safe.insert(conns, hum2:GetPropertyChangedSignal("JumpPower"):Connect(function()
			safe.pcall(guardHumanoid, player, hum2, hrp2)
		end))
		safe.insert(conns, hrp2:GetPropertyChangedSignal("Anchored"):Connect(function()
			safe.pcall(guardHumanoid, player, hum2, hrp2)
		end))
	end
	if player.Character then onCharAdded(player.Character) end
	if not state.charConnections[player.Name] then state.charConnections[player.Name] = {} end
	safe.insert(state.charConnections[player.Name], player.CharacterAdded:Connect(onCharAdded))
end

for _, player in safe.ipairs(svc.Players:GetPlayers()) do startCharacterGuard(player) end
svc.Players.PlayerAdded:Connect(startCharacterGuard)

------------------------------------------------------------------------
-- §39  WORKSPACE PROPERTY GUARD
------------------------------------------------------------------------
local function checkWorkspaceProps()
	local g = workspace.Gravity
	if g < cfg.GRAVITY_MIN or g > cfg.GRAVITY_MAX or g ~= g then
		addLog("SPROP", safe.format("Gravity corrected: %.1f → %.1f", g, cfg.SAFE_GRAVITY))
		workspace.Gravity = cfg.SAFE_GRAVITY; stats.gravityResets += 1; stats.propertyViolations += 1
	end
	local fpdh = workspace.FallenPartsDestroyHeight
	if fpdh > 0 then
		addLog("SPROP", safe.format("FallenPartsDestroyHeight corrected: %.0f → -500", fpdh))
		workspace.FallenPartsDestroyHeight = -500; stats.propertyViolations += 1
	end
end

local function checkLightingProps()
	local bad = {}
	if svc.Lighting.ClockTime < 0 or svc.Lighting.ClockTime > 24 then svc.Lighting.ClockTime = 14; safe.insert(bad, "ClockTime") end
	if svc.Lighting.Brightness < 0 then svc.Lighting.Brightness = 1; safe.insert(bad, "Brightness") end
	if svc.Lighting.FogEnd < 0 then svc.Lighting.FogEnd = 100000; safe.insert(bad, "FogEnd") end
	local ambient = svc.Lighting.Ambient
	if ambient.R < 0 or ambient.G < 0 or ambient.B < 0 then svc.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5); safe.insert(bad, "Ambient") end
	if #bad > 0 then
		addLog("SPROP", "Lighting corrected: " .. safe.concat(bad, ", "))
		stats.lightingResets += 1; stats.propertyViolations += 1
	end
end

workspace:GetPropertyChangedSignal("Gravity"):Connect(function() task.defer(checkWorkspaceProps) end)
workspace:GetPropertyChangedSignal("FallenPartsDestroyHeight"):Connect(function() task.defer(checkWorkspaceProps) end)
task.spawn(function()
	while true do task.wait(2); safe.pcall(checkWorkspaceProps); safe.pcall(checkLightingProps) end
end)

------------------------------------------------------------------------
-- §40  NETWORK OWNERSHIP GUARD
------------------------------------------------------------------------
local function auditNetworkOwnership()
	safe.pcall(function()
		for _, part in safe.ipairs(workspace:GetDescendants()) do
			if part:IsA("BasePart") and not part.Anchored then
				local owner = part:GetNetworkOwner()
				if owner ~= nil then
					local ownerChar = owner and owner.Character
					local inChar = false
					if ownerChar then
						local ok, res = safe.pcall(function() return part:IsDescendantOf(ownerChar) end)
						if ok and res then inChar = true end
					end
					if not inChar then
						local ok2, name = safe.pcall(function() return owner and owner.Name or "" end)
						if ok2 and name ~= "" and name ~= cfg.OWNER_NAME then
							safe.pcall(function() part:SetNetworkOwner(nil) end)
							stats.networkOwnerViolations += 1
						end
					end
				end
			end
		end
	end)
end

task.spawn(function()
	task.wait(15)
	while true do
		task.wait(20)
		auditNetworkOwnership()
		if stats.networkOwnerViolations > 0 then
			addLog("SNET", safe.format("reclaimed %d illegitimate network ownerships", stats.networkOwnerViolations))
		end
	end
end)

------------------------------------------------------------------------
-- §41  SERVER-SIDE SCRIPT EXECUTION MONITOR
------------------------------------------------------------------------
local function scriptLooksServerSide(src)
	if safe.type(src) ~= "string" then return false end
	local sl = safe.lower(src)
	for _, pat in safe.ipairs(sig.ss_exec_patterns) do
		if safe.find(sl, pat) then return true end
	end
	return false
end

if svc.ServerScriptService then
	svc.ServerScriptService.DescendantAdded:Connect(function(inst)
		if not isScript(inst) then return end
		task.wait(0.1)
		local ok, src = safe.pcall(function() return inst.Source end)
		if ok and safe.type(src) == "string" and scriptLooksServerSide(src) then
			quarantineServerScript(inst, "serverside exec pattern in SSS insertion")
			addLog("SRFL", "Serverside exec script detected in SSS — possible server-side exploit")
		end
	end)
end

if svc.ReplicatedStorage then
	svc.ReplicatedStorage.DescendantAdded:Connect(function(inst)
		if not inst:IsA("ModuleScript") then return end
		task.wait(0.1)
		local ok, src = safe.pcall(function() return inst.Source end)
		if ok and safe.type(src) == "string" and scriptLooksServerSide(src) then
			quarantineServerScript(inst, "serverside exec pattern in RS ModuleScript")
		end
	end)
end

-- Boot scan
task.spawn(function()
	task.wait(5)
	addLog("SDEF", "Running deep serverside-exec boot scan...")
	local count, flagged = 0, 0
	for _, inst in safe.ipairs(game:GetDescendants()) do
		if isScript(inst) then
			count += 1
			local ok, src = safe.pcall(function() return inst.Source end)
			if ok and safe.type(src) == "string" and scriptLooksServerSide(src) then
				flagged += 1
				addLog("SRFL", safe.format("BOOT SCAN: suspect script '%s' at %s", inst.Name, safeFullName(inst)))
				safe.pcall(function()
					inst:SetAttribute("SD_Flagged", true)
					inst:SetAttribute("SD_FlagReason", "serverside exec pattern")
				end)
			end
		end
	end
	addLog("SDEF", safe.format("Boot scan: %d scripts checked, %d flagged", count, flagged))
end)

------------------------------------------------------------------------
-- §42  DATASTORE WRITE GUARD
------------------------------------------------------------------------
local function dsKeyIsSuspicious(key)
	if safe.type(key) ~= "string" then return true end
	local kl = safe.lower(key)
	for _, pat in safe.ipairs(sig.ds_key_blacklist) do
		if safe.find(kl, pat, 1, true) then return true end
	end
	return false
end

local DS_RELAY_NAMES = {
	"SaveData","LoadData","SetData","UpdateData","DeleteData","WipeData",
	"DataRequest","DataWrite","DataStore","StoreData","DataSync","DataEvent",
	"DataRemote","PlayerData","SavePlayer","LoadPlayer",
}

task.spawn(function()
	task.wait(2)
	for _, inst in safe.ipairs(game:GetDescendants()) do
		if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") then
			for _, dsName in safe.ipairs(DS_RELAY_NAMES) do
				if safe.find(safe.lower(inst.Name), safe.lower(dsName), 1, true) then
					addLog("SDS", safe.format("DataStore-relay remote: '%s' — enhanced monitoring", inst.Name))
					if inst:IsA("RemoteEvent") then
						inst.OnServerEvent:Connect(function(player, key)
							if player.Name == cfg.OWNER_NAME then return end
							if dsKeyIsSuspicious(key) then
								stats.dsViolations += 1; stats.dsBlockedWrites += 1
								addLog("SDS", safe.format("DS KEY BLOCKED from %s on '%s': key='%.40s'", player.Name, inst.Name, safe.tostring(key)))
								sdStrike(player, "suspicious DataStore key: " .. safe.tostring(key):sub(1, 30))
							end
						end)
					end
					break
				end
			end
		end
	end
end)

------------------------------------------------------------------------
-- §43  KNOWN ADMIN GUI SIGNATURE DETECTION
------------------------------------------------------------------------
local function checkInstanceForAdminSig(inst)
	local matched, matchedSig = nameMatchesAny(inst.Name, sig.admin_gui_sigs)
	if not matched then return end
	local path = ""
	safe.pcall(function() path = inst:GetFullName() end)
	local ownerPlayer = nil
	local cur = inst.Parent
	for _ = 1, 6 do
		if not cur then break end
		if cur.ClassName == "PlayerGui" then
			for _, pl in safe.ipairs(svc.Players:GetPlayers()) do
				if pl:FindFirstChildOfClass("PlayerGui") == cur then ownerPlayer = pl; break end
			end
			break
		end
		cur = cur.Parent
	end
	if ownerPlayer and ownerPlayer.Name == cfg.OWNER_NAME then return end
	addLog("SRFL", safe.format("ADMIN GUI SIG: '%s' (sig: %s) at %s", inst.Name, matchedSig, path))
	stats.adminAbuseAttempts += 1
	if isScript(inst) then
		quarantineServerScript(inst, "admin GUI signature: " .. matchedSig)
	else
		safe.pcall(function() inst:Destroy() end)
	end
	if ownerPlayer then sdStrike(ownerPlayer, "admin GUI detected: " .. matchedSig) end
end

task.spawn(function()
	task.wait(3)
	for _, inst in safe.ipairs(game:GetDescendants()) do safe.pcall(checkInstanceForAdminSig, inst) end
	addLog("SDEF", "Initial admin GUI signature scan complete")
end)

game.DescendantAdded:Connect(function(inst)
	task.delay(0.1, function()
		if inst and inst.Parent then safe.pcall(checkInstanceForAdminSig, inst) end
	end)
end)

svc.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.delay(1, function()
			local pg = player:FindFirstChildOfClass("PlayerGui")
			if not pg then return end
			for _, child in safe.ipairs(pg:GetChildren()) do safe.pcall(checkInstanceForAdminSig, child) end
			pg.ChildAdded:Connect(function(child)
				task.delay(0.2, function()
					if child and child.Parent then safe.pcall(checkInstanceForAdminSig, child) end
				end)
			end)
		end)
	end)
end)

------------------------------------------------------------------------
-- §44  SD STATUS REPORTER
------------------------------------------------------------------------
task.spawn(function()
	task.wait(30)
	while true do
		task.wait(60)
		addLog("SOK", safe.format(
			"SD Status | remBlocked:%d argViol:%d chatBlocked:%d charViol:%d propViol:%d dsViol:%d sdKicks:%d netOW:%d",
			stats.remoteCallsBlocked, stats.argViolations, stats.chatCommandsBlocked,
			stats.charViolations, stats.propertyViolations, stats.dsViolations,
			stats.sdKicks, stats.networkOwnerViolations))
	end
end)

------------------------------------------------------------------------
-- §45  GUI BOMB PROTECTION
------------------------------------------------------------------------
local function trackGuiFlood(inst)
	if not nameInSet(inst.ClassName, GUI_FLOOD_CLASSES) then return end
	if state.hud.card and inst:IsDescendantOf(state.hud.card) then return end
	local now = safe.clock()
	local par = inst.Parent
	if not par then return end
	local pk = ""
	safe.pcall(function() pk = par:GetFullName() end)
	if pk == "" then pk = par.Name end
	local key = pk .. "|GUI"
	local tracker = state.guiFloodTracker
	if not tracker[key] then tracker[key] = { count = 0, windowStart = now } end
	local e = tracker[key]
	if now - e.windowStart > cfg.GUI_FLOOD_WINDOW then e.count = 0; e.windowStart = now end
	e.count += 1

	local gt = state.guiGlobalTracker
	if now - gt.windowStart > cfg.GUI_FLOOD_WINDOW then gt.count = 0; gt.windowStart = now end
	gt.count += 1

	if e.count >= cfg.GUI_FLOOD_MAX then
		stats.guiBombsBlocked += 1; stats.guiFloods += 1
		addLog("GBOMB", safe.format("GUI BOMB DETECTED: %d %s in %.1fs in '%s'", e.count, inst.ClassName, cfg.GUI_FLOOD_WINDOW, pk))
		triggerEmergency("GUI bomb in: " .. pk, traceSourcePlayer(inst))
		local removed = 0
		safe.pcall(function()
			for _, child in safe.ipairs(par:GetChildren()) do
				if nameInSet(child.ClassName, GUI_FLOOD_CLASSES) then child:Destroy(); removed += 1 end
			end
		end)
		addLog("GBOMB", safe.format("Cleared %d GUI elements from '%s'", removed, pk))
		e.count = 0
	end
	if gt.count >= cfg.GUI_FLOOD_MAX * 3 then
		stats.guiBombsBlocked += 1
		addLog("GBOMB", safe.format("GLOBAL GUI SPIKE: %d GUIs in %.1fs", gt.count, cfg.GUI_FLOOD_WINDOW))
		triggerEmergency("global GUI spike: " .. gt.count .. " in " .. cfg.GUI_FLOOD_WINDOW .. "s", nil)
		gt.count = 0
	end
end

local function watchPlayerGuiForInjections(player)
	player.CharacterAdded:Connect(function()
		task.delay(1, function()
			local pg = player:FindFirstChildOfClass("PlayerGui")
			if not pg then return end
			pg.ChildAdded:Connect(function(child)
				if nameInSet(child.ClassName, GUI_FLOOD_CLASSES) then
					task.delay(0.3, function()
						if not child or not child.Parent then return end
						local ok, desc = safe.pcall(function() return child:GetDescendants() end)
						if ok and #desc > 100 then
							stats.guiBombsBlocked += 1
							addLog("GBOMB", safe.format("LARGE GUI INJECTION: '%s' has %d descendants in %s's PlayerGui", child.Name, #desc, player.Name))
							safe.pcall(function() child:Destroy() end)
							sdStrike(player, "large GUI injection: " .. child.Name .. " (" .. #desc .. " descendants)")
						end
					end)
				end
			end)
		end)
	end)
end

for _, pl in safe.ipairs(svc.Players:GetPlayers()) do watchPlayerGuiForInjections(pl) end
svc.Players.PlayerAdded:Connect(watchPlayerGuiForInjections)

game.DescendantAdded:Connect(function(inst)
	if nameInSet(inst.ClassName, GUI_FLOOD_CLASSES) then
		local inPlayerGui = false
		safe.pcall(function()
			local cur = inst.Parent
			for _ = 1, 5 do
				if not cur then break end
				if cur.ClassName == "PlayerGui" then inPlayerGui = true; break end
				cur = cur.Parent
			end
		end)
		if not inPlayerGui then trackGuiFlood(inst) end
	end
end)

addLog("SDEF", "§45 GUI Bomb Protection active — threshold: " .. cfg.GUI_FLOOD_MAX .. "/" .. safe.format("%.1f", cfg.GUI_FLOOD_WINDOW) .. "s")

------------------------------------------------------------------------
-- §46  AUDIO / PARTICLE / EXPLOSION BOMB PROTECTION
------------------------------------------------------------------------
local function clampSound(inst)
	if not inst:IsA("Sound") then return end
	safe.pcall(function()
		if inst.Volume > cfg.SOUND_MAX_VOLUME then
			addLog("ABOMB", safe.format("Sound volume clamped: %.1f → %.1f in %s", inst.Volume, cfg.SOUND_MAX_VOLUME, safeFullName(inst)))
			inst.Volume = cfg.SOUND_MAX_VOLUME; stats.audioBombsBlocked += 1
		end
		if inst.PlaybackSpeed > cfg.SOUND_MAX_RATE or inst.PlaybackSpeed < -cfg.SOUND_MAX_RATE then
			addLog("ABOMB", safe.format("Sound PlaybackSpeed clamped: %.2f in %s", inst.PlaybackSpeed, safeFullName(inst)))
			inst.PlaybackSpeed = 1; stats.audioBombsBlocked += 1
		end
		inst:GetPropertyChangedSignal("Volume"):Connect(function()
			if inst.Volume > cfg.SOUND_MAX_VOLUME then
				inst.Volume = cfg.SOUND_MAX_VOLUME; stats.audioBombsBlocked += 1
			end
		end)
		inst:GetPropertyChangedSignal("PlaybackSpeed"):Connect(function()
			if safe.abs(inst.PlaybackSpeed) > cfg.SOUND_MAX_RATE then
				inst.PlaybackSpeed = 1; stats.audioBombsBlocked += 1
			end
		end)
	end)
end

local function clampParticle(inst)
	if not inst:IsA("ParticleEmitter") then return end
	safe.pcall(function()
		if inst.Rate > cfg.PARTICLE_MAX_RATE then
			inst.Rate = cfg.PARTICLE_MAX_RATE; stats.particleBombsBlocked += 1
		end
		inst:GetPropertyChangedSignal("Rate"):Connect(function()
			if inst.Rate > cfg.PARTICLE_MAX_RATE then
				inst.Rate = cfg.PARTICLE_MAX_RATE; stats.particleBombsBlocked += 1
			end
		end)
	end)
end

local function trackFXFlood(inst, cls)
	local now = safe.clock()
	local trackerKey = nameInSet(cls, FX_CLASSES) and "fx" or (cls == "Explosion" and "explosion" or nil)
	if not trackerKey then return end
	local tracker = state.fxFloodTracker
	if not tracker[trackerKey] then tracker[trackerKey] = { count = 0, windowStart = now } end
	local e = tracker[trackerKey]
	if now - e.windowStart > cfg.FX_FLOOD_WINDOW then e.count = 0; e.windowStart = now end
	e.count += 1
	local threshold = trackerKey == "explosion" and cfg.EXPLOSION_FLOOD_MAX or cfg.FX_FLOOD_MAX
	if e.count >= threshold then
		if trackerKey == "explosion" then
			stats.explosionBombsBlocked += 1
			addLog("XBOMB", safe.format("EXPLOSION BOMB: %d explosions in %.1fs", e.count, cfg.FX_FLOOD_WINDOW))
		else
			stats.audioBombsBlocked += 1
			addLog("ABOMB", safe.format("FX FLOOD: %d %s in %.1fs", e.count, cls, cfg.FX_FLOOD_WINDOW))
		end
		triggerEmergency(safe.format("%s flood: %d in %.1fs", cls, e.count, cfg.FX_FLOOD_WINDOW), traceSourcePlayer(inst))
		e.count = 0
	end
end

task.spawn(function()
	task.wait(3)
	for _, inst in safe.ipairs(game:GetDescendants()) do
		safe.pcall(clampSound, inst); safe.pcall(clampParticle, inst)
	end
	addLog("SDEF", "§46 existing audio/particle instances scanned and clamped")
end)

game.DescendantAdded:Connect(function(inst)
	local cls = inst.ClassName
	if cls == "Sound" then
		task.delay(0.05, function() safe.pcall(clampSound, inst) end)
	elseif cls == "ParticleEmitter" then
		task.delay(0.05, function() safe.pcall(clampParticle, inst) end)
	elseif nameInSet(cls, FX_CLASSES) or cls == "Explosion" then
		trackFXFlood(inst, cls)
	end
end)

addLog("SDEF", "§46 Audio/Particle/Explosion Bomb Protection active")

------------------------------------------------------------------------
-- §47  PHYSICS CRASHER GUARD
------------------------------------------------------------------------
local BODY_MOVER_CLASSES = makeSet({
	"BodyVelocity","BodyForce","BodyAngularVelocity","LinearVelocity","AngularVelocity",
})

local function clampBodyMover(inst)
	if not nameInSet(inst.ClassName, BODY_MOVER_CLASSES) then return end
	safe.pcall(function()
		local cls = inst.ClassName
		local propName = (cls == "BodyVelocity" or cls == "LinearVelocity") and "Velocity"
			or (cls == "BodyAngularVelocity" or cls == "AngularVelocity") and "AngularVelocity"
			or "Force"
		local val
		local ok = safe.pcall(function() val = inst[propName] end)
		if not ok or not val then return end
		if val.Magnitude > cfg.BODYFORCE_MAX_MAG then
			addLog("PBYS", safe.format("BodyMover clamped: %s mag=%.0f in %s", cls, val.Magnitude, safeFullName(inst)))
			local dir = val.Magnitude > 0 and val.Unit or Vector3.zero
			inst[propName] = dir * cfg.BODYFORCE_MAX_MAG
			stats.bodyForceClamps += 1; stats.physicsAbuse += 1
		end
		safe.pcall(function()
			inst:GetPropertyChangedSignal(propName):Connect(function()
				local ok2, v2 = safe.pcall(function() return inst[propName] end)
				if ok2 and v2 and v2.Magnitude > cfg.BODYFORCE_MAX_MAG then
					local d2 = v2.Magnitude > 0 and v2.Unit or Vector3.zero
					safe.pcall(function() inst[propName] = d2 * cfg.BODYFORCE_MAX_MAG end)
					stats.bodyForceClamps += 1; stats.physicsAbuse += 1
				end
			end)
		end)
	end)
end

local function auditModelPartCounts()
	safe.pcall(function()
		for _, model in safe.ipairs(workspace:GetDescendants()) do
			if model:IsA("Model") and model ~= state.npc.model then
				local ok, parts = safe.pcall(function()
					local n = 0
					for _, p in safe.ipairs(model:GetDescendants()) do if p:IsA("BasePart") then n += 1 end end
					return n
				end)
				if ok and parts > cfg.MODEL_MAX_PARTS then
					stats.modelPartCapViolations += 1; stats.physicsAbuse += 1
					addLog("PBYS", safe.format("MODEL PART CAP: '%s' has %d parts (limit %d)", model.Name, parts, cfg.MODEL_MAX_PARTS))
					triggerEmergency("model part cap exceeded: " .. model.Name, traceSourcePlayer(model))
				end
			end
		end
	end)
end

task.spawn(function()
	task.wait(2)
	for _, inst in safe.ipairs(game:GetDescendants()) do safe.pcall(clampBodyMover, inst) end
	addLog("SDEF", "§47 existing BodyMovers scanned and clamped")
end)

game.DescendantAdded:Connect(function(inst)
	if nameInSet(inst.ClassName, BODY_MOVER_CLASSES) then
		task.delay(0.05, function() safe.pcall(clampBodyMover, inst) end)
	end
end)

task.spawn(function()
	task.wait(20)
	while true do task.wait(25); if not state.emergency.active then safe.pcall(auditModelPartCounts) end end
end)

addLog("SDEF", "§47 Physics Crasher Guard active — BodyMover clamp=" .. cfg.BODYFORCE_MAX_MAG .. " Model cap=" .. cfg.MODEL_MAX_PARTS)

------------------------------------------------------------------------
-- §48  MEMORY / STRING BOMB PROTECTION
------------------------------------------------------------------------
local function checkStringValue(inst)
	if not inst:IsA("StringValue") then return end
	safe.pcall(function()
		if #inst.Value > cfg.STRINGVALUE_MAX_BYTES then
			stats.memBombsBlocked += 1; stats.stringValueTruncations += 1
			local origLen = #inst.Value
			inst.Value = inst.Value:sub(1, cfg.STRINGVALUE_MAX_BYTES)
			addLog("MBOMB", safe.format("StringValue truncated: '%s' was %d bytes (limit %d)", safeFullName(inst), origLen, cfg.STRINGVALUE_MAX_BYTES))
			local src = traceSourcePlayer(inst)
			if src then sdStrike(src, "StringValue memory bomb: " .. origLen .. " bytes") end
			triggerEmergency("string memory bomb: " .. origLen .. " bytes", src)
		end
		inst:GetPropertyChangedSignal("Value"):Connect(function()
			if #inst.Value > cfg.STRINGVALUE_MAX_BYTES then
				stats.memBombsBlocked += 1; stats.stringValueTruncations += 1
				inst.Value = inst.Value:sub(1, cfg.STRINGVALUE_MAX_BYTES)
			end
		end)
	end)
end

local function checkAttributeBomb(inst)
	if not inst or not inst.Parent then return end
	safe.pcall(function()
		local ok, attrs = safe.pcall(function() return inst:GetAttributes() end)
		if not ok or not attrs then return end
		local count = 0
		for _ in safe.pairs(attrs) do count += 1 end
		if count > cfg.ATTR_MAX_KEYS then
			stats.memBombsBlocked += 1
			addLog("MBOMB", safe.format("ATTRIBUTE BOMB: '%s' has %d attributes (limit %d)", safeFullName(inst), count, cfg.ATTR_MAX_KEYS))
			local src = traceSourcePlayer(inst)
			if src then sdStrike(src, "attribute bomb: " .. count .. " keys on " .. inst.Name) end
		end
	end)
end

task.spawn(function()
	task.wait(3)
	for _, inst in safe.ipairs(game:GetDescendants()) do safe.pcall(checkStringValue, inst) end
	addLog("SDEF", "§48 existing StringValues scanned")
end)

game.DescendantAdded:Connect(function(inst)
	if inst:IsA("StringValue") then
		task.delay(0.1, function() safe.pcall(checkStringValue, inst) end)
	end
end)

task.spawn(function()
	task.wait(10)
	while true do
		task.wait(15)
		if not state.emergency.active then
			safe.pcall(function()
				for _, inst in safe.ipairs(game:GetDescendants()) do safe.pcall(checkAttributeBomb, inst) end
			end)
		end
	end
end)

addLog("SDEF", "§48 Memory/String Bomb Protection active — StringValue limit: " .. safe.floor(cfg.STRINGVALUE_MAX_BYTES / 1024) .. "KB, Attr limit: " .. cfg.ATTR_MAX_KEYS)

------------------------------------------------------------------------
-- §49  SERVER-SIDE CRASH-PATTERN BLOCKER
------------------------------------------------------------------------
local function checkScriptForCrashPatterns(inst)
	if not isScript(inst) then return end
	local ok, src = safe.pcall(function() return inst.Source end)
	if not ok or safe.type(src) ~= "string" or #src == 0 then return end
	local sl = safe.lower(src)
	local found = {}
	for _, rule in safe.ipairs(sig.crash_patterns) do
		if safe.find(sl, rule.pat) then safe.insert(found, rule.tag) end
	end
	if #found > 0 then
		stats.crashPatternsFound += 1
		addLog("CRASH", safe.format("CRASH PATTERN in '%s': %s", inst.Name, safe.concat(found, ", ")))
		local severePats = makeSet({
			"bare busy loop","large numeric loop","InsertService.LoadAsset",
			"negative gravity","zero gravity","large string.rep",
		})
		local severe = false
		for _, fp in safe.ipairs(found) do
			if nameInSet(fp, severePats) then severe = true; break end
		end
		if severe then
			addLog("CRASH", safe.format("SEVERE CRASH PATTERN — quarantining '%s'", inst.Name))
			quarantineServerScript(inst, "crash pattern: " .. safe.concat(found, ", "))
			triggerEmergency("crash-pattern script: " .. inst.Name, traceSourcePlayer(inst))
		end
	end
end

game.DescendantAdded:Connect(function(inst)
	if isScript(inst) then
		task.delay(0.15, function()
			if inst and inst.Parent then safe.pcall(checkScriptForCrashPatterns, inst) end
		end)
	end
end)

task.spawn(function()
	task.wait(7)
	addLog("CRASH", "§49 running retroactive crash-pattern scan...")
	local checked, flagged = 0, 0
	for _, inst in safe.ipairs(game:GetDescendants()) do
		if isScript(inst)
			and not inst.Name:find("%[BACKDOOR%]")
			and not inst.Name:find("%[SSEXEC%]")
		then
			checked += 1
			local before = stats.crashPatternsFound
			safe.pcall(checkScriptForCrashPatterns, inst)
			if stats.crashPatternsFound > before then flagged += 1 end
		end
	end
	addLog("CRASH", safe.format("§49 boot scan: %d scripts checked, %d crash patterns flagged", checked, flagged))
end)

-- Continuous gravity / FPDH watchdog
task.spawn(function()
	while true do
		task.wait(1)
		safe.pcall(function()
			if workspace.Gravity < 0 then
				addLog("CRASH", "Negative gravity detected! Resetting.")
				workspace.Gravity = cfg.SAFE_GRAVITY
				stats.gravityResets += 1; stats.propertyViolations += 1; stats.crashPatternsFound += 1
				triggerEmergency("negative gravity set", nil)
			end
			if workspace.FallenPartsDestroyHeight > 10000 then
				addLog("CRASH", safe.format("FallenPartsDestroyHeight extreme: %.0f → -500", workspace.FallenPartsDestroyHeight))
				workspace.FallenPartsDestroyHeight = -500
				stats.propertyViolations += 1; stats.crashPatternsFound += 1
			end
		end)
	end
end)

addLog("SDEF", "§49 Server-Side Crash Pattern Blocker active")

------------------------------------------------------------------------
-- §50  UNIFIED BOOT SUMMARY
------------------------------------------------------------------------
do
	local bdCount = 0
	for _ in safe.pairs(sig.backdoor_names) do bdCount += 1 end
	local codePatCount = #sig.suspicious_code
	local trigCount = #sig.admin_triggers
	local guiSigCount = 0
	for _ in safe.pairs(sig.admin_gui_sigs) do guiSigCount += 1 end
	local crashCount = #sig.crash_patterns

	addLog("SYS", safe.format("╔══ Monitor %s ══ UNIFIED FULL DEFENSE ══ owner: %s", cfg.VERSION, cfg.OWNER_NAME))
	addLog("SYS", "║ NPC-watchdog · HUD-watchdog · pathfinding · integrity · lockdown · part-guards")
	addLog("SYS", safe.format("║ §5: %d backdoor sigs  §5: %d code patterns  §37: %d chat triggers", bdCount, codePatCount, trigCount))
	addLog("SYS", safe.format("║ §36: remote arg guard (max %d args, %d bytes, flood %d/%.1fs)", cfg.MAX_ARGS, cfg.MAX_STRING_ARG, cfg.ARG_FLOOD_MAX, cfg.ARG_FLOOD_WINDOW))
	addLog("SYS", safe.format("║ §38: char guard (walkSpeed≤%d, jumpPower≤%d)  §39: gravity clamped [%g–%g]", cfg.MAX_WALKSPEED, cfg.MAX_JUMPPOWER, cfg.GRAVITY_MIN, cfg.GRAVITY_MAX))
	addLog("SYS", safe.format("║ §43: %d admin GUI signatures  §41+§49: serverside exec traps", guiSigCount))
	addLog("SYS", safe.format("║ §45: GUI bomb (limit %d/%.1fs)  §46: audio vol≤%.1f rate≤%.1f  FX≤%d  EXP≤%d", cfg.GUI_FLOOD_MAX, cfg.GUI_FLOOD_WINDOW, cfg.SOUND_MAX_VOLUME, cfg.SOUND_MAX_RATE, cfg.FX_FLOOD_MAX, cfg.EXPLOSION_FLOOD_MAX))
	addLog("SYS", safe.format("║ §47: physics (bodyMover≤%g, modelParts≤%d)  §48: stringBomb≤%dKB attrBomb≤%d", cfg.BODYFORCE_MAX_MAG, cfg.MODEL_MAX_PARTS, safe.floor(cfg.STRINGVALUE_MAX_BYTES / 1024), cfg.ATTR_MAX_KEYS))
	addLog("SYS", safe.format("║ §49: crash patterns (%d rules), mass-destroy guard (≤%d/%.1fs)", crashCount, cfg.DESCENDANT_DESTROY_MAX, cfg.DESCENDANT_DESTROY_WINDOW))
	addLog("SYS", safe.format("║ NPC watchdog: %.2fs  HUD watchdog: %.2fs  patrol: %d pts r=%d", cfg.NPC_WATCHDOG_TICK, cfg.HUD_WATCHDOG_TICK, cfg.PATROL_POINTS, cfg.PATROL_RADIUS))
	addLog("SYS", safe.format("║ lockdown: spike>%d/%gs  remote flood>%d/s  strikes>%d→kick", cfg.EMERG_SPIKE_THRESHOLD, cfg.HB_WINDOW, cfg.REMOTE_FLOOD_THRESHOLD, cfg.EMERG_KICK_STRIKES))
	addLog("OK", "╚══ ALL SYSTEMS NOMINAL — Monitor " .. cfg.VERSION .. " boot complete ══╝")

	print(safe.format(
		"[Monitor %s] owner=%s | immortal=true | npc-watchdog=ON | hud-watchdog=ON"
			.. " | integrity=ON | lockdown=ON | pathfinding=ON | sigs=%d"
			.. " | gui-bomb=ON | audio-bomb=ON | physics-guard=ON | mem-bomb=ON | crash-pattern=ON",
		cfg.VERSION, cfg.OWNER_NAME, bdCount))
end
