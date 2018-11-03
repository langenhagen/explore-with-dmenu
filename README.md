# explore-with-dmenu
A fast and simple file explorer using `dmenu` (https://tools.suckless.org/dmenu/) written in bash.

Use the arrow-keys and type on the keyboard to find items and press <Enter> to navigate into folders
or to open files with their default applications. Press <ESC> to exit anytime without effect.

The project is structured as follows:
```
.
├── explore-with-dmenu.sh       Main program.
├── LICENSE                     License definition.
└── README.md                   You are here now.
```


## Installation
You can run the script `explore-with-dmenu.sh` directly on your console.
I recommend assigning a global keyboard shortcut (see below).


### Prerequisites & Dependencies
You need to have the utility `dmenu` installed on your system.
On Ubuntu, you can install it via:
```bash
apt install dmenu
```

On Mac OS, install `dmenu` preferrably with Homebrew:
```bash
brew install dmenu
```


## Running
Invoke the script to start dmenu:
```bash
./explore-with-dmenu.sh
```

A `dmenu` window will be drawn depicting some initial items. You can use the arrow keys to navigate
through the list of shown items. Typing on keyboard filters entries that do not contain the entered
substring. Press `<Enter>` for a selection. If a folder has been selected, `explore-with-dmenu.sh`
will open a new `dmenu` containing of the contents of the folder, including an option to open a
Terminal in that given directory, as well as options to open the current folder with a standard
file browser (`'.'`) or to step one folder-level up (`'..'`). Press `<ESC>` at anytime to exit.


## Using a Global Keyboard Shortcut

`explore-with-dmenu.sh` becomes handy when you assign it to a global keyboard shortcut
that you can trigger from anywhere in your graphical user interface.

On Ubuntu 18.04, you can go to:
`Settings` > `Devices` > `Keyboard` > `Keyboard Shortcuts` > `+`
There you can set a command's name, the path to the `explore-with-dmenu.sh` executable
and a key combination.


## Customizing

You may customize `explore-with-dmenu.sh` by adding a `.edmrc` file to your `${HOME}` directory.
`explore-with-dmenu.sh` sources this file at startup and interpretes its contents as bash.

There are 4 variables that `explore-with-dmenu.sh` takes into account:
- `selected_path`
- `choices`
- `open_command`
- `open_terminal_command`


`selected_path` represents the initial path `explore-with-dmenu.sh` is working on.
This path will be prepended to all paths denoted in the `choices` array. `selected_path` defaults
to `${HOME}`.


`choices` represents an array of initial items the user is represented by dmenu.
For instance:
```bash
choices=(
    '<open terminal here>'              # add this special item to open a terminal at $selected_path
    '.'                                 # add this special item to open $selected_path
    '..'                                # add this special item for traverse to the parent folder
    'path/to/some/often/used/folder'    # add subdolders of $selected_path like this
    'path/to/some/often/used/file.txt'  # add files in folders under $selected_path like this
    "$(ls ${selected_path})"            # Output of `ls` on the $selected_path
    )
```

The first 3 denoted items are special entries you may or may not add to your initial list of
choices:
- `'<open terminal here>'` adds an item that, when selected, will open a Terminal at the
  path given by `selected_path`. `'<open terminal here>'` is a special string.
- `'.'` reflects the current path, which is initially `selected_path`. Selecting this item makes
  `explore-with-dmenu.sh` open the `selected_path` with a default application, e.g. Finder.
- `'..'` denotes the upper level directory. This makes, on selection, `explore-with-dmenu.sh`
  enter the parent directory.

The 3 last entries in contain relative paths that will be prepended with the `selected_path`, i.e.
`${selected_path}/path/to/some/often/used/folder` `${selected_path}/path/to/some/often/used/file`
and all the immediate subdirectories and files of `selected_path`.

If not specified otherwise, `choices` defaults to:
```bash
choices=(
    '<open terminal here>'
    '.'
    '..'
    "$(ls ${selected_path})"
    )
```


`open_command` stores the command that shall be used to open a selected file or folder.
On Linux, it defaults to `'xdg-open'`. On Mac, it defaults to `'open'`.


`open_terminal_command` stores the command that shall be used to open a folder when
`<open terminal here>` is selected. This defaults to `open -a Terminal` on Mac OS and defaults to
`'gnome-terminal --working-directory='` on Linux. The latter would work on most Ubuntu systems but
break on most other systems by default, so change it to your needs.


## Contributing
Work on your stuff locally, branch, commit and modify to your heart's content.
At the moment, there is no origin for this git repository!
Happy coding!


## License
See LICENSE file.


## Related Software

Given that `dmenu` is such a great tool, the idea of writing an explorer with `dmenu` is not new.
please have a look into the following link for other browsers and other tools written with `dmenu`:
https://tools.suckless.org/dmenu/scripts/


## Known Issues

- On Linux, the default programs `xdg-open` and `gnome-terminal` that come e.g. with Ubuntu 18.04
  are a default prerequisite. That may not work with some OSes out of the box, but you can configure
  it via your .edmrc. No checks happen however.


## TODO

- upload to github
- make a nice gif animation and add it to the Readme or so for github.
- make it work with absolute paths in the array `choices`
- make it work with Web URLs in the array `choices`. At least, `xdg-open` can handle URLs
- make the script take a custom rc-file as a command line option
- print "usage" string, when `-h`, `--help` or wrong parameters are handed in
- maybe rename `explore-with-dmenu.sh` to `suckless-explore.sh`
