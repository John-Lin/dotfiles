dotfiles
==========

A dotfile same development environment

- [vimrc](#vimrc)


## vimrc
The `.vimrc` most work based on [fisadev/fisa-vim-config](https://github.com/fisadev/fisa-vim-config). It works on OSX.

Focus on `python`, `Node.js`, `Ruby` syntax, autocomplete..

#### Dependencies

It will install `ctags-exuberant`, `pep8`, `flake8` and `pyflakes`.

```sh
$ make install
```

#### Installation

* Replace vim configuration files in home directory.

```sh
$ make config
```

* Install plugins: Launch `vim` and it will try to install plugins.
