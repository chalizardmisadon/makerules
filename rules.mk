# program
PROG ?= outfile
VPATH	?= ../

# source files
OBJS	?= main
SRCDIR	?= ../

# declare compiler
CC		?= gcc
CFLAGS	?=
CFLAGS	+= -g

SRC := $(foreach obj, $(OBJS), $(SRCDIR)$(obj).c)
OBJ := $(foreach obj, $(OBJS), $(obj).o)
INC := $(foreach p, $(VPATH), -I$(p))

$(PROG):
	$(CC) $(CFLAGS) $(INC) -c $(SRC)
	$(CC) $(CFLAGS) -o $(PROG) $(OBJ)


.PHONY: list clean clean.o
list:
	@echo build project: $(PROG)

clean:
	rm -f $(OBJ) $(PROG)

clean.o:
	rm -f $(OBJ)

