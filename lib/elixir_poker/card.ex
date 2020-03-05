defmodule ElixirPoker.Card do
  @type t :: {String.t(), String.t()}

  @spec parse(String.t()) :: t()
  def parse(<<rank, suit>>), do: {rank, suit}

  def rank(card), do: elem(card, 0)
  def suit(card), do: elem(card, 1)
  def to_string(card), do: card |> Tuple.to_list() |> String.Chars.to_string()

  def compare({c_rank, _}, {o_rank, _}) do
    case {rank_sort_value(c_rank), rank_sort_value(o_rank)} do
      {c, o} when c == o -> :eq
      {c, o} when c > o -> :gt
      {c, o} when c < o -> :lt
    end
  end

  def rank_sort_value(?2), do: 2
  def rank_sort_value(?3), do: 3
  def rank_sort_value(?4), do: 4
  def rank_sort_value(?5), do: 5
  def rank_sort_value(?6), do: 6
  def rank_sort_value(?7), do: 7
  def rank_sort_value(?8), do: 8
  def rank_sort_value(?9), do: 9
  def rank_sort_value(?T), do: 10
  def rank_sort_value(?J), do: 11
  def rank_sort_value(?Q), do: 12
  def rank_sort_value(?K), do: 13
  def rank_sort_value(?A), do: 14
end
