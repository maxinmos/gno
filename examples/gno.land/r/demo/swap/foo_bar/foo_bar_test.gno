package foo_bar

import (
	"std"
	"testing"

	"gno.land/r/demo/swap/bar"
	"gno.land/r/demo/swap/foo"
)

func TestFooBar(t *testing.T) {
	admin := std.Address("g1pcuul74usflu3ejrcvwe68ryjlrqlg9ryuya74")
	user := std.Address("g1us8428u2a5satrlxzagqqa5m6vmuze025anjlj")

	std.TestSetOrigCaller(admin)

	b := BalanceOf(admin)
	if b != 0 {
		t.FailNow()
	}

	pairAddr := std.DerivePkgAddr("gno.land/r/demo/swap/foo_bar")
	t.Log(pairAddr)

	b0 := foo.BalanceOf(admin)
	t.Log(b0)

	b1 := bar.BalanceOf(admin)
	t.Log(b1)

	t.Log(std.CurrentRealm().Addr())
	// foo.Transfer(pairAddr, 100)

	// if err := token1.Transfer(pairAddr, 200); err != nil {
	// 	t.Error(err)
	// }
}
