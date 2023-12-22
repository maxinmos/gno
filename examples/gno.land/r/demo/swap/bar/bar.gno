package bar

import (
	"std"
	"strings"

	"gno.land/p/demo/grc/grc20"
	"gno.land/p/demo/ufmt"
)

var (
	bar   *grc20.AdminToken
	admin std.Address = "g1pcuul74usflu3ejrcvwe68ryjlrqlg9ryuya74" // TODO: helper to change admin
)

func init() {
	bar = grc20.NewAdminToken("bar", "bar", 4)
	bar.Mint(admin, 1000000*10000)                                    // @administrator (1M)
}

// method proxies as public functions.
//

// getters.

func TotalSupply() uint64 {
	return bar.TotalSupply()
}

func BalanceOf(owner std.Address) uint64 {
	balance, err := bar.BalanceOf(owner)
	if err != nil {
		panic(err)
	}
	return balance
}

func Allowance(owner, spender std.Address) uint64 {
	allowance, err := bar.Allowance(owner, spender)
	if err != nil {
		panic(err)
	}
	return allowance
}

// setters.

func Transfer(to std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := bar.Transfer(caller, to, amount)
	if err != nil {
		panic(err)
	}
}

func Approve(spender std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := bar.Approve(caller, spender, amount)
	if err != nil {
		panic(err)
	}
}

func TransferFrom(from, to std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	err := bar.TransferFrom(caller, from, to, amount)
	if err != nil {
		panic(err)
	}
}

// faucet.

func Faucet() {
	// FIXME: add limits?
	// FIXME: add payment in gnot?
	caller := std.PrevRealm().Addr()
	err := bar.Mint(caller, 1000*10000) // 1k
	if err != nil {
		panic(err)
	}
}

// administration.

func Mint(address std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	assertIsAdmin(caller)
	err := bar.Mint(address, amount)
	if err != nil {
		panic(err)
	}
}

func Burn(address std.Address, amount uint64) {
	caller := std.PrevRealm().Addr()
	assertIsAdmin(caller)
	err := bar.Burn(address, amount)
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
		return bar.RenderHome()
	case c == 2 && parts[0] == "balance":
		owner := std.Address(parts[1])
		balance, _ := bar.BalanceOf(owner)
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

func GRC20_() grc20.IGRC20 {
	return bar.GRC20()
}

func GRC20() grc20.IGRC20 {
	return &Grc20{
		token: bar.GRC20(),
	}
}

type Grc20 struct {
	token grc20.IGRC20
}

func (t *Grc20) GetName() string     { return t.token.GetName() }
func (t *Grc20) GetSymbol() string   { return t.token.GetSymbol() }
func (t *Grc20) GetDecimals() uint   { return t.token.GetDecimals() }
func (g *Grc20) TotalSupply() uint64 { return g.token.TotalSupply() }

func (g *Grc20) BalanceOf(account std.Address) (uint64, error) {
	return g.token.BalanceOf(account)
}

func (g *Grc20) Transfer(to std.Address, amount uint64) error {
	return g.token.Transfer(to, amount)
}

func (g *Grc20) Allowance(owner, spender std.Address) (uint64, error) {
	return g.token.Allowance(owner, spender)
}

func (g *Grc20) Approve(spender std.Address, amount uint64) error {
	return g.token.Approve(spender, amount)
}

func (g *Grc20) TransferFrom(from, to std.Address, amount uint64) error {
	return g.token.TransferFrom(from, to, amount)
}