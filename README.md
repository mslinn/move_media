`move_media`
[![Gem Version](https://badge.fury.io/rb/move_media.svg)](https://badge.fury.io/rb/move_media)
===========

`move_media` moves files from Sony Camera memory cards to permanent storage.


## Installation

Modify the following and save as $HOME/.move_media:

```yaml
destination_images: /mnt/e/media/staging/THMBNL
destination_video: /mnt/e/media/staging/CLIP
drive: 'h:'
topic: sony
```

Install like this:
```
$ gem install move_media
```


## Usage
Check out this project, then run
```
$ bin/move_media
Moving 7.97 GB video from /mnt/h/PRIVATE/M4ROOT/CLIP/C0002.MP4 to /mnt/e/media/staging/CLIP/sony_2022-08-20_0000002.mp4
Moving thumbnail from /mnt/h/PRIVATE/M4ROOT/THMBNL/C0002T01.JPG to /mnt/e/media/staging/THMBNL/C0002.jpg
Moving 2.37 GB video from /mnt/h/PRIVATE/M4ROOT/CLIP/C0003.MP4 to /mnt/e/media/staging/CLIP/sony_2022-08-20_0000003.mp4
Moving thumbnail from /mnt/h/PRIVATE/M4ROOT/THMBNL/C0003T01.JPG to /mnt/e/media/staging/THMBNL/C0003.jpg
Moving 1.23 GB video from /mnt/h/PRIVATE/M4ROOT/CLIP/C0004.MP4 to /mnt/e/media/staging/CLIP/sony_2022-08-20_0000004.mp4
Moving thumbnail from /mnt/h/PRIVATE/M4ROOT/THMBNL/C0004T01.JPG to /mnt/e/media/staging/THMBNL/C0004.jpg
Moving 1.48 GB video from /mnt/h/PRIVATE/M4ROOT/CLIP/C0005.MP4 to /mnt/e/media/staging/CLIP/sony_2022-08-20_0000005.mp4
```


## Additional Information
More information is available on
[Mike Slinn&rsquo;s website](https://www.mslinn.com/av_studio/210-sony-a7iii.html).


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

To release a new version:

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
