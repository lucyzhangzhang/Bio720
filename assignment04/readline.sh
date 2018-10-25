while read line; do
    echo -ne "$line\n\n";
done < $1
