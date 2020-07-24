# Sofs Breaks Blocks

This is my first game using [Ruby 2D](https://www.ruby2d.com/) lib!

## How to Play

Run the executable that is at the `build` dir.

```
$ .\build\app
```

Use the following keys:

* Arrow `left` and `right` to move
* `Space` to shoot
* `Esc` to close the game

## Development

You will need a **Ruby** environment that can build native extensions and the Ruby 2D gem.

```
$ gem install ruby2d
```

### Prebuild

```
$ rake prebuild
```

### Build

```bash
$ ruby2d build --all main-build.rb
```
