package pair

type IGRC20 interface {
	Transfer(to std.Address, amount uint64) error
	BalanceOf(owner std.Address) (uint64, error)
}
