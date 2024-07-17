#!/bin/zsh
set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Použití: $0 <složka> <nový_název> <počáteční_číslo>" >&2
    exit 1
fi

folder="$1"
new_name="$2"
start_number="$3"

if [[ ! -d "$folder" ]]; then
    echo "Složka '$folder' neexistuje." >&2
    exit 1
fi

# Získáme počet číslic v počátečním čísle
num_digits=${#start_number}

# Převedeme počáteční číslo na desítkové a odstraníme úvodní nuly
counter=$((10#$start_number))

# Použijeme nullglob v Zsh
setopt nullglob
for file in "$folder"/*; do
    if [[ -f "$file" ]]; then
        filename=${file:t}
        extension="${filename##*.}"
        # Formátujeme číslo s úvodními nulami podle počtu číslic v počátečním čísle
        formatted_counter=$(printf "%0${num_digits}d" $counter)
        new_filename="${new_name}${formatted_counter}.${extension}"
        if [[ "$file" != "$folder/$new_filename" ]]; then
            mv -- "$file" "$folder/$new_filename"
            echo "Přejmenováno: $file -> $new_filename"
            ((counter++))
        else
            echo "Přeskočeno (již má správný název): $file" >&2
        fi
    fi
done
unsetopt nullglob

echo "Přejmenování dokončeno."