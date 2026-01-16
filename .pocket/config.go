package main

import (
	"github.com/fredrikaverpil/pocket"
	"github.com/fredrikaverpil/pocket/tasks/github"
	"github.com/fredrikaverpil/pocket/tasks/lua"
)

// Config is the pocket configuration for this project.
var Config = pocket.Config{
	AutoRun: pocket.Serial(
		// Lua workflow (format)
		pocket.Paths(lua.Tasks()).DetectBy(lua.Detect()),
	),
	ManualRun: []pocket.Runnable{
		github.Workflows,
	},
	Shim: &pocket.ShimConfig{
		Posix: true,
	},
}
