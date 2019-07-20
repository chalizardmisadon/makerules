# program
PROGDIR ?= ../
PROG	?= $(notdir $(realpath $(PROGDIR)))

# source files
VPATH	?= $(PROGDIR)
OBJS	?= main

# declare compiler
CC		?= gcc
CXX		?= g++

# default compile flags
CFLAGS	?=
CFLAGS	+= -g
CFLAGS	+= -Wall

CXXFLAGS ?=
CXXFLAGS += $(CFLAGS)


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

