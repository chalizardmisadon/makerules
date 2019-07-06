# program
PROG	?= outfile

# source files
VPATH	?= ../
OBJS	?= main

# declare compiler
CC		?= gcc
CFLAGS	?=
CFLAGS	+= -g
CFLAGS	+= -Wall


OBJ := $(foreach obj, $(OBJS), $(obj).o)

$(PROG): $(OBJ)
	$(CC) $(CFLAGS) -o $(PROG) $(OBJ)


.PHONY: list clean clean.o
list:
	@echo build project: $(PROG)

clean:
	rm -f $(OBJ) $(PROG)

clean.o:
	rm -f $(OBJ)

