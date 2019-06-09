.SUFFIXES: .cpp

#for sgi   -- comment out the lines below to use on HP
#CC=CC -g0 -o32
#CC=gcc

# Compiler options
OPTS=-g
OPTS=-O0
#OPTS=-O2

UNAME = $(shell uname)

CPPFLAGS+=-std=c++11

ifeq ($(UNAME), Linux)
CXX      ?= g++
CPPFLAGS += $(OPTS) -Wall -pedantic
LIBGL     = -lGLU -lGL
LIBS      = -lXmu -lXext -lX11 -lXi -lm

# One of the following options only...

# (1) OpenGLUT
# LIBGLUT   = -L/usr/X11R6/lib -lopenglut
# CPPFLAGS += -I/usr/X11R6/include -DGLUI_OPENGLUT

# (2) FreeGLUT
# LIBGLUT   = -L/usr/X11R6/lib -lfreeglut
# CPPFLAGS += -I/usr/X11R6/include -DGLUI_FREEGLUT

# (3) GLUT
LIBGLUT   = -L/usr/X11R6/lib -lglut
CPPFLAGS += -I/usr/X11R6/include
endif

ifeq ($(UNAME), Darwin)
CXX      ?= g++
CPPFLAGS += $(OPTS) -Wall -pedantic
LIBGL     = -framework OpenGL
LIBGLUT   = -framework GLUT
endif

#######################################

CPPFLAGS += -I./src -I./include

LIBGLUI = -L./lib -lglui

#######################################

GLUI_SRC = $(sort $(wildcard src/*.cpp))
GLUI_OBJ := $(patsubst %.cpp,%.o,$(GLUI_SRC))

GLUI_LIB = lib/libglui.a

GLUI_EXAMPLES = bin/example1 bin/example2 bin/example3 bin/example4 bin/example5 bin/example6

GLUI_TOOLS = bin/ppm2array

.PHONY: all setup examples tools clean depend doc doc-pdf doc-dist dist

all: setup $(GLUI_LIB) examples tools

setup:
	mkdir -p bin
	mkdir -p lib

examples: $(GLUI_EXAMPLES)

tools: $(GLUI_TOOLS)

bin/ppm2array: tools/ppm2array.cpp tools/ppm.cpp
	$(CXX) $(CPPFLAGS) -o $@ $^

bin/%: example/%.cpp $(GLUI_LIB)
	$(CXX) $(CPPFLAGS) -o $@ $<  $(LIBGLUI) $(LIBGLUT) $(LIBGL) $(LIBS)

$(GLUI_LIB): $(GLUI_OBJ)
	ar -r $(GLUI_LIB) $(GLUI_OBJ)

.cpp.o:
	$(CXX) $(CPPFLAGS) -c $< -o $@

.c.o:
	$(CXX) $(CPPFLAGS) -c $< -o $@

docs:
	doxygen doc/doxygen.cfg

clean:
	rm -f $(GLUI_OBJ) $(GLUI_LIB) $(GLUI_EXAMPLES) $(GLUI_TOOLS) 
	rm -fr doc/doxygen

depend:
	makedepend -Y./include `find -name "*.cpp"` `find -name "*.c"`

DIST = glui-2.35

doc:
	doxygen doc/doxygen.cfg

doc-pdf:
	cd doc/doxygen/latex &&	pdflatex refman.tex && pdflatex refman.tex && pdflatex refman.tex

doc-dist:
	mkdir -p $(DIST)/doc
	cp `find doc/doxygen/html -type f` $(DIST)/doc
	tar cv $(DIST) | gzip -9 - > $(DIST)-doc.tgz
	zip -vr9 $(DIST)-doc.zip $(DIST)
	rm -Rf $(DIST)
	
dist: clean
	mkdir -p $(DIST) 
	cp --parents \
		`find -type f -name "*.cpp"` \
		`find -type f -name "*.c"` \
		`find -type f -name "*.h"` \
		`find -type f -name "*.dev"` \
		`find -type f -name "*.dsp"` \
		`find -type f -name "*.dsw"` \
		`find -type f -name "*.vcproj"` \
		`find -type f -name "*.sln"` \
		`find -type f -name "*.txt"` \
		makefile \
		$(DIST)
	tar cv $(DIST) | gzip -9 - > $(DIST).tgz
	rm -Rf $(DIST)

# DO NOT DELETE THIS LINE -- make depend depends on it.

./algebra3.o: algebra3.h glui_internal.h
./arcball.o: arcball.h glui_internal.h algebra3.h quaternion.h
./glui_button.o: ./include/GL/glui.h glui_internal.h
./glui_checkbox.o: ./include/GL/glui.h glui_internal.h
./glui_column.o: ./include/GL/glui.h glui_internal.h
./glui_control.o: ./include/GL/glui.h glui_internal.h
./glui_edittext.o: ./include/GL/glui.h glui_internal.h
./glui_listbox.o: ./include/GL/glui.h glui_internal.h
./glui_mouse_iaction.o: ./include/GL/glui.h glui_internal.h
./glui_node.o: ./include/GL/glui.h glui_internal.h
./glui_panel.o: ./include/GL/glui.h glui_internal.h
./glui_radio.o: ./include/GL/glui.h glui_internal.h
./glui_rollout.o: ./include/GL/glui.h glui_internal.h
./glui_rotation.o: ./include/GL/glui.h arcball.h glui_internal.h algebra3.h
./glui_rotation.o: quaternion.h
./glui_separator.o: ./include/GL/glui.h glui_internal.h
./glui_spinner.o: ./include/GL/glui.h glui_internal.h
./glui_translation.o: ./include/GL/glui.h glui_internal.h algebra3.h
./glui_window.o: ./include/GL/glui.h glui_internal.h
./quaternion.o: quaternion.h algebra3.h glui_internal.h
./viewmodel.o: viewmodel.h algebra3.h ./include/GL/glui.h
./glui_bitmaps.o: ./include/GL/glui.h glui_internal.h
./glui_statictext.o: ./include/GL/glui.h glui_internal.h
./glui.o: ./include/GL/glui.h glui_internal.h
./glui_add_controls.o: ./include/GL/glui.h glui_internal.h
./glui_commandline.o: ./include/GL/glui.h glui_internal.h
./glui_list.o: ./include/GL/glui.h glui_internal.h
./glui_scrollbar.o: ./include/GL/glui.h glui_internal.h
./glui_string.o: ./include/GL/glui.h
./glui_textbox.o: ./include/GL/glui.h glui_internal.h
./glui_tree.o: ./include/GL/glui.h glui_internal.h
./glui_treepanel.o: ./include/GL/glui.h
./example/example1.o: ./include/GL/glui.h
./example/example2.o: ./include/GL/glui.h
./example/example3.o: ./include/GL/glui.h
./example/example4.o: ./include/GL/glui.h
./example/example5.o: ./include/GL/glui.h
./example/example6.o: ./include/GL/glui.h
./tools/ppm2array.o: ./tools/ppm.hpp
./glui_filebrowser.o: ./include/GL/glui.h glui_internal.h