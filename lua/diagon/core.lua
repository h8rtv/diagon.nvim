local Job = require 'plenary.job'

local M = {}

function M.diagon(params)
    local translator = params.translator
    local input = params.input
    local on_success = params.on_success
    local on_error = params.on_error

    if vim.fn.executable('diagon') == 0 then
        return on_error('Diagon not found in path')
    end

    if string.len(input) <= 0 then
        return on_error('No input given')
    end

    Job:new({
        command = 'diagon',
        args = { translator, '--', input },
        on_exit = function(j)
            if #j:stderr_result() ~= 0 then
                return on_error(table.concat(j:stderr_result(), '\n'))
            end
            local output = j:result()
            table.remove(j:result()) -- pop in lua
            on_success(output)
        end,
    }):sync()
end

return M
