install:
				brew install ctags-exuberant
				pip install -U pep8 flake8 pyflakes

config:
			 cp `pwd`/vimrc ~/.vimrc
			 @echo OK! Launch vim and it will try to install all plugins

update:
			 vim +BundleClean +BundleInstall! +qa
