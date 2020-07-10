TTFDIR=../Fonts/ttf
VFDIR=../Fonts/ttf-variable
mkdir -p $TTFDIR
mkdir -p $VFDIR

# Build static instances
rm -r $TTFDIR/*.ttf
fontmake -g "../Sources/Petrona-ROMAN-MASTER.glyphs" -o ttf -i --output-dir $TTFDIR -a
fontmake -g "../Sources/Petrona-ITALIC-MASTER.glyphs" -o ttf -i --output-dir $TTFDIR -a
for f in $TTFDIR/*.ttf
do
	echo Processing $f
	gftools fix-dsig --autofix $f
	gftools fix-hinting $f
	mv $f.fix $f
done

# Build variable font
rm -r $VFDIR/*.ttf
set -e
VF_FILENAME="$VFDIR/Petrona[wght].ttf"
fontmake -g "../Sources/Petrona-ROMAN-MASTER.glyphs" -o variable --output-path $VF_FILENAME
VF_FILENAME="$VFDIR/Petrona-Italic[wght].ttf"
fontmake -g "../Sources/Petrona-ITALIC-MASTER.glyphs" -o variable --output-path $VF_FILENAME

for f in $VFDIR/*.ttf
do
	echo Processing $f
	gftools fix-dsig --autofix $f
	ttfautohint $f $f.fix
	mv $f.fix $f
	gftools fix-unwanted-tables $f
	gftools fix-hinting $f
	mv $f.fix $f
done

# Clean up
rm -r instance_ufo
rm -r master_ufo
