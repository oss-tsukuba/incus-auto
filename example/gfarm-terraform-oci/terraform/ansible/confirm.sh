#!/bin/bash

read -p "Do you want to continue? [Yes/No]: " answer
case ${answer:0:1} in
    y|Y)
        exit 0
    ;;
    *)
        echo "Aborted."
        exit 1
    ;;
esac
