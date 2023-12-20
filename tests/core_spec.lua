local spy = require 'luassert.spy'
local stub = require 'luassert.stub'
local match = require 'luassert.match'

describe("diagon core functionality module", function()
    local Core = require('diagon.core')

    it("calls on_error when diagon is not found in path", function()
        stub(vim.fn, "executable").returns(0)

        local on_success = spy(function() end)
        local on_error = spy(function() end)

        Core.diagon {
            translator = 'Math',
            input = '1 + 1',
            on_success = on_success,
            on_error = on_error,
        }

        assert.spy(on_error).was_called_with("Diagon not found in path")
    end)

    it("calls on_error when input is an empty string", function()
        stub(vim.fn, "executable").returns(1)

        local on_success = spy(function() end)
        local on_error = spy(function() end)

        Core.diagon {
            translator = "Math",
            input = "",
            on_success = on_success,
            on_error = on_error,
        }

        assert.spy(on_error).was_called_with("No input given")
    end)

    -- Needs diagon to be installed in the machine
    it("calls on_error when the input is not well formated", function()
        stub(vim.fn, "executable").returns(1)

        local on_success = spy(function() end)
        local on_error = spy(function() end)

        Core.diagon {
            translator = "Sequence",
            input = "A -> B",
            on_success = on_success,
            on_error = on_error,
        }

        assert.spy(on_error).was_called_with(match.is_string())
    end)


    -- Needs diagon to be installed in the machine
    it("calls on_success when the input is well formated", function()
        stub(vim.fn, "executable").returns(1)

        local on_success = spy(function() end)
        local on_error = spy(function() end)

        Core.diagon {
            translator = "Math",
            input = "A -> B",
            on_success = on_success,
            on_error = on_error,
        }

        assert.spy(on_success).was_called_with({ "A ⟶ B" })
    end)
end)
