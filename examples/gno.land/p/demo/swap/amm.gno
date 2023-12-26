package swap

import "math"

type AMM struct {
	reserve0    uint64
	reserve1    uint64
	totalSupply uint64
}

func NewAMM(reserve0, reserve1, totalSupply uint64) *AMM {
	return &AMM{
		reserve0:    reserve0,
		reserve1:    reserve1,
		totalSupply: totalSupply,
	}
}

func (a *AMM) Mint(amount0, amount1 uint64) uint64 {
	var liquidity uint64
	if a.totalSupply == 0 {
		liquidity = uint64(math.Sqrt(float64(amount0 * amount1)))
	} else {
		l0 := amount0 * a.totalSupply / a.reserve0
		l1 := amount1 * a.totalSupply / a.reserve1
		if l0 < l1 {
			liquidity = uint64(l0)
		} else {
			liquidity = uint64(l1)
		}
	}

	return liquidity
}

func (a *AMM) Burn(liquidity uint64) (amount0, amount1 uint64) {
	amount0 = liquidity * a.reserve0 / a.totalSupply
	amount1 = liquidity * a.reserve1 / a.totalSupply
	return amount0, amount1
}
