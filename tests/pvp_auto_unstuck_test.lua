-- Tests for the auto-unstuck logic in Game:update that detects when a player
-- is stranded outside the PvP blind while their opponent is already inside.

local function load_game_update(env)
	local f = assert(io.open("networking/action_handlers.lua", "r"))
	local src = f:read("*a")
	f:close()

	local start_idx = assert(src:find("function Game:update%(dt%)"))
	local end_idx = assert(src:find("\nlocal function action_enemyDisconnected", start_idx))
	local snippet = src:sub(start_idx, end_idx - 1)

	local chunk = assert(load(snippet, "game_update_snippet", "t", env))
	chunk()
	-- Game:update is now defined on env.Game
end

--- Build a default environment with all mocks in a valid "stuck" state:
--- in a lobby, has next_blind_context, not in PvP blind yet, enemy is playing.
local function make_env()
	local env = {
		string = string,
		math = math,
		Game = {},
		MP = {
			LOBBY = { code = "ABCD" },
			GAME = {
				next_blind_context = { blind = "bl_mp_nemesis" },
				pvp_unstuck_attempted = false,
				pvp_blind_started = false,
				enemy = { location = "playing_blind" },
			},
			is_pvp_boss = function() return false end,
			enemy_disconnect_countdown = nil,
			self_reconnect_countdown = nil,
		},
		G = {
			FUNCS = {},
		},
		love = {
			timer = { getTime = function() return 100 end },
		},
		sendDebugMessage = function() end,
		handle_reconnect_timeout = function() end,
		_disconnect_gupdate = function() return true end,
	}
	return env
end

describe("pvp auto-unstuck (Game:update)", function()

	it("calls mp_unstuck_blind when stuck outside PvP blind", function()
		local env = make_env()
		local unstuck_called = 0
		env.G.FUNCS.mp_unstuck_blind = function() unstuck_called = unstuck_called + 1 end

		load_game_update(env)
		env.Game.update(env.Game, 0)

		assert(unstuck_called == 1, "mp_unstuck_blind should have been called once")
		assert(env.MP.GAME.pvp_unstuck_attempted == true, "pvp_unstuck_attempted should be set")
	end)

	it("does not fire a second time after pvp_unstuck_attempted is set", function()
		local env = make_env()
		local unstuck_called = 0
		env.G.FUNCS.mp_unstuck_blind = function() unstuck_called = unstuck_called + 1 end
		env.MP.GAME.pvp_unstuck_attempted = true  -- already tried

		load_game_update(env)
		env.Game.update(env.Game, 0)

		assert(unstuck_called == 0, "mp_unstuck_blind should NOT fire when already attempted")
	end)

	it("does not fire when player is already inside the PvP blind", function()
		local env = make_env()
		local unstuck_called = 0
		env.G.FUNCS.mp_unstuck_blind = function() unstuck_called = unstuck_called + 1 end
		env.MP.is_pvp_boss = function() return true end  -- already inside

		load_game_update(env)
		env.Game.update(env.Game, 0)

		assert(unstuck_called == 0, "mp_unstuck_blind should NOT fire when already in PvP blind")
	end)

	it("does not fire when there is no next_blind_context", function()
		local env = make_env()
		local unstuck_called = 0
		env.G.FUNCS.mp_unstuck_blind = function() unstuck_called = unstuck_called + 1 end
		env.MP.GAME.next_blind_context = nil

		load_game_update(env)
		env.Game.update(env.Game, 0)

		assert(unstuck_called == 0, "mp_unstuck_blind should NOT fire without next_blind_context")
	end)

	it("does not fire when enemy location does not contain 'playing'", function()
		local env = make_env()
		local unstuck_called = 0
		env.G.FUNCS.mp_unstuck_blind = function() unstuck_called = unstuck_called + 1 end
		env.MP.GAME.enemy.location = "loc_selecting"

		load_game_update(env)
		env.Game.update(env.Game, 0)

		assert(unstuck_called == 0, "mp_unstuck_blind should NOT fire when enemy is not playing")
	end)

	it("resets pvp_unstuck_attempted once player enters the PvP blind", function()
		local env = make_env()
		env.MP.GAME.pvp_unstuck_attempted = true
		env.MP.is_pvp_boss = function() return true end  -- now inside the blind

		load_game_update(env)
		env.Game.update(env.Game, 0)

		assert(env.MP.GAME.pvp_unstuck_attempted == false, "pvp_unstuck_attempted should reset after entering PvP blind")
	end)

end)
