local M = {}

local function on_event(job_id, data, event)
    if event == 'stdout' then
        print(vim.inspect(data))
    elseif event == 'stderr' then
        print(vim.inspect(data))
    else
    end
end

local function run_job(cmd)
    local callbacks = {
        on_stdout = on_event,
        on_stderr = on_event,
        on_exit = on_event
    }
    vim.fn.jobstart(cmd, callbacks)
end


M.run_job = run_job

return M
