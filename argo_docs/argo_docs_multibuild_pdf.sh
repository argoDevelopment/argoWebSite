# Writers PDF
echo "Building the Writers PDF..."
prince --javascript --input-list=../argo_docs_writers-pdf/prince-file-list.txt -o /Users/tjohnson/projects/documentation-theme-jekyll/argo_docs_writers_pdf.pdf;

# Designers PDF
echo "Building the Designers PDF ..."
prince --javascript --input-list=../argo_docs_designers-pdf/prince-file-list.txt -o /Users/tjohnson/projects/documentation-theme-jekyll/argo_docs_designers_pdf.pdf;

echo "All done."
echo "Now run . argo_docs_multibuild_web.sh"
