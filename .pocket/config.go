package main

import (
	"github.com/fredrikaverpil/pocket"
	"github.com/fredrikaverpil/pocket/tasks/github"
	"github.com/fredrikaverpil/pocket/tasks/lua"
)

// Config is the pocket configuration for this project.
var Config = pocket.Config{
	AutoRun: pocket.Serial(
		pocket.RunIn(
			lua.Tasks(),
			pocket.Detect(lua.Detect()),
		),
		pocket.WithOpts(github.Workflows, github.WorkflowsOptions{
			Platforms: "ubuntu-latest",
		}),
	),
	Shim: &pocket.ShimConfig{
		Posix: true,
	},
}
