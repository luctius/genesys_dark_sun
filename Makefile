NAME=output/dark_sun_rpg.pdf output/dark_sun_rpg_swgdice.pdf

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

all: output/dark_sun_rpg.pdf output/dark_sun_rpg_swgdice.pdf output/ds_races.pdf output/ds_specs.pdf
show_races: output/ds_races.pdf
	xdg-open $<
show_specs: output/ds_specs.pdf
	xdg-open $<
show: output/dark_sun_rpg_swgdice.pdf
	xdg-open $<
spell: $(NAME)
	find . -iname ".tex" -exec aspell --lang=en_US -t -c {} \;
output/dark_sun_rpg.pdf: docs/dark_sun_rpg.tex $(FILES)
	rubber -v --pdf $< ; mv -f *.aux *.log *.toc *.pdf output/
	mv $@ $@.big
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $@.big
	rm output/*.big
output/dark_sun_rpg_swgdice.pdf: docs/dark_sun_rpg_swgdice.tex $(FILES)
	rubber -v --pdf $< ; mv -f *.aux *.log *.toc *.pdf output/
	mv $@ $@.big
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $@.big
	rm output/*.big
output/ds_specs.pdf: docs/ds_specs.tex $(FILES)
	rubber -v --pdf $< ; mv -f *.aux *.log *.pdf output/
	mv $@ $@.big
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $@.big
	rm output/*.big
output/ds_races.pdf: docs/ds_races.tex $(FILES)
	rubber -v --pdf $< ; mv -f *.aux *.log *.pdf output/
	mv $@ $@.big
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $@.big
	rm output/*.big
clean:
	rm -f output/*.dvi output/*.log output/*.pdf output/*.toc
distclean: clean
	rm -f output/*.aux
