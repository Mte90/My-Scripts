#!/bin/bash
#Data una immagine la divide secondo le dimensioni per ottenere più versioni della stessa divisa
tile=1024
path=./esterno.jpg
size[0]="2330"
size[1]="4661"
size[2]="9323"

nnome=`basename $path`
ext=${nnome##*.}
name=${nnome%%.*}
i=0
count=0
diff=0
ctile=0
   if [ ! -d ./tmp ]; then
   mkdir ./tmp
   mkdir ./output
   fi
echo "Start batch process"
for version in ${size[@]}
do
cp $path ./$name-.$ext
i=$(expr $i + 1)
convert $name-.$ext -resize $version $name-.$ext
convert $name-.$ext -crop 1024x1024 +repage +adjoin ./tmp/$name-$i-%d.$ext
count=`ls ./tmp | wc -l`
ctile=$(expr $version / $tile)
ctile=$(expr $ctile + 1)
y=0
k=1
z=0
for (( z=1; z<=$count; z++ )); do
y=$(expr $y + 1)
pog=$(expr $z - 1)
#non parte da 1 ma da zero
mv ./tmp/$name-$i-$pog.$ext ./output/$name-$i-$k-$y.$ext
if [ "$y" = "$ctile" ]; then
y=0
k=$(expr $k + 1)
fi
done
echo "$i section OK"
done
echo "finish"
rm ./$name-.$ext