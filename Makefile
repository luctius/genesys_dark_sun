NAME=output/dark_sun_rpg.pdf output/dark_sun_rpg_swgdice.pdf

GIT_VERSION=$(shell git describe --abbrev=10 --dirty --always --tags)

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
	$(null)

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
	sed -i "s/Version.*\}/Version ${GIT_VERSION}\}/g" chapters/credits.tex
	rubber --into output -v --pdf $< || true
	mv $@ $@.big
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$@ $@.big output/character_sheet.pdf
	rm output/*.big
	#pdftk $@.big output/character_sheet.pdf cat output $@
output/dark_sun_rpg_swgdice.pdf: dark_sun_rpg_swgdice.tex $(FILES) output/character_sheet.pdf
	sed -i "s/Version.*\}/Version ${GIT_VERSION}\}/g" chapters/credits.tex
	rubber --into output -v --pdf $< || true
	mv $@ $@.big
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$@ $@.big #output/character_sheet.pdf
	rm output/*.big
	#pdftk $@.big output/character_sheet.pdf cat output $@
output/ds_specs.pdf: ds_specs.tex output/character_sheet.pdf #$(FILES)
	rubber --into output -v --pdf $< || true
	mv $@ $@.big
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPreserveAnnots=true -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $@.big
	rm output/*.big
output/ds_races.pdf: ds_races.tex output/character_sheet.pdf #$(FILES)
	rubber --into output -v --pdf $< || true
	mv $@ $@.big
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPreserveAnnots=true -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $@.big
	rm output/*.big
output/character_sheet.pdf: images/character_sheet.svg
	inkscape -z --file=$< --export-pdf=$@
upload: output/dark_sun_rpg_swgdice.pdf output/ds_specs.pdf output/ds_races.pdf
	for f in $^; do pdf2htmlEX --font-size-multiplier 1 --zoom 1 --external-hint-tool=ttfautohint --dest-dir output ./$$f; done
	scp output/*.pdf nas:/volume1/web/dokuwiki/data/media/darksun/
	scp output/*.html nas:/volume1/web/dokuwiki/
clean:
	rm -f output/*
distclean: clean
	rm -f output/*.aux
