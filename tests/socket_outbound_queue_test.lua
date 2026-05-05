local function load_outbound_queue_api()
	local f = assert(io.open("networking/socket.lua", "r"))
	local src = f:read("*a")
	f:close()

	local thread_start = assert(src:find("return %[%["))
	local thread_end = assert(src:find("%]%]%s*$"))
	local thread_code = src:sub(thread_start + #"return [[", thread_end - 1)

	local start_idx = assert(thread_code:find("Networking = %{%}"))
	local end_idx = assert(thread_code:find("\n%-%- Reconnection settings", start_idx))
	local snippet = thread_code:sub(start_idx, end_idx - 1)

	local env = {
		string = string,
		table = table,
		tostring = tostring,
		SEND_THREAD_DEBUG_MESSAGE = function()
		end,
		love = {
			thread = {
				getChannel = function()
					return {}
				end,
			},
		},
	}

	local chunk = assert(load(
		snippet
			.. [[
return {
	queueOutboundMessage = queueOutboundMessage,
	flushOutboundQueue = flushOutboundQueue,
	setClient = function(client)
		Networking.Client = client
		isSocketClosed = false
	end,
	setSocketClosed = function(closed)
		isSocketClosed = closed
	end,
	getState = function()
		return {
			queueSize = #outboundQueue,
			offset = outboundOffset,
		}
	end,
}
]],
		"socket_outbound_queue_snippet",
		"t",
		env
	))

	return chunk()
end

describe("socket outbound queue", function()
	it("retries and completes a message after partial timeout write", function()
		local api = load_outbound_queue_api()

		local send_calls = 0
		local fake_client = {
			send = function(_, data)
				send_calls = send_calls + 1
				if send_calls == 1 then
					assert(data == "HELLO\\n")
					return nil, "timeout", 3
				end
				assert(data == "LO\\n")
				return #data
			end,
		}

		api.setClient(fake_client)
		api.queueOutboundMessage("HELLO\\n")

		api.flushOutboundQueue(25)
		local mid = api.getState()
		assert(mid.queueSize == 1)
		assert(mid.offset == 4)

		api.flushOutboundQueue(25)
		local done = api.getState()
		assert(done.queueSize == 0)
		assert(done.offset == 1)
	end)

	it("drains multiple queued messages in order", function()
		local api = load_outbound_queue_api()

		local sent_payloads = {}
		local fake_client = {
			send = function(_, data)
				table.insert(sent_payloads, data)
				return #data
			end,
		}

		api.setClient(fake_client)
		api.queueOutboundMessage("one\\n")
		api.queueOutboundMessage("two\\n")

		api.flushOutboundQueue(25)

		local state = api.getState()
		assert(state.queueSize == 0)
		assert(state.offset == 1)
		assert(#sent_payloads == 2)
		assert(sent_payloads[1] == "one\\n")
		assert(sent_payloads[2] == "two\\n")
	end)
end)
