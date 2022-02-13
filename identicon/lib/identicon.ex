defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @spec save_image(binary, binary) :: :ok | {:error, atom}
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  @spec draw_image(%Identicon.Image{}) :: binary
  def draw_image(image) do
    identicon = :egd.create(250, 250)
    fill = :egd.color(image.color)

    Enum.each(image.pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(identicon, start, stop, fill)
    end)

    :egd.render(identicon)
  end

  @spec build_pixel_map(%Identicon.Image{}) :: %Identicon.Image{}
  def build_pixel_map(image) do
     pixel_map = Enum.map(image.grid, fn {_code, index} ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}
      {top_left, bottom_right}
    end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @spec filter_odd_squares(%Identicon.Image{}) :: %Identicon.Image{}
  def filter_odd_squares(image) do
    grid = Enum.filter(image.grid, fn {code, _index} -> rem(code, 2) == 0 end)
    %Identicon.Image{image | grid: grid}
  end

  @spec build_grid(%Identicon.Image{}) :: %Identicon.Image{}
  def build_grid(image) do
    grid =
      image.hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  @spec mirror_row([...]) :: [...]
  def mirror_row(row) do
    [a, b | _c] = row
    row ++ [b, a]
  end

  @spec pick_color(%Identicon.Image{
          :color => nil,
          :hex => list
        }) :: %Identicon.Image{
          :color => {integer, integer, integer},
          :hex => list
        }
  def pick_color(%Identicon.Image{hex: [r, g, b | _]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @spec hash_input(binary) :: %Identicon.Image{}
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
