package swap

import (
	"std"
	"math"

	"gno.land/p/demo/grc/grc20"
	"gno.land/p/demo/ufmt"
)

type MintEvent struct{
	Sender std.Address
	Amount0 uint64
	Amount1 uint64
}

type BurnEvent struct {
	Sender std.Address
	Amount0 uint64
	Amount1 uint64
}

type SyncEvent struct{
	Reserve0 uint64
	Reserve1 uint64
}

type Pair struct {
	*grc20.AdminToken

	token0 grc20.IGRC20
	token1 grc20.IGRC20
	reserve0 uint64
	reserve1 uint64
}

func NewPair(admin *grc20.AdminToken, token0, token1 grc20.IGRC20) *Pair{
	return &Pair{
		AdminToken: admin,
		token0: token0,
		token1: token1,
	}
}

func (p *Pair) Mint(sender std.Address) error {
	realm := std.CurrentRealm()

	balance0, err := p.token0.BalanceOf(realm.Addr())
	if err != nil {
		return err
	}

	balance1, err := p.token1.BalanceOf(realm.Addr())
	if err != nil {
		return err
	}

	amount0 := balance0 - p.reserve0
	amount1 := balance1 - p.reserve1

	var liquidity uint64
	if p.TotalSupply() == 0 {
		liquidity = uint64(math.Sqrt(float64(amount0 * amount1)))
	} else {
		l0 := amount0*p.TotalSupply()/p.reserve0
		l1 := amount1*p.TotalSupply()/p.reserve1
		if l0 < l1 {
			liquidity = uint64(l0)
		} else {
			liquidity = uint64(l1)
		}
	}

	if err := p.AdminToken.Mint(sender, liquidity); err != nil {
		return err
	}

	emit(&MintEvent{
		Sender: sender,
		Amount0: amount0,
		Amount1: amount1,
	})
}

func (p *Pair) Burn(sender std.Address) error {
	realm := std.CurrentRealm()

	balance0, err := p.token0.BalanceOf(realm.Addr())
	if err != nil {
		return err
	}

	balance1, err := p.token1.BalanceOf(realm.Addr())
	if err != nil {
		return err
	}

	liquidity, err := p.BalanceOf(sender)
	if err != nil {
		return err
	}

	amount0 := liquidity * balance0 / p.TotalSupply()
	amount1 := liquidity * balance1 / p.TotalSupply()

	if err := p.token0.Transfer(sender, amount0); err != nil {
		return err
	}

	if err := p.token1.Transfer(sender, amount1); err != nil {
		return err
	}

	balance0, err = p.token0.BalanceOf(realm.Addr())
	if err != nil {
		return err
	}

	balance1, err = p.token1.BalanceOf(realm.Addr())
	if err != nil {
		return err
	}

	p.update(balance0, balance1)

	emit(&BurnEvent{
		Sender: sender,
		Amount0: amount0,
		Amount1: amount1,
	})
}

func (p *Pair) Realm() (std.Realm, std.Realm) {
	cr := std.CurrentRealm()
	pr := std.PrevRealm()

	return cr, pr
}

func (p *Pair) Reserve0() uint64 {
	return p.reserve0
}

func (p *Pair) Reserve1() uint64 {
	return p.reserve1
}

func (p *Pair) update(balance0, balance1 uint64) error {
	p.reserve0 = balance0
	p.reserve1 = balance1

	emit(&SyncEvent{
		Reserve0: p.reserve0,
		Reserve1: p.reserve1,
	})
}
