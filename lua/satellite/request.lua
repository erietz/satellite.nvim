local util = require('satellite.util')

Request = {}
Request.__index = Request

function Request:new()
    return setmetatable({
        request_url = nil,
        request_headers = {},
        status_code = nil,
        response_body = nil,
        response_headers = {},
    }, Request)
end

function Request:set_url(url)
    self.request_url = url
end

function Request:write_body_to_buffer(buf_num)
    vim.fn.appendbufline(buf_num, 0, self.response_body)
    vim.cmd('wincmd p')
    vim.cmd('wincmd p')
end

function Request:parse_request()
    local url = vim.fn.getline('.')
    return url
end

function Request:parse_response(lines)
    -- first line of http response
    local split_string = util.split(lines[1], " ")
    local method = split_string[1]
    local status = split_string[2]
    -- local extra = split_string[3]
    self.status_code = status

    local headers = {}
    local loop_index = {["i"] = 2}  -- hack to save variable scope from loop
    repeat
        local line = lines[loop_index["i"]]
        local header = util.split(line, ":")
        local key = header[1]:lower()
        local value = header[2]
        headers[key] = value
        loop_index["i"] = loop_index["i"] + 1
    until (not string.find(line, "^[%w%-]+:%s"))
    loop_index["i"] = loop_index["i"] - 1

    self.response_headers = headers

    local body = {}
    for i = loop_index["i"], #lines do
        table.insert(body, lines[i])
    end
    self.response_body = body
end

function Request:send()
    local response = vim.fn.system('curl -i -s '..self.request_url)
    local lines = {}
    for s in response:gmatch("[^\r\n]+") do
        table.insert(lines, s)
    end
    self:parse_response(lines)
end

return Request
