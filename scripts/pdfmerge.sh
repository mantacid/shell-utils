#!/bin/bash

POSITIONAL_ARGS=()

if [[ $# -eq 0 ]]; then
  echo "pdfmerge expects an output file given through -o or --output, as well as a list of PDFs to concatenate to eachother."
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case $1 in 
    -o|--output)
      OUTPUT_FILE="$2"
      shift 2
    ;;
    -*|--*)
      echo "Unknown option: $1"
      exit 1
    ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
  ;;
  esac
done
type gs && gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile="$OUTPUT_FILE" "${POSITIONAL_ARGS[@]}"
