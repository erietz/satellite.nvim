local M = {}

M.split = function(string, delimiter)
    local result = {};
    for match in (string..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

M.strip = function(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return M
