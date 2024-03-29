plattform="$(uname -s)"

if [ "$plattform" = "Linux" ]; then
    export PATH
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ "$plattform" = "Darwin" ]; then
    # MacOS spefic profile stuff
    PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
    export PATH
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="$PATH:/Users/tillwegener/.dotnet/tools"
fi
