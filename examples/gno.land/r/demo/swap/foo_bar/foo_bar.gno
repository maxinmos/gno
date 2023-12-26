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
	pair   = swap.NewPair("Foo-Bar", "FooBar", 4, token0, token1)
)

func TotalSupply() uint64 {
	return pair.TotalSupply()
}

func BalanceOf(owner std.Address) uint64 {
	balance, err := pair.BalanceOf(owner)
	if err != nil {
		panic(err)
	}
	return balance
}

func Allowance(owner, spender std.Address) uint64 {
	allowance, err := pair.Allowance(owner, spender)
	if err != nil {
		panic(err)
	}
	return allowance
}

// setters.

func Transfer(to std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := pair.Transfer(caller, to, amount)
	if err != nil {
		panic(err)
	}
}

func Approve(spender std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := pair.Approve(caller, spender, amount)
	if err != nil {
		panic(err)
	}
}

func TransferFrom(from, to std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := pair.TransferFrom(caller, from, to, amount)
	if err != nil {
		panic(err)
	}
}

func Mint() {
	caller := std.PrevRealm().Addr()
	if err := pair.Mint(caller); err != nil {
		panic(err)
	}
}

func Render(p string) string {
	return ufmt.Sprintf("Name:%s - Symbol:%s\n Supply:%d\n Reserve0:%d\n Reserve1:%d\n", pair.GetName(), pair.GetSymbol(), pair.TotalSupply(), pair.Reserve0(), pair.Reserve1())
}
