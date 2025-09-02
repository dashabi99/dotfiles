1:mkdir ~/dotfiles  把配置文件都放到这里用于统一管理
2:cd ~/dotfiles/目录下，建立自己需要的程序目录，比如nvim wezterm tmux等目录
3:把～下或者.config目录下的文件或者目录拷贝到dotfiles目录下的对应程序目录
    例如：cp -r ~/.config/nvim/ ~/dotfiles/nvim
          然后就可以删除原目录下的文件了，或者不放心先不删，把目录变成nvim_backup备份
4:建立链接
    例如:ln -s ~/dotfiles/nvim ~/.config/nvim
5:后面就可以在dotfiles目录里配置文件了
6:在根目录下的点文件
    例如：mv ~/.tmux.conf ~/dotfiles/tmux/
          ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
