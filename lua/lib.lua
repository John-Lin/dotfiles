M = {}

-- https://nanotipsforvim.prose.sh/using-pcall-to-make-your-config-more-stable
-- safeRequire provides safe handling for module loading, suitable for scenarios where dynamic module loading is required.
function M.safeRequire(module)
	local success, loadedModule = pcall(require, module)
	if success then
		return loadedModule
	end
	vim.cmd.echo("Error loading " .. module)
end

return M
