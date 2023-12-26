package pair

type IAMM interface {
	Mint(amount0, amount1 uint64) (liquidity uint64)
	Burn(liquidity uint64) (amount0, amount1 uint64)
}
