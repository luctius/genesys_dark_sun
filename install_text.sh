#!/bin/sh
apt install texlive texlive-latex-extra pdflatex texlive-binaries texlive-luatex pgf rubber ttfautohint
cd /tmp && wget https://github.com/pdf2htmlEX/pdf2htmlEX/releases/download/v0.18.8.rc1/pdf2htmlEX-0.18.8.rc1-master-20200630-Ubuntu-eoan-x86_64.deb && sudo dpkg -i pdf2htmlEX-0.18.8.rc1-master-20200630-Ubuntu-eoan-x86_64.deb && cd -
#texlive-fonts-recommended  texlive-fonts-extra fonts-lmodern texlive-fonts-extra 
