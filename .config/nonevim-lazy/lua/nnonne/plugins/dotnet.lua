return {
	"GustavEikaas/easy-dotnet.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
		"folke/snacks.nvim",
	},
	ft = { "cs", "razor", "cshtml", "fs", "vb" },
	config = function()
		local dotnet = require("easy-dotnet")

		dotnet.setup({
			picker = "snacks",
			lsp = {
				enabled = true,
				set_fold_expr = false,
				preload_roslyn = true,
				roslynator_enabled = true,
				easy_dotnet_analyzer_enabled = true,
				enhanced_rename = false,
				create_type_from_usage = false,
				restart_roslyn_on_branch_change = false,
				auto_refresh_codelens = true,
				suggest_updates = true,
				analyzer_assemblies = {},
				auto_load_projects = false,
				daemon_mode = false,
				razor = {
					enabled = true,
					html = {
						enabled = true,
						cmd = nil,
						request_timeout = 5000,
					},
				},
				config = {},
				log_level = "Information",
			},
			debugger = {
				bin_path = nil,
				engine = "netcoredbg",
				console = "externalTerminal",
				apply_value_converters = true,
				auto_register_dap = true,
				mem_cpu_usage = true,
				mappings = {
					open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
				},
			},
			test_runner = {
				auto_start_testrunner = true,
				hide_legend = false,
				neotest_integration = false,
				viewmode = "float",
				icons = {
					passed = "",
					skipped = "",
					failed = "",
					success = "",
					reload = "",
					test = "",
					sln = "󰘐",
					project = "󰘐",
					dir = "",
					package = "",
					class = "",
					build_failed = "󰒡",
				},
				mappings = {
					run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
					run_all_tests_from_buffer = { lhs = "<leader>t", desc = "run all tests in file" },
					get_build_errors = { lhs = "<leader>e", desc = "get build errors" },
					peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "peek stack trace" },
					debug_test_from_buffer = { lhs = "<leader>d", desc = "debug test from buffer" },
					debug_test = { lhs = "<leader>d", desc = "debug test" },
					go_to_file = { lhs = "<leader>g", desc = "go to file" },
					run_all = { lhs = "<leader>R", desc = "run all tests" },
					run = { lhs = "<leader>r", desc = "run test" },
					peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace" },
					expand = { lhs = "o", desc = "expand" },
					expand_node = { lhs = "E", desc = "expand node" },
					collapse_all = { lhs = "W", desc = "collapse all" },
					close = { lhs = "q", desc = "close testrunner" },
					refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
					cancel = { lhs = "<C-c>", desc = "cancel" },
					next_failure = { lhs = "]f", desc = "next failure" },
					prev_failure = { lhs = "[f", desc = "prev failure" },
				},
			},
			new = { project = { prefix = "sln" } },
			csproj_mappings = true,
			fsproj_mappings = true,
			enable_filetypes = true,
			auto_bootstrap_namespace = {
				type = "file_scoped",
				enabled = true,
				use_clipboard_json = { behavior = "prompt", register = "+" },
			},
			server = { use_visual_studio = false, log_level = nil },
			notifications = {
				handler = function(start_event)
					local spinner = require("easy-dotnet.ui-modules.spinner").new()
					spinner:start_spinner(function()
						return start_event.job.name
					end)
					return function(finished_event)
						spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
					end
				end,
			},
			diagnostics = { default_severity = "error", setqflist = false },
			-- managed_terminal = { auto_hide = true, auto_hide_delay = 1000 },
			managed_terminal = { auto_hide = false },
			-- external_terminal = {
			-- 	command = "foot",
			-- 	args = { "--hold" },
			-- },
		})

		-- Keymaps (handover suggested)
		local map = function(lhs, fn, desc)
			vim.keymap.set("n", lhs, fn, { desc = desc })
		end
		map("<leader>dn", function()
			dotnet.new()
		end, ".NET: New project")
		map("<leader>ds", function()
			dotnet.solution_select()
		end, ".NET: Select solution")
		map("<leader>db", function()
			dotnet.build()
		end, ".NET: Build")
		map("<leader>dr", function()
			dotnet.run()
		end, ".NET: Run")
		map("<leader>dR", function()
			dotnet.run_profile()
		end, ".NET: Run profile")
		map("<leader>dD", function()
			dotnet.debug()
		end, ".NET: Debug")
		map("<leader>dt", function()
			dotnet.test()
		end, ".NET: Tests")
		map("<leader>dw", function()
			dotnet.watch()
		end, ".NET: Watch")
		map("<leader>dm", function()
			dotnet.ef_migrations_add(vim.fn.input("Migration name: "))
		end, ".NET: Add migration")
		map("<leader>dl", function()
			dotnet.ef_migrations_list()
		end, ".NET: List migrations")
		map("<leader>df", function()
			dotnet.ef_database_update()
		end, ".NET: Apply migration")
		map("<leader>dT", function()
			dotnet.terminal_toggle()
		end, ".NET: Terminal toggle")

		-- which-key group
		pcall(function()
			require("which-key").add({
				{ "<leader>d", group = ".NET" },
			})
		end)

		-- Lualine components (optional, if lualine present)
		pcall(function()
			-- leave to user config; expose helpers
		end)
	end,
}
