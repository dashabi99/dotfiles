# 使用dotfiles目录管理配置文件及git操作

## 一、使用dotfiles目录管理配置文件

1. `mkdir ~/dotfiles` 把配置文件都放到这里用于统一管理
2. `cd ~/dotfiles/`目录下，建立自己需要的程序目录，比如nvim wezterm tmux等目录
3. 把~下或者.config目录下的文件或者目录拷贝到dotfiles目录下的对应程序目录
    - 例如：`cp -r ~/.config/nvim/ ~/dotfiles/nvim`
    - 然后就可以删除原目录下的文件了，或者不放心先不删，把目录变成nvim_backup备份
4. 建立链接
    - 例如：`ln -s ~/dotfiles/nvim ~/.config/nvim`
5. 后面就可以在dotfiles目录里配置文件了
6. 在根目录下的点文件
    - 例如：`mv ~/.tmux.conf ~/dotfiles/tmux/`
    - `ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf`
7. 在windows上链接文件
    - 使用powershell，不管用的话就使用管理员模式打开powershell
        - 例如目录：`New-Item -ItemType SymbolicLink -Path "C:\Users\<YourUsername>\AppData\Local\nvim" -Target "C:\Users\<YourUsername>\dotfiles\nvim"`
        - 例如文件：`New-Item -ItemType SymbolicLink -Path "C:\Users\<YourUsername>\.config\wezterm\wezterm.lua" -Target "C:\Users\<YourUsername>\dotfiles\wezterm\wezterm.lua"`

## 二、把本地的dotfiles目录上传到github --第一次初始化

1. `cd ~/dotfiles`
2. 初始化git仓库，并重命名为main
    ```bash
    git init
    git branch -m main #初始化本地仓库名字是master，重命名为main保持和github一致
3. 在github上创建一个仓库
    - 注意：千万不要添加readme.md文件，否则会报错。可以自己在本地写一个readme.md文件，然后上传
4. 使用sshkey验证登录
    - Windows：
        - 使用 Git Bash 或 Windows Terminal
          - ssh-keygen -t ed25519 -C "your-email@example.com-windows"
        - 密钥会保存在： C:\Users\YourName\.ssh\
        - 查看公钥： `cat ~/.ssh/id_ed25519.pub`
    - Linux：
    ssh-keygen -t ed25519 -C "your-email@example.com-linux"
        - 密钥会保存在 ~/.ssh/目录下
        - 查看公钥： `cat ~/.ssh/id_ed25519.pub`
    - 去github上添加sshkey
      - GitHub -> Settings -> SSH and GPG keys -> New SSH key
        - Key 1:
        - Title: "Windows PC"
          - 例如：Key: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... (Windows的公钥)
        - Key 2:
        - Title: "Linux Server"
          - 例如：Key: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... (Linux的公钥)
5. 把本地仓库与 GitHub 上的仓库链接
    - 使用token：
    `git remote add origin https://github.com/<USERNAME>/<REPO>.git`
      - 例如：`git remote add origin https://github.com/dashabi99/dotfiles.git`
    - 使用sshkey：
    `git remote add origin git@github.com:<USERNAME>/<REPO>.git`
        - 如果指令不管用可以直接 `git clone git@github.com:<USERNAME>/<REPO>.git`
    - 如果一开始用了token的仓库连接
      - `git remote set-url origin git@github.com:dashabi99/dotfiles.git`
    - 验证修改： `git remote -v`
6. 将所有文件添加到 Git，然后提交更改
    ```bash
    git add .
    git commit -m "first commit"
7. 提示输入邮箱和用户名（我选择的github的邮箱和名字）
    - 全局配置用户身份信息：
        ```bash
        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"
    - 仅为当前仓库设置用户身份信息：(建议选这个)
        ```bash
        git config user.email "you@example.com"
        git config user.name "Your Name"
8. 推送本地仓库到 GitHub: `git push -u origin main`

## 三、后续更新仓库以及从仓库拉取代码

- 拉取远程最新代码
    - `git pull origin main` #（推荐）

    - 或者分步操作
      - `git fetch origin`    # 获取远程更新
      - `git merge origin/main` # 合并到本地
- 推送本地代码到远程仓库
    1. 添加文件
        - 添加所有修改的文件`git add .`
        - 或添加特定文件`git add filename.txt`
        - 或交互式添加`git add -i`
    2. 提交文件
        - 提交并添加提交信息`git commit -m "描述你的修改内容"`
        - 或进入编辑器写详细提交信息`git commit`
    3. 推送到远程仓库
        - `git push origin main` # 或者`git push`也可以

    - 第一次推送可能需要设置上游分支
        -  `git push -u origin main`

## 四、git常用命令

- 查看所有分支（包括远程跟踪分支）
    - `git branch -a`

- 比较本地 main 和远程 main 的差异
    - `git diff main origin/main`

- 显示当前未提交的文件
    - `git status -v`

- 显示每次提交的commit
    - `git log --oneline --graph --all`

## 五、TODO
