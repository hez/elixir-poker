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
    |> Enum.map(&process_line/1)
    |> Enum.map(&log_line/1)
    |> Enum.each(&IO.puts/1)
  end

  def run_stream do
    :stdio
    |> IO.stream(:line)
    |> Task.async_stream(fn line ->
      line
      |> String.trim()
      |> process_line()
      |> log_line()
    end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.each(&IO.puts/1)
  end

  defp process_line(line), do: {line, parse_hands(line)}

  defp log_line({line, hands}) do
    # sorted |> Enum.map(&Hand.rank_string/1) |> Enum.join(", ") |> IO.inspect
    max = Enum.max_by(hands, & &1, Hand)
    "#{line}, Winner: #{Hand.to_string(max)}, Rank: #{Hand.rank_string(max)}"
  end

  defp parse_hands(hands) do
    hands
    |> String.split("|")
    |> Enum.map(&Hand.parse/1)
  end

  defp sort_hands(hands), do: Enum.sort_by(hands, & &1, {:desc, Hand})
end
