#!/bin/sh

dname=`pwd`;
echo "Using directory $dname";
echo "Vcheckout output files in .vcheck.out";
total=0;
bad=0;

for a in *.v; do
    outfile=`basename $a .v`".vcheck.out";
    ../vcheck.sh $a $outfile;


    NUMOFLINES=$(wc -l < "$outfile");
    NUMOFERRORS=$((NUMOFLINES - 1));

    total=$((total + 1));
    bad=$((bad + ($NUMOFERRORS > 0 ? 1 : 0)));
	

	if [ $NUMOFERRORS != 0 ]
        then
            echo "Checking file $a ($NUMOFERRORS Errors)"
        else
            echo "Checking file $a GOOD"
        fi

done

echo "Checked $total files, $bad bad files";