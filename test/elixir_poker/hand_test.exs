defmodule ElixirPoker.HandTest do
  use ExUnit.Case
  alias ElixirPoker.Hand

  setup do
    hands = %{
      straight_flush: Hand.parse("8D 9D TD JD QD"),
      four_of_a_kind: Hand.parse("8D 8H 8C 8S QH"),
      full_house: Hand.parse("8D 8H 8C QH QH"),
      flush: Hand.parse("2D 9D TD JD AD"),
      straight: Hand.parse("8D 9D TD JD QD"),
      three_of_a_kind: Hand.parse("8D 8H 8S JD QD"),
      two_pair: Hand.parse("8D 8H JS JD QD"),
      pair: Hand.parse("8D 8H KS JD QD")
    }

    {:ok, hands}
  end

  describe "hand detection" do
    test "straight flush", %{straight_flush: hand} do
      assert Hand.straight_flush?(hand)
    end

    test "four of a kind", %{four_of_a_kind: hand} do
      assert Hand.four_of_a_kind?(hand)
    end

    test "full house", %{full_house: hand} do
      assert Hand.full_house?(hand)
    end

    test "flush", %{flush: hand} do
      assert Hand.flush?(hand)
    end

    test "straight", %{straight: hand} do
      assert Hand.straight?(hand)
    end

    test "three of a kind", %{three_of_a_kind: hand} do
      assert Hand.three_of_a_kind?(hand)
    end

    test "two pair", %{two_pair: hand} do
      assert Hand.two_pair?(hand)
    end

    test "pair", %{pair: hand} do
      assert Hand.pair?(hand)
    end
  end

  describe "rank/1" do
    test "straight flush", %{straight_flush: hand} do
      assert Hand.rank(hand) == :straight_flush
    end
  end

  describe "compare/2" do
    test "straight flush is gt four of a kind", %{straight_flush: one, four_of_a_kind: two} do
      assert Hand.compare(one, two) == :gt
    end

    test "four of a kind gt full house", %{four_of_a_kind: one, full_house: two} do
      assert Hand.compare(one, two) == :gt
    end
  end
end
