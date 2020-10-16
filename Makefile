NAME=output/dark_sun_rpg.pdf output/dark_sun_rpg_swgdice.pdf

GIT_VERSION=$(shell git describe --abbrev=10 --dirty --always --tags)
MAX_PARALLEL=8
SERVER=nas
PDF_DEST=/volume1/web/dokuwiki/data/media/darksun/
HTML_DEST=/volume1/web/dokuwiki/

FILES= \
	lib/characters.sty \
	lib/dice.sty \
	lib/ds.sty \
	lib/sections.sty \
	lib/talent.sty \
	lib/tables.sty \
	chapters/* \
	items/* \
	items/qualities/* \
	items/attachments/* \
	specialisations/* \
	magic/spells/* \
	magic/psionics/* \
	races/* \
	talents/* \
	talents/psionic_powers/* \
	adversaries/* \
	images/* \
    output/version.tex \
	$(null)

.PHONY=upload multi multiupload clean spell
all: output/dark_sun_rpg.pdf output/dark_sun_rpg_swgdice.pdf output/ds_races.pdf output/ds_specs.pdf output/character_sheet.pdf
show_races: output/ds_races.pdf
	xdg-open $<
show_specs: output/ds_specs.pdf
	xdg-open $<
show: output/dark_sun_rpg_swgdice.pdf
	xdg-open $<
spell: $(FILES)
	aspell --lang=en_UK -t -c $(FILES)
check: dark_sun_rpg_swgdice.tex $(FILES) 
	pdflatex -halt-on-error -file-line-error -output-directory output $<
output/dark_sun_rpg.pdf: dark_sun_rpg.tex $(FILES) output/character_sheet.pdf
	make force_version
	rubber --into output -v --pdf $< || true
	mv $@ $@.tmp
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$@ $@.tmp output/character_sheet.pdf
	rm output/*.tmp
output/dark_sun_rpg.html: output/dark_sun_rpg.pdf
	pdf2htmlEX --font-size-multiplier 1 --zoom 1 --external-hint-tool=ttfautohint --dest-dir output $^
output/dark_sun_rpg_swgdice.pdf: dark_sun_rpg_swgdice.tex $(FILES) output/character_sheet.pdf
	make force_version
	rubber --into output -v --pdf $< || true
	mv $@ $@.tmp
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$@ $@.tmp
	rm output/*.tmp
output/dark_sun_rpg_swgdice.html: output/dark_sun_rpg_swgdice.pdf
	pdf2htmlEX --font-size-multiplier 1 --zoom 1 --external-hint-tool=ttfautohint --dest-dir output $^
output/ds_specs.pdf: ds_specs.tex output/character_sheet.pdf
	rubber --into output -v --pdf $< || true
	mv $@ $@.tmp
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPreserveAnnots=true -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $@.tmp
	rm output/*.tmp
output/ds_specs.html: output/ds_specs.pdf
	pdf2htmlEX --font-size-multiplier 1 --zoom 1 --external-hint-tool=ttfautohint --dest-dir output $^
output/ds_races.pdf: ds_races.tex output/character_sheet.pdf
	rubber --into output -v --pdf $< || true
	mv $@ $@.tmp
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPreserveAnnots=true -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $@.tmp
	rm output/*.tmp
output/ds_races.html: output/ds_races.pdf
	pdf2htmlEX --font-size-multiplier 1 --zoom 1 --external-hint-tool=ttfautohint --dest-dir output $^
output/character_sheet.pdf: images/character_sheet.svg
	inkscape -z --file=$< --export-pdf=$@
upload_pdf: output/dark_sun_rpg_swgdice.pdf output/ds_specs.pdf output/ds_races.pdf output/character_sheet.pdf
	scp $^ ${SERVER}:${PDF_DEST}
upload_html: output/dark_sun_rpg_swgdice.html output/ds_specs.html output/ds_races.html
	scp $^ ${SERVER}:${HTML_DEST}
upload: upload_pdf upload_html
force_version: output/version.tex
	if [ -z $(shell grep -o '\{.*\}' $<) ] || [ $(shell grep -o '\{.*\}' $<) != "{${GIT_VERSION}}" ]; then rm -f $< && make $<; fi
output/version.tex:
	echo "\\\\textbf{${GIT_VERSION}}" > output/version.tex
multi:
	$(MAKE) -j${MAX_PARALLEL} all
multiupload:
	$(MAKE) -j${MAX_PARALLEL} upload
clean:
	rm -f output/*
