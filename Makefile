# Copyright (c) 2022-2023, The Kryptokrona Developers
#
# Created by Marcus Cvjeticanin
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of
# conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list
# of conditions and the following disclaimer in the documentation and/or other
# materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
# THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# target
BINARY=Hugin

# directories
CODEDIRS=. account wallet db core crypto daemon http util
INCDIRS=. account wallet db common config core crypto daemon http util
BUILDDIR = build
EXTERNALDIR = external

# compiler
CC=gcc
OPT=-00

# flags
DEPFLAGS=-MP -MD
CFLAGS=-Wall -Wextra -DLOG_USE_COLOR -DSQLITE_HAS_CODEC -g $(foreach D,$(INCDIRS),-I$(D)) $(DEPFLAGS)
DYNAMIC_LINK_FLAGS=-lsqlite3 -lncurses -lform

# files
CFILES=$(foreach D,$(CODEDIRS),$(wildcard $(D)/*.c))
OBJECTS=$(patsubst %.c,$(BUILDDIR)/%.o,$(CFILES))
DEPFILES=$(patsubst %.c,$(BUILDDIR)/%.d,$(CFILES))

all: $(BINARY)

$(BINARY): $(OBJECTS)
	@echo "-- BUILDING HUGIN TARGET"
	$(CC) -o $(BUILDDIR)/$@ $^ $(DYNAMIC_LINK_FLAGS)

$(BUILDDIR)/%.o: %.c
	@echo "-- COMPILING SOURCE $< INTO OBJECT $@"
	@mkdir -p ${dir $@}
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	@echo "-- CLEANING PROJECT"
	rm -rf $(BINARY) $(OBJECTS) $(DEPFILES)
	rm -rf $(BUILDDIR)

distribute: clean
	@echo "-- DISTRIBUTE PROJECT"
	tar zcvf dist.tgz *

diff:
	$(info The status of the repository, and the volume per-file changes:)
	@git status
	@git diff --stat

# include the dependencies
-include $(DEPFILES)

.PHONY: all clean distribute diff