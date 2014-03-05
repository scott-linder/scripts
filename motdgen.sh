#! /bin/bash

# Small utility to help generate new motd's from cowsay and fortune.

# Boolean 'literals'
true; TRUE=$?
false; FALSE=$?

# Prompt for yes/no.
function prompt_bool() {
    local yes_regex="[yY].*"
    local input=""
    read -p "[yN]? " input
    [[ $input =~ $yes_regex ]]
}

echo "Choosing cow file..."

cowfile=""
chosen=$FALSE
until [[ $chosen -eq $TRUE ]] ; do
    cowsay -l
    read -p "(Cowfile)? " cowfile
    cowsay -f $cowfile $cowfile && prompt_bool
    chosen=$?
done

echo "Choosing fortune..."

fortune=""
chosen=$FALSE
until [[ $chosen -eq $TRUE ]] ; do
    fortune="$(fortune -a)"
    echo "$fortune"
    prompt_bool
    chosen=$?
done

motd="$(cowsay -f $cowfile $fortune)"
echo "Write final motd to /etc/motd ?"
echo "$motd"
if prompt_bool ; then
    sudo echo "$motd" >/etc/motd
fi
