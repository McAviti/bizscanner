LANG=deu
shopt -s nullglob


mkdir tmp
cd tmp
scanimage -p --format pnm --batch="page%03d.pnm" -x 210.06 -y 296.73 --mode "24bit Color" --resolution 150 --source "Automatic Document Feeder(left aligned)"
fileslist=`ls -X *pnm|cat`
pagenr=1
for filename in $fileslist
do
        newfilename=`printf page%03d.jpg $pagenr`
        pagenr=`expr $pagenr + 2`
        echo "Running OCR on $filename, creating $newfilename."
        tesseract --psm 1 -l $LANG $filename $newfilename pdf
done
rm *.pnm
echo "Please turn stack of pages and press <return>"
read
scanimage -p --format pnm --batch="page%03d.pnm" -x 210.06 -y 296.73 --mode "24bit Color" --resolution 150 --source "Automatic Document Feeder(left aligned)"
fileslist=`ls -X *pnm|cat`
pagenr=`expr $pagenr - 1`
for filename in $fileslist
do
	newfilename=`printf page%03d.jpg $pagenr`
	pagenr=`expr $pagenr - 2`
        echo "Running OCR on $filename, creating $newfilename."
        tesseract --psm 1 -l $LANG $filename $newfilename pdf
done

echo "Joining files into single PDF..."
pdfunite *.pdf ../$1.pdf
cd ..
rm -R tmp
echo "--- created file $1.pdf ---"
okular $1.pdf

