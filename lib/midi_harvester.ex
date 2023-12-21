defmodule MidiHarvester do
  @moduledoc """
  Documentation for `MidiHarvester`.
  """

  require Logger

  @platform_map %{
    nintendo: [
      "nes",
      "gameboy",
      "snes",
      "n64",
      "virtualboy",
      "gba",
      "gamecube",
      "ds",
      "3ds",
      "wii",
      "wiiu",
      "switch"
    ],
    sega: ["master", "genesis", "gamegear", "saturn", "dreamcast", "segacd", "32x"],
    sony: ["ps1", "ps2", "ps3", "ps4", "psp"],
    microsoft: ["xbox", "xbox360"]
  }
  @base_url "https://www.vgmusic.com/music/console"

  def run do
    File.rm_rf!("./files")
    File.mkdir_p!("./files")

    @platform_map
    |> Map.keys()
    |> Enum.map(fn x -> harvest(x) end)
  end

  defp harvest(platform) do
    Logger.info("#### Harvesting #{platform} midi files ####")

    File.mkdir_p!("./files/#{platform}")

    Enum.each(@platform_map[platform], fn x ->
      harvest_platform(platform, x)
    end)
  end

  defp harvest_platform(platform, console) do
    Logger.info("$$$$ Starting harvest for #{console} $$$$")

    File.mkdir_p!("./files/#{platform}/#{console}")

    target = "#{@base_url}/#{platform}/#{console}/"

    do_harvest(target, platform, console)
  end

  def do_harvest(target_url, platform, console) do
    target_url
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Floki.parse_document!()
    |> Floki.find("a")
    |> Enum.map(fn x -> Floki.attribute(x, "href") end)
    |> List.flatten()
    |> Enum.filter(fn x -> String.contains?(x, ".mid") end)
    |> Enum.map(fn x -> download_file(platform, console, x) end)
  end

  defp download_file(platform, console, file_name) do
    IO.puts("Downloading #{file_name}")

    url = "#{@base_url}/#{platform}/#{console}/#{file_name}"
    file = HTTPoison.get!(url)

    File.write!("./files/#{platform}/#{console}/#{file_name}", file.body)
  end
end
