files=(files.a* files.b* files.c*);
folder=("1" "2" "3");
for ((i=0; i<${#files[@]}; i+=1)); do
    mv ${files[i]} ${folder[i]};
done
