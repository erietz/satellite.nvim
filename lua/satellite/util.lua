local function new_output_buffer()
    vim.cmd("below split SATELLITE_OUTPUT")
    vim.cmd("setlocal buftype=nofile noswapfile nowrap modifiable nospell nonumber norelativenumber winfixheight winfixwidth")
    local buf_num = vim.fn.bufnr('%')
    return buf_num
end

local function prepare_output_buffer()
    local buf_num = vim.fn.bufnr('SATELLITE_OUTPUT')
    if buf_num == -1 then
        buf_num = new_output_buffer()
        vim.cmd('wincmd p')
        return buf_num
    elseif vim.fn.bufwinid('SATELLITE_OUTPUT') == -1 then
        buf_num = new_output_buffer()
        vim.fn.deletebufline(buf_num, 1, '$')
        vim.cmd('wincmd p')
        return buf_num
    else
        vim.fn.deletebufline(buf_num, 1, '$')
        return buf_num
    end
end

local M = {}

M.split = function(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

M.strip = function(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

M.prepare_output_buffer = prepare_output_buffer

return M
