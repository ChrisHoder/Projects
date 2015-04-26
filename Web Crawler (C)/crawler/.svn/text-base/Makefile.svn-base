CC = gcc
CFLAGS = -Wall -g -pedantic -std=c99
EXEC = crawler
OBJS = crawler.o extractURLs.o getAddressFromTheLinksToBeVisited.o getPage.o inputCheck.o setURLasVisited.o updateListLinkToBeVisited.o cleanup.o
SRCS = ./Functions/crawler.c ./Functions/extractURLs.c ./Functions/getAddressFromTheLinksToBeVisited.c ./Functions/getPage.c ./Functions/inputCheck.c ./Functions/setURLasVisited.c ./Functions/updateListLinkToBeVisited.c ./Functions/cleanup.c
UTILDIR=../utl/
UTILFLAG=-ltseutl
UTILLIB=$(UTILDIR)libtseutl.a
UTILC=$(UTILDIR)hash.c $(UTILDIR)html.c $(UTILDIR)dictionary.c $(UTILDIR)file.c
UTILH=$(UTILC:.c=.h)
# Commands start with TAB not spaces
$(EXEC): $(OBJS) $(UTILLIB) $(UTILDIR)header.h
	$(CC) $(CFLAGS) -o $(EXEC) $(OBJS) -L$(UTILDIR) $(UTILFLAG)
$(OBJS): $(SRCS)
	$(CC) $(CFLAGS) -c $(SRCS)

$(UTILLIB): $(UTILC) $(UTILH)
	cd $(UTILDIR); make;

debug: $(SRCS) 
	$(CC) $(CFLAGS) -g -ggdb -c $(SRCS)
	$(CC) $(CFLAGS) -g -ggdb -o $(EXEC) $(OBJS) -L$(UTILDIR) $(UTILFLAG)
clean:
	rm -f *~
	rm -f *#
	rm -f *.o


