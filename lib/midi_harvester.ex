defmodule MidiHarvester do
  @moduledoc """
  Documentation for `MidiHarvester`.
  """

  @target "https://www.vgmusic.com/music/console/nintendo/gameboy/"

  def run do
    parsed =
      @target
      |> HTTPoison.get!()
      |> Map.get(:body)
      |> Floki.parse_document!()

    parsed
    |> Floki.find("a")
    |> Enum.map(fn x -> Floki.attribute(x, "href") end)
    |> List.flatten()
    |> Enum.filter(fn x -> String.contains?(x, ".mid") end)
    |> Enum.map(fn x -> download_file(x) end)

    :ok
  end

  defp download_file(file_name) do
    IO.puts("Downloading #{file_name}")

    url = "#{@target}#{file_name}"
    file = HTTPoison.get!(url)

    File.write!("./files/#{file_name}", file.body)
  end
end
