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


--[[
HTTP/2 200
server: GitHub.com
date: Sat, 06 Nov 2021 18:53:43 GMT
content-type: application/json; charset=utf-8
cache-control: public, max-age=60, s-maxage=60
vary: Accept, Accept-Encoding, Accept, X-Requested-With
etag: W/"2214e870af97d3af2a71df47b8612af5915e539f343b1884502b4954eb242b94"
last-modified: Thu, 04 Nov 2021 14:35:35 GMT
x-github-media-type: github.v3; format=json
access-control-expose-headers: ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-Rate
Limit-Used, X-RateLimit-Resource, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Ty
pe, Deprecation, Sunset
access-control-allow-origin: *
strict-transport-security: max-age=31536000; includeSubdomains; preload
x-frame-options: deny
x-content-type-options: nosniff
x-xss-protection: 0
referrer-policy: origin-when-cross-origin, strict-origin-when-cross-origin
content-security-policy: default-src 'none'
x-ratelimit-limit: 60
x-ratelimit-remaining: 59
x-ratelimit-reset: 1636228423
x-ratelimit-resource: core
x-ratelimit-used: 1
accept-ranges: bytes
content-length: 1304
x-github-request-id: A01E:4498:2BC7B02:4ECF0C2:6186CF36

{
  "login": "erietz",
  "id": 11425271,
  "node_id": "MDQ6VXNlcjExNDI1Mjcx",
  "avatar_url": "https://avatars.githubusercontent.com/u/11425271?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/erietz",
  "html_url": "https://github.com/erietz",
  "followers_url": "https://api.github.com/users/erietz/followers",
  "following_url": "https://api.github.com/users/erietz/following{/other_user}",
  "gists_url": "https://api.github.com/users/erietz/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/erietz/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/erietz/subscriptions",
  "organizations_url": "https://api.github.com/users/erietz/orgs",
  "repos_url": "https://api.github.com/users/erietz/repos",
  "events_url": "https://api.github.com/users/erietz/events{/privacy}",
  "received_events_url": "https://api.github.com/users/erietz/received_events",
  "type": "User",
  "site_admin": false,
  "name": "Ethan Rietz",
  "company": "Oregon State University",
  "blog": "",
  "location": "Omaha, Ne",
  "email": null,
  "hireable": true,
  "bio": null,
  "twitter_username": null,
  "public_repos": 20,
  "public_gists": 2,
  "followers": 10,
  "following": 15,
  "created_at": "2015-03-11T14:07:00Z",
  "updated_at": "2021-11-04T14:35:35Z"
}
--]]


function Request:parse_response(lines)
    local split_string = util.split(lines[1], " ")
    local method = split_string[1]
    local status = split_string[2]
    -- local extra = split_string[3]
    self.status_code = status

    local headers = {}
    for i = 2, #lines do
        if string.find(lines[i], "^[%a%-]+:%s") then
            local header = util.split(lines[i], ":")
            local key = header[1]
            local value = header[2]
            headers[key] = value
            -- table.insert(headers, lines[i])
            if string.find(lines[i]:lower(), "^content%-type:") then
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
