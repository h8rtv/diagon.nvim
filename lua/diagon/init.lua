local Job = require 'plenary.job'

-- TODO: Improve file structure; create more modules


local M = {}

local translators = {
    'Math',
    'Sequence',
    'Tree',
    'Table',
    'Grammar',
    'Frame',
    'GraphDAG',
    'GraphPlanar',
    'Flowchart',
}

local function print_error(err_msg)
    vim.schedule(function()
        vim.notify(
            "Diagon Error:\n" .. err_msg,
            vim.log.levels.ERROR,
            { title = "diagon.nvim" }
        )
    end)
end

local function index_of(table, element)
    for index, value in ipairs(table) do
        if value == element then
            return index
        end
    end
    return nil
end

local function success(output, comment_str)
    local above = true
    vim.schedule(function()
        local current_line = vim.fn.line('.')
        if above then
            current_line = current_line - 1
        end
        if comment_str ~= "" then
            for i, line in ipairs(output) do
                output[i] = comment_str .. line
            end
        end
        vim.api.nvim_buf_set_lines(0, current_line, current_line, true, output)
    end)
end

local function diagon(translator, input, comment_str)
    if vim.fn.executable('diagon') == 0 then
        print_error('Diagon not found in path')
        return
    end

    if string.len(input) <= 0 then
        print_error('No input given')
        return
    end

    if not index_of(translators, translator) then
        print_error('Translator not found')
        return
    end

    Job:new({
        command = 'diagon',
        args = { translator, '--', input },
        on_exit = function(j)
            if #j:stderr_result() ~= 0 then
                print_error(table.concat(j:stderr_result(), '\n'))
                return
            end
            local output = j:result()
            table.remove(j:result()) -- pop in lua
            success(output, comment_str)
        end,
    }):sync()
end

local function diagon_user_command(params)
    local translator = params.args
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    local min_col = math.min(start_pos[3], end_pos[3])

    local lines = vim.fn.getline(start_pos[2], end_pos[2])

    -- Assuming that if the selection didn't begin in the col 1, the previous
    -- cols would contain a comment pattern
    -- TODO: Maybe do this with treesitter if found necessary
    local comment_str = ""
    if min_col > 1 then
        comment_str = string.sub(lines[1], 0, min_col - 1)
    end

    for i, line in ipairs(lines) do
        lines[i] = string.sub(line, min_col)
    end

    local input = table.concat(lines, '\n')

    diagon(translator, input, comment_str)
end

-- TODO: add configuration options
function M.setup()
    vim.api.nvim_create_user_command('Diagon', diagon_user_command, {
        complete = function()
            return translators
        end,
        range = 2,
        nargs = 1,
    })
end

return M
