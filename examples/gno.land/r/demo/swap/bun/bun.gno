package bun

import (
	"std"
	"strings"

	"gno.land/p/demo/grc/grc20"
	"gno.land/p/demo/ufmt"
	"gno.land/r/demo/swap/foo"
)

var (
// 	foo   *grc20.AdminToken
	admin std.Address = "g1pcuul74usflu3ejrcvwe68ryjlrqlg9ryuya74" // TODO: helper to change admin
)

func init() {
	// foo = grc20.NewAdminToken("bar", "bar", 4)
	// foo.Mint(admin, 1000000*10000)                                    // @administrator (1M)
}

// method proxies as public functions.
//

// getters.

func TotalSupply() uint64 {
	return foo.TotalSupply()
}

func BalanceOf(owner std.Address) uint64 {
	return foo.BalanceOf(owner)
}

func Allowance(owner, spender std.Address) uint64 {
	return foo.Allowance(owner, spender)
}

// setters.

func Transfer(to std.Address, amount uint64) {
	foo.Transfer(to, amount)
}

func Approve(spender std.Address, amount uint64) {
	foo.Approve(spender, amount)
}

func TransferFrom(from, to std.Address, amount uint64) {
	foo.TransferFrom(from, to, amount)
}

// render.
//

func Render(path string) string {
	return ""
}

// func assertIsAdmin(address std.Address) {
// 	if address != admin {
// 		panic("restricted access")
// 	}
// }
