CC = gcc
CFLAGS = -Wall -pedantic -std=c99
CFLAGS1 = -ggdb -Wall
EXEC = indexer
OBJS = getFiles.o indexer.o List.o saveFile.o
SRCS = indexer.c List.c saveFile.c
UTILDIR=../utl/
UTILFLAG=-ltseutl
UTILLIB=$(UTILDIR)libtseutl.a
UTILC=$(UTILDIR)hash.c $(UTILDIR)html.c $(UTILDIR)dictionary.c $(UTILDIR)file.c
UTILH=$(UTILC:.c=.h)
$(EXEC): $(OBJS) $(UTILLIB) $(UTILDIR)header.h
	$(CC) $(CFLAGS) -o $(EXEC) $(OBJS) -L$(UTILDIR) $(UTILFLAG)
$(OBJS): $(SRCS)
	$(CC) $(CFLAGS) -c $(SRCS)
	$(CC) $(CFLAGS1) -c getFiles.c

$(UTILLIB): $(UTILC) $(UTILH)
	cd $(UTILDIR); make;

debug: $(SRCS) 
	$(CC) $(CFLAGS) -g -ggdb -c $(SRCS)
	$(CC) $(CFLAGS1) -g -ggdb -c getFiles.c
	$(CC) $(CFLAGS) -g -ggdb -o $(EXEC) $(OBJS) -L$(UTILDIR) $(UTILFLAG)
clean:
	rm -f *~
	rm -f *#
	rm -f ./prs
	rm -f *.o


