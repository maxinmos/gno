package foo_bar

import (
	"std"

	"gno.land/p/demo/swap"
	"gno.land/r/demo/swap/bar"
	"gno.land/r/demo/swap/foo"
)

type FooGRC20 struct{}

func (FooGRC20) Transfer(to std.Address, amount uint64) (err error) {
	defer func() {
		if e := recover(); e != nil {
			err = e.(error)
		}
	}()
	foo.Transfer(to, amount)
	return nil
}

func (FooGRC20) BalanceOf(owner std.Address) (_ uint64, err error) {
	defer func() {
		if e := recover(); e != nil {
			err = e.(error)
		}
	}()
	return foo.BalanceOf(owner), nil
}

var _ swap.IGRC20 = FooGRC20{}

type BarGRC20 struct{}

func (BarGRC20) Transfer(to std.Address, amount uint64) (err error) {
	defer func() {
		if e := recover(); e != nil {
			err = e.(error)
		}
	}()
	bar.Transfer(to, amount)
	return nil
}

func (BarGRC20) BalanceOf(owner std.Address) (_ uint64, err error) {
	defer func() {
		if e := recover(); e != nil {
			err = e.(error)
		}
	}()
	return bar.BalanceOf(owner), nil
}

var _ swap.IGRC20 = BarGRC20{}
