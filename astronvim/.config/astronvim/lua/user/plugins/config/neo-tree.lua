return function(neotree_config)
	neotree_config.window.position = "right"
	neotree_config.window.mappings = {
		["h"] = "close_node",
		["l"] = "open",
	}
	return neotree_config
end
