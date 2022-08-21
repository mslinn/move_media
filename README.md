`move_media`
[![Gem Version](https://badge.fury.io/rb/move_media.svg)](https://badge.fury.io/rb/move_media)
===========

`move_media` moves files from Sony Camera memory cards to permanent storage.

## Usage

```
move_media
```


## Installation

Modify the following and save as $HOME/.move_media:

```yaml
source: /mnt/h
destination: /mnt/e/media/staging
```

Install like this:
```
$ gem install move_media
```

## Additional Information
More information is available on
[Mike Slinn&rsquo;s website](https://www.mslinn.com/blog/2020/10/03/jekyll-plugins.html).


## Development

After checking out the repo, run `bin/setup` to install dependencies.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.


### Build and Install Locally
To build and install this gem onto your local machine, run:
```shell
$ rake install:local
```

The following also does the same thing:
```shell
$ bundle exec rake install
move_media 0.1.0 built to pkg/move_media-0.1.0.gem.
move_media (0.1.0) installed.
```

Examine the newly built gem:
```
$ gem info move_media

*** LOCAL GEMS ***

move_media (0.1.0)
    Author: Mike Slinn
    Homepage:
    https://github.com/mslinn/move_media
    License: MIT
    Installed at: /home/mslinn/.gems

    Moves files from Sony Camera memory cards to permanent storage
```


### Build and Push to RubyGems
To release a new version,
  1. Update the version number in `version.rb`.
  2. Commit all changes to git; if you don't the next step might fail with an unexplainable error message.
  3. Run the following:
     ```shell
     $ bundle exec rake release
     ```
     The above creates a git tag for the version, commits the created tag,
     and pushes the new `.gem` file to [RubyGems.org](https://rubygems.org).


## Contributing

1. Fork the project
2. Create a descriptively named feature branch
3. Add your feature
4. Submit a pull request


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
