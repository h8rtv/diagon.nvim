local M = {}

-- TODO: Define options and defaults
local defaults = {
    pos = 'substitute', -- 'above' | 'below' | 'substitute'
    translators = {
        'Math',
        'Sequence',
        'Tree',
        'Table',
        'Grammar',
        'Frame',
        'GraphDAG',
        'GraphPlanar',
        'Flowchart',
    },
}

function M.setup(opts)
    opts = opts or {}
    local options = vim.tbl_deep_extend('force', defaults, opts)
    require('diagon.command').setup(options)

end

return M
