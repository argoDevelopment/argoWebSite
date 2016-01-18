# Doc Writers
echo "Building the argo_docs Writers PDF ..."
prince --javascript --input-list=../doc_outputs/argo_docs/writers-pdf/prince-file-list.txt -o argo_docs/files/argo_docs_writers_pdf.pdf;
echo "done"

# Doc Designers
echo "Building argo_docs Designers PDF ..."
prince --javascript --input-list=../doc_outputs/argo_docs/designers-pdf/prince-file-list.txt -o argo_docs/files/argo_docs_designers_pdf.pdf;
echo "done"

echo "All done building the PDFs!"
echo "Now build the web outputs: . argo_docs_3_multibuild_web.sh"