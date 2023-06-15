#    rm function - Version 1.0.1
#    Copyright (C) 2023  Victor "dicelander" Sander
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Changelog
#
# v1.0.0 - 2023-06-02 - Initial version
# v1.0.1 - 2023-06-02 - Make it just echo a warning for 'trash' not being installed, instead of returning (thus preventing deletion completely)

rm() {
    if ! whence -p trash &> /dev/null; then
        echo "The 'trash' command does not appear to be installed."
        echo "Check instructions on https://github.com/ali-rantakari/trash to install"
    fi

    local ignore_warning=false
    local quiet_delete=false
    local recursive=false
    local end_of_options=false
    local options=()
    local files=()

    for arg in "$@"; do
        if [[ $end_of_options == false ]]; then
            case "$arg" in
                --ignore-warning) ignore_warning=true ;;
                --quiet-delete) quiet_delete=true ;;
                --) end_of_options=true; options+=("$arg") ;;
                -*) 
                    options+=("$arg")
                    [[ "$arg" == *r* || "$arg" == *R* ]] && recursive=true 
                    ;;
                *)
                    end_of_options=true
                    files+=("$arg")
                    ;;
            esac
        else
            files+=("$arg")
        fi
    done

    if $ignore_warning; then
        if $quiet_delete; then
            command rm "${options[@]}" "${files[@]}"
        else
            echo "Files and directories to be attempted for deletion:"
            for target in "${files[@]}"; do
                if [[ -d "$target" && $recursive == true ]]; then
                    find "$target" -print
                else
                    echo "$target"
                fi
            done
            echo -n "Are you sure you want to delete these files/directories? (yes/no) "
            read answer
            if [[ $(echo "$answer" | tr '[:upper:]' '[:lower:]') == "yes" ]]; then
                command rm "${options[@]}" "${files[@]}"
            else
                echo "Operation cancelled."
            fi
        fi
    else
        echo "Warning: 'rm' permanently deletes files. Use 'trash' instead."
        echo "To ignore this warning, use 'rm --ignore-warning [-f | -i] [-dIPRrvWx] file ...'."
        echo "To quietly delete without confirmation or file listing, use 'rm --ignore-warning --quiet-delete [-f | -i] [-dIPRrvWx] file ...'."
    fi
}