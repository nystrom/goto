function __goto_usage
    printf "\
 usage: goto [<option>] <alias> [<directory>]

 default usage:
    goto <alias> - changes to the directory registered for the given alias

 OPTIONS:
    -r, --register: registers an alias
      goto -r|--register <alias> <directory>
    -u, --unregister: unregisters an alias
      goto -u|--unregister <alias>
    -l, --list: lists aliases
      goto -l|--list
    -x, --expand: expands an alias
      goto -x|--expand <alias>
    -c, --cleanup: cleans up non existent directory aliases
      goto -c|--cleanup
    -v, --version: prints version
      goto -v|--version
    -h, --help: prints this help
      goto -h|--help\n"
end

function __goto_get_db
    if set -q GOTO_DB; and test -f "$GOTO_DB"
        echo "$GOTO_DB"
    else if set -q XDG_DATA_HOME; and test -d "$XDG_DATA_HOME"
        test -d "$XDG_DATA_HOME/goto"; or mkdir -p "$XDG_DATA_HOME/goto"
        test -f "$XDG_DATA_HOME/goto/db"; or touch -a "$XDG_DATA_HOME/goto/db"
        echo "$XDG_DATA_HOME/goto/db"
    else
        test -d "$HOME/.local/share/goto"; or mkdir -p "$HOME/.local/share/goto"
        test -f "$HOME/.local/share/goto/db"; or touch -a "$HOME/.local/share/goto/db"
        echo "$HOME/.local/share/goto/db"
    end
end

function __goto_register
    if test (count $argv) -lt 3
        echo 'usage: goto -r|--register <alias> <directory>'
        return 1
    end
    set acronym $argv[2]
    set directory $argv[3]

    if not test (string match -r '^[\d\w_-]+$' $acronym)
        echo "Invalid alias: '$acronym'. Alises can contain only letters, \
digits, hyphens and underscores."
        return 1
    end

    if not test -d $directory
        echo "Directory: '$directory' does not exists."
        return 1
    end

    if test (__goto_find_directory $acronym) != ''
        echo "Alias $acronym already exists."
        __goto_unregister $acronym
        if test $status -ne 0
            return 1
        end
    end

    echo -e $acronym\t(path resolve $directory) >> (__goto_get_db)
    if test $status -eq 0
        echo 'Alias $acronym successfully registered.'
    else
        echo 'Unable to register alias $acronym.'
        return 1
    end
end

function __goto_find_directory
    echo (string match -r "^$argv\s(.+)\$" < (__goto_get_db))[2]
end

function __goto_directory
    set directory (__goto_find_directory $argv)

    if test $directory = ""
        # If there's no alias, try to just `cd`.
        set directory $argv
    end

    cd $directory
    return $status
end

function __goto_list
    set len 0
    set db (__goto_get_db)
    for line in (cat $db)
        set acronym (string replace -r '\s.*' '' $line)
        set len (math -s 0 max $len, (string length $acronym))
    end
    for line in (sort -u $db)
        set acronym (string replace -r '\s.*' '' $line)
        set path (string replace -r '.*\s' '' $line)
        echo (string pad -r -w $len $acronym) $path
    end
end

function __goto_unregister
    if test (count $argv) -lt 2
        echo 'usage: goto -u|--unregister <alias>'
        return 1
    end
    set db (__goto_get_db)
    set acronym $argv[2]
    set tmp_db $HOME/.goto_tmp
    string match -r "^(?!$acronym\s).+" < $db > $tmp_db
    mv $tmp_db $db
    echo 'Alias $acronym successfully unregistered.'
end

function __goto_expand
    if test (count $argv) -lt 2
        echo 'usage: goto -x|--expand <alias>'
        return 1
    end
    echo (__goto_find_directory $argv[2])
end

function __goto_cleanup
    set db (__goto_get_db)
    set tmp_db $HOME/.goto_tmp
    touch $tmp_db
    for line in (cat $db)
        set acronym (string replace -r '\s.*' '' $line)
        set path (string replace -r '.*\s' '' $line)
        if test -e $path
            set path (path resolve $path)
        end
        if test -d $path
            echo $line >> $tmp_db
        else
            echo "Removing '$acronym'."
        end
    end
    sort -u $tmp_db > $db
    rm -f $tmp_db
end

function ___goto_version
    echo "1.2.2"
end

function __goto_find_aliases
    string match -r '.+?\s' < (__goto_get_db)
end

function goto -d 'quickly navigate to aliased directories'
    __goto_get_db > /dev/null
    if test (count $argv) -lt 1
        __goto_list
        return $status
    end
    switch $argv[1]
        case -r or --register
            __goto_register $argv
        case -u or --unregister
            __goto_unregister $argv
        case -l or --list
            __goto_list
        case -x or --expand
            __goto_expand $argv
        case -c or --cleanup
            __goto_cleanup
        case -h or --help
            __goto_usage
        case -v or --version
            ___goto_version
        case '*'
            __goto_directory $argv[1]
    end
    return $status
end

__goto_get_db > /dev/null
# goto completions
complete -c goto -x -n "test (count (commandline -opc)) -lt 2" -a "(__goto_find_aliases)"
complete -c goto -x -s u -l unregister -d "unregister an alias" -a "(__goto_find_aliases)"
complete -c goto -x -s x -l expand -d "expands an alias" -a "(__goto_find_aliases)"
complete -c goto -x -s r -l register -d "register an alias"
complete -c goto -x -s h -l help -d "prints help message"
complete -c goto -x -s l -l list -d "lists aliases"
complete -c goto -x -s c -l cleanup -d "deletes non existent directory aliases"
complete -c goto -x -s v -l version -d "prints version"
