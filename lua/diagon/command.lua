local Log = require 'diagon.log'
local Core = require 'diagon.core'

local M = {}

M.state = {}

local function on_success(output)
    vim.schedule(function()
        local current_line = M.state.start_line - 1
        local end_line = M.state.end_line

        if M.opts.pos == 'below' then
            end_line = current_line
        elseif M.opts.pos == 'above' then
            current_line = current_line - 1
            end_line = current_line
        end

        if M.state.comment_str ~= "" then
            for i, line in ipairs(output) do
                output[i] = M.state.comment_str .. line
            end
        end

        vim.api.nvim_buf_set_lines(0, current_line, end_line, true, output)
    end)
end

local function diagon_user_command(params)
    local translator = params.args

    if not vim.tbl_contains(M.opts.translators, translator) then
        Log.print_error('Translator not found')
        return
    end

    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    M.state.start_line = start_pos[2]
    M.state.end_line = end_pos[2]

    local min_col = math.min(start_pos[3], end_pos[3])
    local lines = vim.fn.getline(start_pos[2], end_pos[2])

    -- Assuming that if the selection didn't begin in the col 1, the previous
    -- cols would contain a comment pattern
    -- TODO: Maybe do this with treesitter if found necessary
    M.state.comment_str = ""
    if min_col > 1 then
        M.state.comment_str = string.sub(lines[1], 0, min_col - 1)
    end

    for i, line in ipairs(lines) do
        lines[i] = string.sub(line, min_col)
    end

    local input = table.concat(lines, '\n')

    Core.diagon {
        translator = translator,
        input = input,
        on_success = on_success,
        on_error = Log.print_error,
    }
end

local function complete(translators)
    return function(partial)
        local starts_with_partial = function(key)
            return key:sub(1, #partial) == partial
        end
        return vim.tbl_filter(starts_with_partial, translators)
    end
end

function M.setup(opts)
    M.opts = opts
    vim.api.nvim_create_user_command('Diagon', diagon_user_command, {
        complete = complete(opts.translators),
        range = 0,
        nargs = 1,
    })
end

return M
