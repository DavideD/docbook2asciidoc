#!/bin/sh


REQUIRED_BASH_VERSION=3.0.0

if [[ $BASH_VERSION < $REQUIRED_BASH_VERSION ]]; then
  echo "You must use Bash version 3 or newer to run this script"
  exit
fi

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

convert()
{
  #rm -Rf $OUT_DIR
  mkdir -p $OUT_DIR

  CMD="find ~/sources/beanvalidation-spec/en -type f \\( -name \*.xml -and -not -name \*-docinfo.xml \\)"
  xmls=`eval $CMD`

  for xml in $xmls
  do
    output_filename=${xml/.$EXT/.$OEXT}
    output_filename=$OUT_DIR${output_filename#$SCAN_DIR}
    echo "Processing $xml -> $output_filename"
    CMD="java -jar $DIR/saxon9he.jar -xi -s:$xml -o:$output_filename -xsl:$DIR/d2a.xsl chunk-output=true"
    $CMD
  done
}

renamedoc()
{
  mv "/home/sanne/sources/beanvalidation-spec/sources/modules/$2.asciidoc" "/home/sanne/sources/beanvalidation-spec/sources/$2.asciidoc"
  rm "/home/sanne/sources/beanvalidation-spec/sources/$1.asciidoc"
  sed -i -- "s/$1/sources\/$2/g" /home/sanne/sources/beanvalidation-spec/sources/master.asciidoc
}

SCAN_DIR="/home/sanne/sources/beanvalidation-spec/en"
RECURSE="0"
EXT="xml"
OEXT="asciidoc"
OUT_DIR="/home/sanne/sources/beanvalidation-spec/sources"
convert
renamedoc pr01 license
renamedoc ch01 introduction
renamedoc ch02 whatsnew
renamedoc ch03 constraint-definition
renamedoc ch04 constraint-declaration-validation
renamedoc ch05 validation-api
renamedoc ch06 constraint-metadata
renamedoc ch07 builtin-constraints
renamedoc ch08 xml-descriptor
renamedoc ch09 exception
renamedoc ch10 integration
renamedoc appa terminology
renamedoc appb appendix-standardresolvermessages
renamedoc appc appendix-jpa
renamedoc appd changelog
rm -Rf /home/sanne/sources/beanvalidation-spec/sources/modules/
