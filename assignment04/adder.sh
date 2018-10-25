let num=0;
myNums=( "$@" );
for arg; do
    let num=$(( $num+$arg ));
done
echo $num;
