dotfiles
==========

My dotfiles

- [vimrc](#vimrc)


## vimrc
The `.vimrc` most work based on [fisadev/fisa-vim-config](https://github.com/fisadev/fisa-vim-config). It works on OSX and Ubuntu/Linux.

Focus on `python`, `Node.js`, `Ruby` syntax, autocomplete...

#### Dependencies

For OSX use `brew` and for Ubuntu use `apt-get` to install `ctags-exuberant`

```sh
$ brew install ctags-exuberant
$ pip pep8 flake8 pyflakes
```

#### Installation

* Replace configuration files:

```sh
$ cp dotfiles/vimrc .vimrc
```

* Install plugins: Launch `vim` and it will try to install/\.
