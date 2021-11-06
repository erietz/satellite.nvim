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

    return r
end

M.async_request = function()
end

return M
