linton.vim
==========

My Vim setting.		

##Requirement
    
- Setup up [Vundle](https://github.com/gmarik/Vundle.vim):
   
   		$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

- Install cscope catges package [Optional]
		
		$ sudo apt-get install cscope exuberant-ctags -y

- Install pycscope from pip [Optional]
		
		$ sudo pip install pycscope

##Usage

* Clone my vim setting:
	
		$ git clone https://github.com/John-Lin/linton.vim.git

* Configure Plugins:
 	
	- Replace `.vimrc` to `vimrc`
    		
			$ cd
			$ cp linton.vim/vimrc .vimrc


	- Put the `colors` directory into your Vim directory (e.g. `~/.vim/colors`)
    			
    		$ cd 
	 		$ cp -r linton.vim/colors ~/.vim
	 		
* Install Plugins:
    Launch `vim` and run `:PluginInstall`
