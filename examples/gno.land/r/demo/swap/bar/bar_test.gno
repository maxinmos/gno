package bar

import (
	"std"
	"testing"

	"gno.land/r/demo/swap/foo"
)

func TestTransfer(t *testing.T) {
	admin := std.Address("g1pcuul74usflu3ejrcvwe68ryjlrqlg9ryuya74")
	user := std.Address("g1us8428u2a5satrlxzagqqa5m6vmuze025anjlj")
	std.TestSetOrigCaller(admin)

	barGrc20 := GRC20()
	fooGrc20 := foo.GRC20()

	if err := barGrc20.Transfer(user, 1); err != nil {
		t.FailNow()
	}

	if balance, err := barGrc20.BalanceOf(user); err != nil {
		t.FailNow()
	} else if balance != 1{
		t.FailNow()
	}

	if balance, err := barGrc20.BalanceOf(admin); err != nil {
		t.FailNow()
	} else if balance != (1000000*10000 - 1) {
		t.FailNow()
	}

	foo.Transfer(user, 1)

	// if balance, err := fooGrc20.BalanceOf(user); err != nil {
	// 	t.FailNow()
	// } else if balance != 0 {
	// 	t.FailNow()
	// }
}