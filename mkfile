# dependencies include:
# 	*roff implementation with pic and soin
# 		(neatroff: github.com/aligrudi/neatroff_make)
# 	psutils (knackered.org/angus/psutils/index.html)
#	ghostscript (ghostscript.com)
# 	plan9 mk (9fans.github.io/plan9port/unix)

# q2 source files (one per planner, should end in .q2)
src=demo.q2 demo2.q2

# troff paths
prefix=/usr/local
roff=$prefix/bin/neatroff
post=$prefix/bin/neatpost
pic=$prefix/bin/9pic
soin=$prefix/bin/neatsoin
fdir=$prefix/share/neatroff

# ghostscript distillation and flags
psflags= -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sFONTPATH=$fdir/font -sFONTMAP=$fdir/font/Fontmap
ps2pdf=ps2pdf $psflags

dest=${src:%.q2=%.pdf}
imp=${src:%.q2=%.imp.pdf}

psbook=pstops -P69.8mmx107.9mm -p69.8mmx107.9mm \
-S16:14U(1w,1h),1U(1w,1h),2U(1w,1h),13U(1w,1h),9,6,5,10,\
12U(1w,1h),3U(1w,1h),0U(1w,1h),15U(1w,1h),11,4,7,8

all:V: $dest $imp

&.ps: &.q2 plan.so
	$soin <$stem.q2 | $pic | $roff | $post -p 698x1079 |
		ps2ps $psflags - - | psselect -R1-16 > $target

&.pdf: &.ps
	$ps2pdf $prereq $target

&.imp.pdf: &.ps
	$psbook $prereq | psnup -P69.8mmx107.9mm -p8.5inx11in -8 |
		$ps2pdf - $target

clean:V:
	rm -f *.ps *.pdf
