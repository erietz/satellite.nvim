local Request = require('satellite.request')

local function newOutputBuffer()
    vim.cmd("below split SATELLITE_OUTPUT")
end

-------------------------------------------------------------------------------
local M = {}

M.request = function()
    local r = Request.new()

    local url = r:parse_request()

    r:set_url(url)
    r:send()
    newOutputBuffer()
    r:write_body_to_buffer()

    if r.response_content_type then
        if string.find(r.response_content_type, "html") then
            vim.cmd('set ft=html')
        elseif string.find(r.response_content_type, "json") then
            vim.cmd('set ft=json')
        elseif string.find(r.response_content_type, "xml") then
            vim.cmd('set ft=xml')
        end
    end
    vim.cmd('set ft=json')
end

return M
