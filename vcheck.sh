#!/bin/sh

fullfilename() {

    # check to see if $1 exists
    if [ -e $1 ]; then
        B=`basename $1`
        P=`dirname $1`
        #  echo BASE:$B  PATH:$P
        pushd $P > /dev/null 2> /dev/null

        if [ `pwd` != "/" ]
        then
            FULLNAME=`pwd`/$B
        else
            FULLNAME=/$B
        fi

    else
        echo "Input file not found $1";
        exit -1
    fi

}


which java > /dev/null; retval=$?;

if [ $retval -eq 1 ]; then
    echo "ERROR: Cannot find java, email TA or instructor";
    exit -1;
fi

if [ $# -ne 2 ]; then
    echo "Incorrect usage: need to specify the assemble source verilog filename as first argument and output filename as 2nd argument";
    exit -1;
fi

fullfilename $1;
outfile=$2;
java -classpath /u/k/a/karu/public/html/courses/cs552/spring2013/handouts/verilog_code Vcheck $FULLNAME > $outfile;
exit;

