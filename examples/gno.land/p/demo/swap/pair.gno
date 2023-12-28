package swap

import (
	"math"
	"std"

	"gno.land/p/demo/grc/grc20"
	"gno.land/p/demo/ufmt"
)

type IGRC20 interface {
	Transfer(to std.Address, amount uint64) error
	BalanceOf(owner std.Address) (uint64, error)
}

type IPair interface {
	IGRC20
	Mint(to std.Address, amount uint64) error
	Burn(from std.Address, amount uint64) error
	Balances() (balance0 uint64, balance1 uint64, _ error)
}

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
	tokenPair IPair
	token0    IGRC20
	token1    IGRC20
	reserve0  uint64
	reserve1  uint64
}

func NewPair(tokenPair IPair, token0, token1 IGRC20) *Pair {
	return &Pair{
		tokenPair: tokenPair,
		token0:    token0,
		token1:    token1,
	}
}

func (p *Pair) Mint(sender std.Address) error {
	balance0, balance1, err := p.tokenPair.Balances()
	if err != nil {
		return err
	}

	amm := NewAMM(p.reserve0, p.reserve1, p.TotalSupply())

	amount0 := balance0 - p.reserve0
	amount1 := balance1 - p.reserve1

	liquidity := amm.Mint(amount0, amount1)

	if err := p.tokenPair.Mint(sender, liquidity); err != nil {
		return err
	}

	p.update(balance0, balance1)

	emit(&MintEvent{
		Sender:  sender,
		Amount0: amount0,
		Amount1: amount1,
	})

	return nil
}

func (p *Pair) Burn(sender std.Address) error {
	balance0, balance1, err := p.tokenPair.Balances()
	if err != nil {
		return err
	}

	liquidity, err := p.BalanceOf(sender)
	if err != nil {
		return err
	}

	amm := NewAMM(balance0, balance1, p.TotalSupply())
	amount0, amount1 := amm.Burn(liquidity)

	if err := p.tokenPair.Burn(sender, liquidity); err != nil {
		return err
	}

	if err := p.token0.Transfer(sender, amount0); err != nil {
		return err
	}

	if err := p.token1.Transfer(sender, amount1); err != nil {
		return err
	}

	balance0, balance1, err = p.tokenPair.Balances()
	if err != nil {
		return err
	}

	p.update(balance0, balance1)

	emit(&BurnEvent{
		Sender:  sender,
		Amount0: amount0,
		Amount1: amount1,
	})

	return nil
}

func (p *Pair) Reserve0() uint64 {
	return p.reserve0
}

func (p *Pair) Reserve1() uint64 {
	return p.reserve1
}

func (p *Pair) update(balance0, balance1 uint64) {
	p.reserve0 = balance0
	p.reserve1 = balance1

	emit(&SyncEvent{
		Reserve0: p.reserve0,
		Reserve1: p.reserve1,
	})
}
