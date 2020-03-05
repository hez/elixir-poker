defmodule ElixirPoker do
  @moduledoc """
  Documentation for `ElixirPoker`.
  """
  require Logger

  alias ElixirPoker.Hand

  def run do
    :all
    |> IO.read()
    |> String.split("\n")
    |> Enum.reject(&(String.length(&1) == 0))
    |> Enum.each(&process_line/1)
  end

  defp process_line(line) do
    sorted =
      line
      |> parse_hands()
      |> sort_hands()

    #sorted |> Enum.map(&Hand.rank_string/1) |> Enum.join(", ") |> IO.inspect
    max = List.first(sorted)
    IO.puts("#{line}, Winner: #{Hand.to_string(max)}, Rank: #{Hand.rank_string(max)}")
  end

  defp parse_hands(hands) do
    hands
    |> String.split("|")
    |> Enum.map(&Hand.parse/1)
  end

  defp sort_hands(hands), do: Enum.sort_by(hands, & &1, {:desc, Hand})
end
