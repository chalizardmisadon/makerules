# ------------------------------------------------
# Generic makefile
# ------------------------------------------------

# ----- default project --------------- #
PROGDIR ?= ../
PROG    ?= $(notdir $(realpath $(PROGDIR)))

# ----- default main --------------- #
VPATH ?= $(PROGDIR)
OBJS  ?= main

# ----- compiler binaries --------------- #
CC  ?= gcc
CXX ?= g++

# ----- build flags --------------- #
CFLAGS ?=
CFLAGS += -g
CFLAGS += -Wall

CXXFLAGS ?=
CXXFLAGS += $(CFLAGS)

# ----- object list --------------- #
OBJ := $(foreach obj, $(OBJS), $(obj).o)

# ----- build rules --------------- #
$(PROG): $(OBJ)
	$(CC) $(CFLAGS) -o $(PROG) $(OBJ)

# ----- PHONY --------------- #
.PHONY: list clean clean.o m multi

# ----- build rules --------------- #
m: multi
multi:
	$(MAKE) -j$(shell nproc)
list:
	@echo build project: $(PROG)
clean:
	rm -f $(OBJ) $(PROG)
clean.o:
	rm -f $(OBJ)

