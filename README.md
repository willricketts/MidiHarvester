# MidiHarvester

I love video game music. I especially love using video game music to compose other music. When I saw the post [Gameboy MUsic and Sound Archive For MIDI](https://news.ycombinator.com/item?id=38706914) on Hacker News this morning, I was stoked! Sadly, you have to download each MIDI file one at a time, and there isn't a "download all" button. I decided to put together a little program to do this for me, and then extended it to harvest all of the other MIDI files they have as well.

## Get started

```
mix deps.get
```

## Run the thing

Open an iEX shell with `iex -S mix`:

```
iex> MidiHarvester.run()
```

Sit back and watch it rain MIDI files
