local Request = require('satellite.request')
local util = require('satellite.util')


-------------------------------------------------------------------------------
local M = {}

M.request = function()
    local r = Request.new()
    local url = r:parse_request()
    r:set_url(url)
    r:send()
    local buf_num = util.prepare_output_buffer()
    r:write_body_to_buffer(buf_num)

    local content_type = r.response_headers["content-type"]
    if string.find(content_type, "html") then
        vim.fn.setbufvar(buf_num, '&filetype', 'html')
    elseif string.find(content_type, "json") then
        vim.fn.setbufvar(buf_num, '&filetype', 'json')
    elseif string.find(content_type, "xml") then
        vim.fn.setbufvar(buf_num, '&filetype', 'xml')
    end

    return r
end

return M
