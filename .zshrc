export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
[ -f "/Users/pilrymage/.ghcup/env" ] && source "/Users/pilrymage/.ghcup/env" # ghcup-env

export PATH="/usr/local/opt/perl/bin:$PATH"
export http_proxy=http://localhost:7890
export https_proxy=http://localhost:7890
alias config='/usr/bin/git --git-dir=/Users/pilrymage/.cfg/ --work-tree=/Users/pilrymage'
