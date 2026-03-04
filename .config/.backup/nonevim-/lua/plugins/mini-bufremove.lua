return { 'nvim-mini/mini.bufremove', version = '*',

    config = function()
        require("mini.bufremove").setup(
            -- No need to copy this inside `setup()`. Will be used automatically.
{
  -- Whether to disable showing non-error feedback
  silent = false,
}
        )
    end
}
