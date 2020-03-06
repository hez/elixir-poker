defmodule ElixirPoker.Hand do
  alias ElixirPoker.Card
  @cards_per_hand 5

  @ranked_hands %{
    high_card: {0, "High Card"},
    pair: {1, "One Pair"},
    two_pair: {2, "Two Pair"},
    three_of_a_kind: {3, "Three of a Kind"},
    straight: {4, "Straight"},
    flush: {5, "Flush"},
    full_house: {6, "Full House"},
    four_of_a_kind: {7, "Four of a Kind"},
    straight_flush: {8, "Straight Flush"}
  }
  @rank_map %{four_rank: 0, three_rank: 0, pairs: [], singles: []}

  @type t :: list(Card.t())
  def parse(hand) do
    hand
    |> String.split(" ")
    |> Enum.map(&Card.parse/1)
    |> check_length!()
  end

  @spec compare(t(), t()) :: :eq | :lt | :gt
  def compare(hand, other) when is_list(hand) and is_list(other) do
    case {rank_value(hand), rank_value(other)} do
      {rv, ro} when rv == ro ->
        case {value(hand), value(other)} do
          {v, o} when v == o -> :eq
          {v, o} when v < o -> :lt
          {v, o} when v > o -> :gt
        end

      {rv, ro} when rv < ro ->
        :lt

      {rv, ro} when rv > ro ->
        :gt
    end
  end

  def rank(hand) do
    cond do
      straight_flush?(hand) -> :straight_flush
      four_of_a_kind?(hand) -> :four_of_a_kind
      full_house?(hand) -> :full_house
      flush?(hand) -> :flush
      straight?(hand) -> :straight
      three_of_a_kind?(hand) -> :three_of_a_kind
      two_pair?(hand) -> :two_pair
      pair?(hand) -> :pair
      true -> :high_card
    end
  end

  def value(hand) do
    if wraparound_straight?(hand) do
      {0, 0, 0, 0, 5, 4, 3, 2, 1}
    else
      value =
        hand
        |> rank_sizes()
        # Convert rank to sorting value
        |> Enum.map(&{Card.rank_sort_value(elem(&1, 0)), elem(&1, 1)})
        |> Enum.reduce(@rank_map, fn {key, val}, acc ->
          case val do
            4 -> %{acc | four_rank: key}
            3 -> %{acc | three_rank: key}
            2 -> %{acc | pairs: acc.pairs ++ [key]}
            _ -> %{acc | singles: acc.singles ++ [key]}
          end
        end)

      value = %{value | pairs: Enum.sort(value.pairs), singles: Enum.sort(value.singles)}

      {
        value.four_rank,
        value.three_rank,
        Enum.at(value.pairs, 1, 0),
        Enum.at(value.pairs, 0, 0),
        Enum.at(value.singles, 4, 0),
        Enum.at(value.singles, 3, 0),
        Enum.at(value.singles, 2, 0),
        Enum.at(value.singles, 1, 0),
        Enum.at(value.singles, 0, 0)
      }
    end
  end

  def rank_string(hand), do: elem(@ranked_hands[rank(hand)], 1)
  def rank_value(hand), do: elem(@ranked_hands[rank(hand)], 0)

  def rank_sets(hand) do
    hand
    |> Enum.sort_by(& &1, Card)
    |> Enum.map(&Card.rank/1)
    |> Enum.uniq()
  end

  def pair?(hand), do: hand |> rank_sets |> Enum.count() == 4

  def two_pair?(hand),
    do: hand |> rank_sets() |> Enum.count() == 3 and most_common_rank_size(hand) == 2

  def three_of_a_kind?(hand),
    do: hand |> rank_sets() |> Enum.count() == 3 and most_common_rank_size(hand) == 3

  def straight?(hand), do: all_consecutive?(hand) or wraparound_straight?(hand)

  def flush?(hand), do: all_same_suit?(hand)

  def full_house?(hand),
    do: hand |> rank_sets() |> Enum.count() == 2 and most_common_rank_size(hand) == 3

  def four_of_a_kind?(hand),
    do: hand |> rank_sets() |> Enum.count() == 2 and most_common_rank_size(hand) == 4

  def straight_flush?(hand), do: straight?(hand) and flush?(hand)

  def all_same_suit?(hand),
    do: Enum.all?(hand, fn c -> hand |> List.first() |> Card.suit() == Card.suit(c) end)

  def rank_sizes(hand),
    do: Enum.reduce(hand, %{}, fn c, acc -> Map.update(acc, Card.rank(c), 1, &(&1 + 1)) end)

  def most_common_rank_size(hand), do: hand |> rank_sizes() |> Map.values() |> Enum.max()

  def all_consecutive?(hand) do
    ranks = rank_sets(hand)

    Enum.count(ranks) == 5 and
      (ranks |> List.last() |> Card.rank_sort_value()) -
        (ranks |> List.first() |> Card.rank_sort_value()) == 4
  end

  def wraparound_straight?(hand) do
    ranks = rank_sets(hand)

    Enum.count(ranks) == 5 and
      ranks |> Enum.at(3) |> Card.rank_sort_value() == 5 and
      ranks |> Enum.at(4) |> Card.rank_sort_value() == 14
  end

  def to_string(hand) do
    hand
    |> Enum.map(&Card.to_string/1)
    |> Enum.join(" ")
  end

  defp check_length!(hand) when length(hand) != @cards_per_hand,
    do: raise(RuntimeError, message: "Error only #{@cards_per_hand} card hands supported")

  defp check_length!(hand), do: hand
end
