NAME=dark_sun_rpg.pdf

MAIN_FILE=dark_sun_rpg.tex
FILES=$(MAIN_FILE) lib/dice.sty lib/skill.sty

all: $(NAME)
show: clean $(NAME)
	xdg-open $(NAME)
$(NAME): $(FILES)
	lualatex *.tex
clean: 
	rm -f *.aux  *.dvi  *.log  *.pdf
