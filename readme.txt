一:使用dotfiles目录管理配置文件
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

二:把本地的dotfiles目录上传到github面
    cd ~/dotfiles  
    初始化git仓库，并重命名为main
        2:git init
        git branch -m main 
    把本地仓库与 GitHub 上的仓库链接
        git remote add origin https://github.com/<USERNAME>/<REPO>.git
        例如：git remote add origin https://github.com/dashabi99/dotfiles.git
    将所有文件添加到 Git，然后提交更改
        2:git add .
        3:git commit -m "first commit"
    提示输入邮箱和用户名（我选择的github的邮箱和名字）
        这个是全局配置用户身份信息
            git config --global user.email "you@example.com"
            git config --global user.name "Your Name"
        这个是仅为当前仓库设置用户身份信息
            git config user.email "you@example.com"
            git config user.name "Your Name"
    推送本地仓库到 GitHub
        git push -u origin main
    
