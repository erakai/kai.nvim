local function block_comment()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_get_current_line()
	local indent = line:match("^%s*") or ""

	local middle, closing

	if line:match("^%s*/%*%*$") then
		middle = indent .. "  * "
		closing = indent .. "  */"
	elseif line:match("^%s*/%*$") then
		middle = indent .. " * "
		closing = indent .. " */"
	else
		return false
	end

	vim.schedule(function()
		vim.api.nvim_buf_set_lines(0, row, row, false, {
			middle,
			closing,
		})
		vim.api.nvim_win_set_cursor(0, { row + 1, #middle })
	end)

	return true
end

vim.keymap.set("i", "<CR>", function()
	if block_comment() then
		return ""
	end

	local line = vim.api.nvim_get_current_line()
	local star = line:match("^%s*%*")

	if star then
		return "<CR>" .. star:match("%*") .. " "
	end

	return "<CR>"
end, { buffer = true, expr = true })
