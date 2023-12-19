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

local function diagon(translator, input, on_success)
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
            on_success(j:result())
        end,
    }):sync()
end

local function success(output)
    -- TODO: Finish this function, make it input from buffer text
    vim.schedule(function()
        vim.api.nvim_buf_set_lines(0, 0, 0, true, output)
    end)
end

local function diagon_user_command(params)
    local pos, _ = string.find(params.args, ' ')
    if not pos then
        print_error('No input given')
        return
    end

    local translator = string.sub(params.args, 0, pos - 1)
    local input = string.sub(params.args, pos + 1, -1)

    print(input)

    diagon(translator, input, success)
end

function M.setup()
    vim.api.nvim_create_user_command('Diagon', diagon_user_command, {
        complete = function()
            return translators
        end,
        nargs = '+',
    })
end

return M
