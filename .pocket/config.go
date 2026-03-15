package main

import (
	"github.com/fredrikaverpil/pocket/pk"
	"github.com/fredrikaverpil/pocket/tasks/github"
	"github.com/fredrikaverpil/pocket/tasks/lua"
)

// Config is the Pocket configuration for this project.
var Config = &pk.Config{
	Auto: pk.Serial(
		pk.WithOptions(
			lua.Tasks(),
			pk.WithDetect(lua.Detect()),
		),
		pk.WithOptions(
			github.Tasks(),
			pk.WithFlags(github.WorkflowFlags{
				Platforms: []github.Platform{github.Ubuntu},
			}),
		),
	),

	// Plan configuration.
	Plan: &pk.PlanConfig{
		Shims: pk.DefaultShimConfig(),
	},
}
