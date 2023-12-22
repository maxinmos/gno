package swap

import (
	"std"

	"gno.land/p/demo/swap"
	"gno.land/p/demo/ufmt"
)

var (
	p = &P{
		Pair: &swap.Pair{},
	}
)

type P struct {
	Pair *swap.Pair
}

func Render(string) string {
	c := std.DerivePkgAddr("gno.land/r/demo/swap")
	d := std.DerivePkgAddr("gno.land/p/demo/swap")
	return ufmt.Sprintf("caller: %s, gno.land/r/demo/swap: %s, gno.land/p/demo/swap: %s", std.GetOrigCaller(), c, d)
}
