package foo_bar

import (
	"gno.land/p/demo/ufmt"
	"gno.land/p/demo/swap"
	"gno.land/p/demo/grc/grc20"
	"gno.land/r/demo/swap/foo"
	"gno.land/r/demo/swap/bar"
)

var (
	pairToken = grc20.NewAdminToken("Foo-Bar", "FooBar", 18)
	pair = swap.NewPair(pairToken, foo.GRC20(), bar.GRC20())
)

func Render(p string) string {
 	cr, pr := pair.Realm()
	return ufmt.Sprintf("Name:%s - Symbol:%s\n Supply:%d\n Reserve0:%d\n Reserve1:%d\n", pair.GetName(), pair.GetSymbol(), pair.TotalSupply(), pair.Reserve0(), pair.Reserve1()) +
		ufmt.Sprintf("Current Realm:%s - %s\n Previous Realm:%s - %s\n", cr.PkgPath(), cr.Addr(), pr.PkgPath(), pr.Addr())
}