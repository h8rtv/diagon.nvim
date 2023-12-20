local M = {}

function M.print_error(err_msg)
    vim.schedule(function()
        vim.notify(
            "Diagon Error:\n" .. err_msg,
            vim.log.levels.ERROR,
            { title = "diagon.nvim" }
        )
    end)
end

return M
