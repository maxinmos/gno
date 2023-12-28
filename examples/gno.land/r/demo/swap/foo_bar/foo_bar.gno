package foo_bar

import (
	"std"

	"gno.land/p/demo/grc/grc20"
	"gno.land/p/demo/swap"
	"gno.land/p/demo/ufmt"
)

var (
	token0 = FooGRC20{}
	token1 = BarGRC20{}

	foobar *grc20.AdminToken
)

func init() {
	foobar = grc20.NewAdminToken("FooBar", "FOOBAR", 4)
}

func TotalSupply() uint64 {
	return foobar.TotalSupply()
}

func BalanceOf(owner std.Address) uint64 {
	balance, err := foobar.BalanceOf(owner)
	if err != nil {
		panic(err)
	}
	return balance
}

func Allowance(owner, spender std.Address) uint64 {
	allowance, err := foobar.Allowance(owner, spender)
	if err != nil {
		panic(err)
	}
	return allowance
}

// setters.

func Transfer(to std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := foobar.Transfer(caller, to, amount)
	if err != nil {
		panic(err)
	}
}

func Approve(spender std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := foobar.Approve(caller, spender, amount)
	if err != nil {
		panic(err)
	}
}

func TransferFrom(from, to std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := foobar.TransferFrom(caller, from, to, amount)
	if err != nil {
		panic(err)
	}
}

func Render(p string) string {
	return ufmt.Sprintf("Name:%s - Symbol:%s\n Supply:%d\n Reserve0:%d\n Reserve1:%d\n", foobar.GetName(), pair.GetSymbol(), pair.TotalSupply(), pair.Reserve0(), pair.Reserve1())
}
