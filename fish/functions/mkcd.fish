function mkcd --argument-names folder --description "Create and immediately cd into folder"
 mkdir -p "$folder" && cd "$folder"
end
