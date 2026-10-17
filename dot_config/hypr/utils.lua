local U = {}

function U.safe_require(module_name)
	local status, result = pcall(require, module_name)

	if not status then
		-- Log the failure and the error message provided by require
		print(string.format("[Error] Failed to require '%s': %s", module_name, result))
		return nil
	end

	-- Return the loaded module on success
	return result
end

function U.safe(func, ...)
	-- Execute the function with any arguments passed via '...'
	local success, result = pcall(func, ...)

	if not success then
		-- Log the failure and the error message
		print(string.format("[Error] Execution failed: %s", result))
		return false, result
	end

	-- Return true and whatever the function originally returned
	return true, result
end

return U
