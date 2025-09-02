#!/bin/bash

export PATH=$PATH #:/usr/local/bin:/opt/bin:/opt/homebrew/bin/

# Check if at least one PDF file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <pdf1> <pdf2> ... <pdfN>"
    echo "This script unites multiple PDFs and compresses them while preserving vector paths."
    exit 1
fi

# Sort filenames
#file_array=$@
#sorted_array=($(printf '%s\n' "${file_array[@]}" | sort -n))
#IFS=$'\n' sorted_array=($(sort -n <<< "{file_array[@]}"))
#unset IFS
#echo $sorted_array

# Validate that all arguments are PDF files
for f in "$@"; do
    if [[ ! -f "$f" ]]; then
        echo "Error: File '$f' does not exist"
        exit 1
    fi
    
    ext=$(echo "${f##*.}" | tr '[:upper:]' '[:lower:]')
    if [[ "$ext" != "pdf" ]]; then
        echo "Error: '$f' is not a PDF file"
        exit 1
    fi
done

# Get the directory of the first file for output location
first_file="$1"
parent=$(dirname "$first_file")
first_basename=$(basename "$first_file" .pdf)
output_united="${parent}/output.pdf"
output_final="${parent}/${first_basename}_combined_${#}_pages.pdf"

echo "Uniting ${#} PDF files..."
echo "Files to unite: $@"

# Unite all PDFs into one
if ! pdfunite "$@" "$output_united"; then
    echo "Error: Failed to unite PDF files"
    exit 1
fi

echo "United PDFs saved as: $output_united"
echo "Compressing with Ghostscript..."

# Compress with Ghostscript while preserving vector paths
# Using /prepress for better vector preservation than /ebook
if gs -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=/prepress \
        -dPreserveEPSInfo=true \
        -dPreserveOPIComments=true \
        -dPreserveHalftoneInfo=true \
        -dAutoRotatePages=/None \
        -dNOPAUSE \
        -dQUIET \
        -dBATCH \
        -sOutputFile="$output_final" \
        "$output_united"; then
    echo "Compressed PDF saved as: $output_final"
    
    # Clean up intermediate file on success
    rm "$output_united"
    echo "Cleanup complete. Final output: $output_final"
else
    echo "Error: Failed to compress PDF with Ghostscript"
    
    # Clean up intermediate file even on failure
    rm "$output_united"
    echo "Intermediate file cleaned up"
    exit 1
fi