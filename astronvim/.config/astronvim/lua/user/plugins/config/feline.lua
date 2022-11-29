return function(feline_config)
	local second_component = feline_config.components.active[2]

	-- disable lsp server names
	second_component[2] = {
		provider = "",
	}

	-- disable TS status
	second_component[4] = {
		provider = "",
	}

	-- disable shitty scrollbar
	second_component[10] = {
		provider = "",
	}

	return feline_config
end
