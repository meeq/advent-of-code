defmodule Day1 do
  defmodule Part1 do
    def parse_file(file) do
      file
      |> File.stream!()
      |> Enum.map(&parse_line/1)
      |> Enum.sum()
    end

    def parse_line(line) do
      digits =
        line
        |> String.replace(~r([^0-9]), "")
        |> String.split("", trim: true)

      first = List.first(digits)
      last = List.last(digits)
      String.to_integer(first <> last)
    end
  end

  defmodule Part2 do
    def parse_file(file) do
      file
      |> File.stream!()
      |> Enum.map(&parse_line/1)
      |> Enum.sum()
    end

    def parse_line(line) do
      digits = parse_digits(line, [])
      first = List.first(digits)
      last = List.last(digits)
      String.to_integer(first <> last)
    end

    defp parse_digits(<<>>, acc) do
      Enum.reverse(acc)
    end

    [
      {"1", "one"},
      {"2", "two"},
      {"3", "three"},
      {"4", "four"},
      {"5", "five"},
      {"6", "six"},
      {"7", "seven"},
      {"8", "eight"},
      {"9", "nine"}
    ]
    |> Enum.each(fn {digit, word} ->
      defp parse_digits(<<unquote(digit), rest::binary>>, acc) do
        parse_digits(rest, [unquote(digit) | acc])
      end

      defp parse_digits(<<unquote(word), rest_of_line::binary>>, acc) do
        # Allow overlapping matches by only consuming the first character
        <<_first_char::binary-size(1), rest_of_word::binary>> = unquote(word)

        parse_digits(
          <<rest_of_word::binary, rest_of_line::binary>>,
          [unquote(digit) | acc]
        )
      end
    end)

    defp parse_digits(<<"0", rest::binary>>, acc) do
      parse_digits(rest, ["0" | acc])
    end

    defp parse_digits(<<_::binary-size(1), rest::binary>>, acc) do
      parse_digits(rest, acc)
    end
  end
end

IO.puts("Advent of Code 2023; Day 1:")

example1_solution = Day1.Part1.parse_file("part1_example.txt")
IO.puts("Example 1 solution: #{inspect(example1_solution)}")

part1_solution = Day1.Part1.parse_file("input.txt")
IO.puts("Part 1 solution: #{inspect(part1_solution)}")

example2_solution = Day1.Part2.parse_file("part2_example.txt")
IO.puts("Example 2 solution: #{inspect(example2_solution)}")

part2_solution = Day1.Part2.parse_file("input.txt")
IO.puts("Part 2 solution: #{inspect(part2_solution)}")
