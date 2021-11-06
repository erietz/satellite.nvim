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

    print(r.response_content_type:lower())
    if string.find(r.response_content_type:lower(), "html") then
        vim.cmd('set ft=html')
    elseif string.find(r.response_content_type:lower(), "json") then
        vim.cmd('set ft=json')
    elseif string.find(r.response_content_type:lower(), "xml") then
        vim.cmd('set ft=xml')
    end

    for k,v in pairs(r.response_headers) do
        print('key: ', k, 'value: ', v)
    end
end

return M
