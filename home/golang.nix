{ config, lib, pkgs, unstablePkgs, ... }:

let
  workGoScript = pkgs.writeScriptBin "go-work" ''
    #!${pkgs.bash}/bin/bash
    export GOPATH="$HOME/work/code/go"
    export GOBIN="$HOME/work/code/go/bin"
    export GOMODCACHE="$HOME/work/code/go/pkg/mod"
    export GO111MODULE="on"
    export GOPRIVATE="code.byted.org"
    export GONOPROXY="code.byted.org"
    export GONOSUMDB="code.byted.org"
    
    # 创建必要的目录
    mkdir -p "$GOPATH/bin" "$GOPATH/pkg" "$GOPATH/src"
    
    # 添加到 PATH
    export PATH="$GOBIN:$PATH"
    
    echo "已切换到工作 Go 环境：GOPATH=$GOPATH"
    
    # 如果有参数，则执行 go 命令
    if [ $# -gt 0 ]; then
      exec ${unstablePkgs.go}/bin/go "$@"
    else
      # 否则打开一个新的 shell
      exec $SHELL
    fi
  '';
  
  personalGoScript = pkgs.writeScriptBin "go-personal" ''
    #!${pkgs.bash}/bin/bash
    export GOPATH="$HOME/Code/go"
    export GOBIN="$HOME/Code/go/bin"
    export GOMODCACHE="$HOME/Code/go/pkg/mod"
    export GO111MODULE="on"
    
    # 创建必要的目录
    mkdir -p "$GOPATH/bin" "$GOPATH/pkg" "$GOPATH/src"
    
    # 添加到 PATH
    export PATH="$GOBIN:$PATH"
    
    echo "已切换到个人 Go 环境：GOPATH=$GOPATH"
    
    # 如果有参数，则执行 go 命令
    if [ $# -gt 0 ]; then
      exec ${unstablePkgs.go}/bin/go "$@"
    else
      # 否则打开一个新的 shell
      exec $SHELL
    fi
  '';
  
  switchGoEnvByDir = pkgs.writeScriptBin "switch-go-env" ''
    #!${pkgs.bash}/bin/bash
    if [[ "$PWD" == "$HOME/work"* ]]; then
      exec ${workGoScript}/bin/go-work
    else
      exec ${personalGoScript}/bin/go-personal
    fi
  '';
  
  # 将 "go" 更名为 "goenv"，避免与系统 go 冲突
  goenvScript = pkgs.writeScriptBin "goenv" ''
    #!${pkgs.bash}/bin/bash
    # 基于当前目录自动选择环境
    if [[ "$PWD" == "$HOME/work"* ]]; then
      exec ${workGoScript}/bin/go-work "$@"
    else
      exec ${personalGoScript}/bin/go-personal "$@"
    fi
  '';
  
in {
  home.packages = [
    workGoScript
    personalGoScript
    switchGoEnvByDir
    goenvScript
  ];
  
  home.file.".go-work-dirs".text = ''
    # 这个文件存储了 Go 工作环境的基本目录
    WORK_GOPATH=$HOME/work/code/go
    PERSONAL_GOPATH=$HOME/Code/go
  '';
  
  home.activation.setupGoDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/work/code/go/{bin,pkg,src}
    mkdir -p $HOME/Code/go/{bin,pkg,src}
  '';
}
