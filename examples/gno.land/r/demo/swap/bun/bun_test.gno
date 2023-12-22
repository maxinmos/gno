package bun

import (
	"std"
	"testing"
)

func TestBun(t *testing.T) {
	admin := std.Address("g1pcuul74usflu3ejrcvwe68ryjlrqlg9ryuya74")
	user := std.Address("g1us8428u2a5satrlxzagqqa5m6vmuze025anjlj")
	std.TestSetOrigCaller(admin)

	// BalanceOf(user)
	Transfer(user, 1)

}