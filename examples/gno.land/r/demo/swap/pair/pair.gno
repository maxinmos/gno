package pair

import (
	"std"

	"gno.land/p/demo/swap"
)

type MintEvent struct {
	Sender  std.Address
	Amount0 uint64
	Amount1 uint64
}

type BurnEvent struct {
	Sender  std.Address
	Amount0 uint64
	Amount1 uint64
}

type SyncEvent struct {
	Reserve0 uint64
	Reserve1 uint64
}

type Pair struct {
	*grc20.AdminToken

	token0   IGRC20
	token1   IGRC20
	reserve0 uint64
	reserve1 uint64
	ammF     func(reserve0, reserve1, totalSupply uint64) IAMM
}

func (p *Pair) Mint(sender std.Address) error {
	pair := std.PrevRealm().Addr()

	balance0, err := p.token0.BalanceOf(pair)
	if err != nil {
		return err
	}

	balance1, err := p.token1.BalanceOf(pair)
	if err != nil {
		return err
	}

	amount0 := balance0 - p.reserve0
	amount1 := balance1 - p.reserve1

	amm := p.ammF(p.reserve0, p.reserve1, p.TotalSupply())
	liquidity := amm.Mint(amount0, amount1)

	if err := p.AdminToken.Mint(sender, liquidity); err != nil {
		return err
	}

	if err := p.update(balance0, balance1); err != nil {
		return err
	}

	emit(&MintEvent{
		Sender:  sender,
		Amount0: amount0,
		Amount1: amount1,
	})
}

func (p *Pair) Burn(sender std.Address) error {
	pair := std.PrevRealm().Addr()

	balance0, err := p.token0.BalanceOf(pair)
	if err != nil {
		return err
	}

	balance1, err := p.token1.BalanceOf(pair)
	if err != nil {
		return err
	}

	liquidity, err := p.BalanceOf(sender)
	if err != nil {
		return err
	}

	amm := p.ammF(balance0, balance1, p.TotalSupply())
	amount0, amount1 := amm.Burn(liquidity)

	if err := p.token0.Transfer(sender, amount0); err != nil {
		return err
	}

	if err := p.token1.Transfer(sender, amount1); err != nil {
		return err
	}

	balance0, err = p.token0.BalanceOf(p.pair)
	if err != nil {
		return err
	}

	balance1, err = p.token1.BalanceOf(p.pair)
	if err != nil {
		return err
	}

	p.update(balance0, balance1)

	emit(&BurnEvent{
		Sender:  sender,
		Amount0: amount0,
		Amount1: amount1,
	})
}

func (p *Pair) update(balance0, balance1 uint64) error {
	p.reserve0 = balance0
	p.reserve1 = balance1

	emit(&SyncEvent{
		Reserve0: p.reserve0,
		Reserve1: p.reserve1,
	})
}
