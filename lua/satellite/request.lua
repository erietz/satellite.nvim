local util = require('satellite.util')

Request = {}
Request.__index = Request

function Request:new()
    return setmetatable({
        request_url = nil,
        request_headers = nil,
        response_raw = nil,
        response_body = nil,
        response_headers = nil,
        response_content_type = nil,
        status_code = nil
    }, Request)
end

function Request:set_url(url)
    self.request_url = url
end

function Request:write_headers_to_buffer()
    vim.fn.append(0, self.response_headers)
end

function Request:write_raw_to_buffer()
    vim.fn.append(0, self.response_raw)
end

function Request:write_body_to_buffer()
    vim.fn.append(0, self.response_body)
end

function Request:parse_request()
    local url = vim.fn.getline('.')
    return url
end

function Request:parse_response(lines)
    local split_string = util.split(lines[1], " ")
    local method = split_string[1]
    local status = split_string[2]
    local extra = split_string[3]
    self.status_code = status

    local headers = {}
    for i = 2, #lines do
        if string.find(lines[i], "^[%a%-]+:%s") then
            table.insert(headers, lines[i])
            if string.find(lines[i], "Content%-Type") then
                self.response_content_type = util.split(lines[i], " ")[2]
            end
        else
            body_start_index = i
            break
        end
    end
    self.response_headers = headers

    local body = {}
    for i = body_start_index, #lines do
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
    self.response_raw = lines
    self:parse_response(lines)
end

return Request
