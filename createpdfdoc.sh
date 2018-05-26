# This script scans a number of documents (in A4 format) from the automatic document feeder (see variable source) with 150 dpi and 
# adds a OCR layer to it and
# creates a pdf document including all pages.
# So far created and now tested for a Brother MFC scanner.
### begin configuration ###

### language for OCR ###
LANG=deu

### scanner identification ###
SCANSOURCE="Automatic Document Feeder(left aligned)" 

### end of configuration ###

shopt -s nullglob

mkdir tmp

cd tmp
scanimage -p --format pnm -x 210.06 -y 296.73 --batch="page%03d.pnm" --mode "24bit Color" --resolution 150 --source "$SCANSOURCE"
myresult=$?
fileslist=`ls *pnm`
#echo "$fileslist"

for filename in $fileslist
do
        echo "Running OCR on $filename"
	newfilename=`basename $filename pnm`jpg
        tesseract --psm 1 -l $LANG $filename $newfilename pdf
done

echo "Joining files into single PDF..."
pdfunite *.pdf ../$1.pdf

cd ..
#rm -R tmp
echo "--- created file $1.pdf [return value: $myresult] ---"
okular $1.pdf

