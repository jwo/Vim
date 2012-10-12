export PATH=/usr/local/bin:/usr/local/sbin:$HOME/local/lib:$HOME/local/bin:$PATH
export AUTOTEST=true
export NODE_PATH=$HOME/local/lib/node_modules

function parse_git_branch () {
       git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
GRAY="\[\033[1;30m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"
NO_COLOUR="\[\033[0m\]"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion
rvm use default

PS1="$GREEN\u@machine$NO_COLOUR:\w:$LIGHT_GRAY\$(~/.rvm/bin/rvm-prompt i v g)$NO_COLOUR:$YELLOW\$(parse_git_branch)$NO_COLOUR\$ "

alias mate='open -a TextMate.app'

#rails () {
#  if [ -e script/server ]; then
#   echo "you are stupid and need to run script/whatever"
#   # hi ... you could change this to script/"$@", but I like to run "rails s" and that wasn't working
#  else
#    command rails "$@"
#  fi
#}
rails () {
  command rails "$@"
}


SSH_ENV="$HOME/.ssh/environment"

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    ssh-add
}

# test for identities
function test_identities {
    # test whether standard identities have been added to the agent already
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $? -eq 0 ]; then
        ssh-add
        # $SSH_AUTH_SOCK broken so we start a new proper agent
        if [ $? -eq 2 ];then
            start_agent
        fi
    fi
}

# check for running ssh-agent with proper $SSH_AGENT_PID
if [ -n "$SSH_AGENT_PID" ]; then
    ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
  test_identities
    fi
# if $SSH_AGENT_PID is not properly set, we might be able to load one from
# $SSH_ENV
else
    if [ -f "$SSH_ENV" ]; then
  . "$SSH_ENV" > /dev/null
    fi
    ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
        test_identities
    else
        start_agent
    fi
fi

export PATH=/usr/local/mysql/bin/:$PATH


# ACTUAL CUSTOMIZATION OH NOES!
#function minutes_since_last_commit {
#    now=`date +%s`
#    last_commit=`git log --pretty=format:'%at' -1`
#    seconds_since_last_commit=$((now-last_commit))
#    minutes_since_last_commit=$((seconds_since_last_commit/60))
#    echo $minutes_since_last_commit
#}
#grb_git_prompt() {
#    local g="$(__gitdir)"
#    if [ -n "$g" ]; then
#        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
#        if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
#            local COLOR=${RED}
#        elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
#            local COLOR=${YELLOW}
#        else
#            local COLOR=${GREEN}
#        fi
#        local SINCE_LAST_COMMIT="${COLOR}$(minutes_since_last_commit)m${NORMAL}"
#        # The __git_ps1 function inserts the current git branch where %s is
#        local GIT_PROMPT=`__git_ps1 "(%s|${SINCE_LAST_COMMIT})"`
#        echo ${GIT_PROMPT}
#    fi
#}
#PS1="\h:\W\$(grb_git_prompt) \u\$ "
#source /usr/local/etc/bash_completion.d/git-completion.bash

