echo 'Killing all Jekyll instances'
kill -9 $(ps aux | grep '[j]ekyll' | awk '{print $2}')
clear


echo "Building PDF-friendly HTML site for argo_docs Writers ..."
jekyll serve --detach --config configs/argo_docs/config_writers.yml,configs/argo_docs/config_writers_pdf.yml
echo "done"

echo "Building PDF-friendly HTML site for argo_docs Designers ..."
jekyll serve --detach --config configs/argo_docs/config_designers.yml,configs/argo_docs/config_designers_pdf.yml
echo "done"

echo "All done serving up the PDF-friendly sites. Now let's generate the PDF files from these sites."
echo "Now run . argo_docs_2_multibuild_pdf.sh"