package foo

import (
	"std"
	"strings"

	"gno.land/p/demo/grc/grc20"
	"gno.land/p/demo/ufmt"
)

var (
	foo   *grc20.AdminToken
	admin std.Address = "g1pcuul74usflu3ejrcvwe68ryjlrqlg9ryuya74" // TODO: helper to change admin
)

func init() {
	foo = grc20.NewAdminToken("Foo", "FOO", 4)
	foo.Mint(admin, 1000000*10000)                                    // @administrator (1M)
}

// method proxies as public functions.
//

// getters.

func TotalSupply() uint64 {
	return foo.TotalSupply()
}

func BalanceOf(owner std.Address) uint64 {
	balance, err := foo.BalanceOf(owner)
	if err != nil {
		panic(err)
	}
	return balance
}

func Allowance(owner, spender std.Address) uint64 {
	allowance, err := foo.Allowance(owner, spender)
	if err != nil {
		panic(err)
	}
	return allowance
}

// setters.

func Transfer(to std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := foo.Transfer(caller, to, amount)
	if err != nil {
		panic(err)
	}
}

func Approve(spender std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := foo.Approve(caller, spender, amount)
	if err != nil {
		panic(err)
	}
}

func TransferFrom(from, to std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := foo.TransferFrom(caller, from, to, amount)
	if err != nil {
		panic(err)
	}
}

// faucet.

func Faucet() {
	// FIXME: add limits?
	// FIXME: add payment in gnot?
	caller := std.PrevRealm().Addr()
	err := foo.Mint(caller, 1000*10000) // 1k
	if err != nil {
		panic(err)
	}
}

// administration.

func Mint(address std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	assertIsAdmin(caller)
	err := foo.Mint(address, amount)
	if err != nil {
		panic(err)
	}
}

func Burn(address std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	assertIsAdmin(caller)
	err := foo.Burn(address, amount)
	if err != nil {
		panic(err)
	}
}

// render.
//

func Render(path string) string {
	parts := strings.Split(path, "/")
	c := len(parts)

	switch {
	case path == "":
		return foo.RenderHome()
	case c == 2 && parts[0] == "balance":
		owner := std.Address(parts[1])
		balance, _ := foo.BalanceOf(owner)
		return ufmt.Sprintf("%d\n", balance)
	default:
		return "404\n"
	}
}

func assertIsAdmin(address std.Address) {
	if address != admin {
		panic("restricted access")
	}
}

func GRC20() grc20.IGRC20 {
	return foo.GRC20()
}