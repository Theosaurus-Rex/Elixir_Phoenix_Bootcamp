defmodule KitchenCalculator do
  @conversion_table %{
    milliliter: 1,
    cup: 240,
    fluid_ounce: 30,
    teaspoon: 5,
    tablespoon: 15
  }

  def get_volume({_unit, number}),  do: number

  def to_milliliter({unit, number}) do
    {:milliliter, @conversion_table[unit] * number}
  end

  def from_milliliter({:milliliter, number}, unit) do
    {unit, number / @conversion_table[unit]}
  end

  def convert(volume_pair, unit) do
    volume_pair
    |> to_milliliter()
    |> from_milliliter(unit)
  end
end
