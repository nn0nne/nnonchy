return { 'nvim-mini/mini.fuzzy', version = '*',

    config = function()
        require("mini.fuzzy").setup(
            -- No need to copy this inside `setup()`. Will be used automatically.
{
  -- Maximum allowed value of match features (width and first match). All
  -- feature values greater than cutoff can be considered "equally bad".
  cutoff = 100,
}
        )
    end
}
