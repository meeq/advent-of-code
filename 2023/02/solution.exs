defmodule Day2 do
  def parse_file(file) do
    File.stream!(file)
    |> Enum.map(&parse_game/1)
  end

  def parse_game(str) do
    [<<"Game ", game_id::binary>>, rest] = String.trim(str) |> String.split(": ")
    draws = String.split(rest, "; ") |> Enum.map(&parse_draw/1)
    {String.to_integer(game_id), draws}
  end

  def parse_draw(str) do
    String.split(str, ", ") |> Enum.map(&parse_count/1) |> Map.new()
  end

  def parse_count(str) do
    [count, color] = String.split(str, " ")
    {color, String.to_integer(count)}
  end

  def reduce_draws_to_max(draws) do
    Enum.reduce(draws, %{}, fn draw, outer_acc ->
      Enum.reduce(draw, outer_acc, fn {color, count}, inner_acc ->
        case Map.get(inner_acc, color, 0) do
          acc_count when acc_count > count -> inner_acc
          _ -> Map.put(inner_acc, color, count)
        end
      end)
    end)
  end

  defmodule Part1 do
    def parse_file(file, limits) do
      Day2.parse_file(file)
      |> Enum.map(fn game -> check_game(game, limits) end)
      |> Enum.sum()
    end

    def check_game({game_id, draws}, limits) do
      case game_possible?(draws, limits) do
        true -> game_id
        false -> 0
      end
    end

    def game_possible?(draws, limits) do
      max = Day2.reduce_draws_to_max(draws)

      Enum.all?(limits, fn {color, limit} ->
        Map.get(max, color, 0) <= limit
      end)
    end
  end

  defmodule Part2 do
    def parse_file(file) do
      Day2.parse_file(file)
      |> Enum.map(fn game -> game_to_min_power(game) end)
      |> Enum.sum()
    end

    def game_to_min_power({_game_id, draws}) do
      Day2.reduce_draws_to_max(draws)
      |> Enum.reduce(1, fn {_color, count}, acc ->
        acc * count
      end)
    end
  end
end

IO.puts("Advent of Code 2023; Day 2:")

part1_limits = %{
  "red" => 12,
  "green" => 13,
  "blue" => 14
}

example1_solution = Day2.Part1.parse_file("part1_example.txt", part1_limits)
IO.puts("Example 1 solution: #{inspect(example1_solution)}")

part1_solution = Day2.Part1.parse_file("input.txt", part1_limits)
IO.puts("Part 1 solution: #{inspect(part1_solution)}")

example2_solution = Day2.Part2.parse_file("part2_example.txt")
IO.puts("Example 2 solution: #{inspect(example2_solution)}")

part2_solution = Day2.Part2.parse_file("input.txt")
IO.puts("Part 2 solution: #{inspect(part2_solution)}")
