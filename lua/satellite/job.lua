local Request = require('satellite.request')
local luajob = require('luajob')
local ls = luajob:new({
    cmd = 'ls -al',
    on_stdout = function(err, data)
        print(data)
    end
    })


local M = {}

-- local function on_event(job_id, data, event)
--     if event == 'stdout' then
--         print(vim.inspect(data))
--         print(vim.api.nvim_get_vvar('self.stdout_queue'))
--     elseif event == 'stderr' then
--         print(vim.inspect(data))
--     else
--         -- local r = Request:new()
--         -- r.parse_response()
--         -- r.write_body_to_buffer()
--     end
-- end

-- local function run_job(cmd)
--     local callbacks = {
--         stdout_queue = {'test'},
--         stderr_queue = {'test'},
--         on_stdout = on_event,
--         on_stderr = on_event,
--         on_exit = on_event
--     }
--     vim.fn.jobstart(cmd, callbacks)
-- end


-- M.run_job = run_job
M.run_job = ls.start

return M
