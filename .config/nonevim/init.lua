require("nnonne")

-- Add to your LSP config after setup
vim.api.nvim_create_user_command("LspBenchmark", function()
	local stats = vim.lsp.get_clients() -- Use get_clients() instead of get_active_clients()
	for _, client in ipairs(stats) do
		if client.name == "tsgo" or client.name == "vtsls" then
			print(string.format("Server: %s", client.name))
			print(string.format("  PID: %s", client.rpc and client.rpc.pid or "N/A"))
			print(string.format("  Attached buffers: %d", #client.attached_buffers))
			print(string.format("  Capabilities: %s", client.server_capabilities and "loaded" or "not loaded"))
		end
	end
end, {})

-- Fixed startup time monitor
vim.api.nvim_create_autocmd("LspAttach", {
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and (client.name == "tsgo" or client.name == "vtsls") then
			-- Store start time when file is opened
			if not vim.b.lsp_start_time then
				vim.b.lsp_start_time = vim.loop.hrtime() -- High-resolution time
			end

			-- Calculate time difference in milliseconds
			local end_time = vim.loop.hrtime()
			local elapsed_ms = (end_time - vim.b.lsp_start_time) / 1e6 -- Convert nanoseconds to milliseconds

			print(string.format("%s attached in %.2f ms", client.name, elapsed_ms))
		end
	end,
})

-- Optional: Add a more comprehensive benchmark
vim.api.nvim_create_user_command("LspPerfTest", function()
	local results = {}

	-- Test completion speed
	local start = vim.loop.hrtime()
	-- Trigger completion manually or use a test
	vim.cmd("normal! i.") -- This is just an example, adjust as needed
	vim.cmd("normal! <C-space>") -- Trigger completion
	vim.defer_fn(function()
		local elapsed = (vim.loop.hrtime() - start) / 1e6
		table.insert(results, string.format("Completion response: %.2f ms", elapsed))

		-- Print all results
		print(table.concat(results, "\n"))
	end, 100) -- Wait 100ms for completion to trigger
end, {})
