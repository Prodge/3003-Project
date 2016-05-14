# Makefile for the CITS3003 project running on Linux
#
# Du Huynh
# April 2016

GCC_OPTIONS = -I ../../include -I ../../assimp-3.1.1/include/ \
	-w -fpermissive -O3 -g
GL_OPTIONS = -lglut -lGL -lXmu -lX11 -lm -Wl,-rpath,. -lGLEW

LIBRARY = -Wl,-rpath,. -L. -lassimp

OPTIONS=$(GCC_OPTIONS) $(GL_OPTIONS)

SHADER = InitShader.o
SHADER_SRC = ../../Common/InitShader.cpp
PROGRAM = scene-start
DIRT = $(wildcard *.o *.i *~ */*~ *.log assimp_log.txt)

RM = /bin/rm

# -------- rules for building programs --------

.PHONY: clean rmprogram clobber

default all: $(PROGRAM)

$(SHADER): $(SHADER_SRC)
	g++ -c $(SHADER_SRC) $(OPTIONS)

scene-start: scene-start.cpp gnatidread.h bitmap.o $(SHADER)
	g++ -o scene-start scene-start.cpp $(SHADER) bitmap.o $(OPTIONS) $(LIBRARY)

%.o: %.c 
	gcc -c $*.c $(OPTIONS)

# -------- rules for cleaning up files that can be rebuilt --------

clean:
	$(RM) -f $(DIRT)

rmprogram:
	$(RM) -f $(PROGRAM) $(INIT_SHADER)

clobber: clean rmprogram
