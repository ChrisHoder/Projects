CC = gcc
CFLAGS = -Wall -g -pedantic -std=c99
EXEC = Query_Engine
OBJS = getDocList.o getList.o getWord.o printList.o Query_Engine.o sortList.o
SRCS =  getDocList.c getList.c getWord.c printList.c Query_Engine.c sortList.c QueryEngine.h
UTILDIR=../utl/
UTILFLAG=-ltseutl
UTILLIB=$(UTILDIR)libtseutl.a
UTILC=$(UTILDIR)hash.c $(UTILDIR)html.c $(UTILDIR)dictionary.c $(UTILDIR)file.c
UTILH=$(UTILC:.c=.h)
SRCS1 = query_test.c getDocList.c getList.c getWord.c sortList.c QueryEngine.h
EXEC1 = query_test
OBJS1 = query_test.o getDocList.o getList.o getWord.o sortList.o
# Commands start with TAB not spaces
$(EXEC): $(OBJS) $(UTILLIB) $(UTILDIR)header.h
	$(CC) $(CFLAGS) -o $(EXEC) $(OBJS) -L$(UTILDIR) $(UTILFLAG)
$(OBJS): $(SRCS)
	$(CC) $(CFLAGS) -c $(SRCS)
debug: $(SRCS) 
	$(CC) $(CFLAGS) -g -ggdb -c $(SRCS)
	$(CC) $(CFLAGS) -g -ggdb -o $(EXEC) $(OBJS) -L$(UTILDIR) $(UTILFLAG)



test: $(SRCS1)
	$(CC) $(CFLAGS) -g -ggdb -c $(SRCS1)
	$(CC) $(CFLAGS) -g -ggdb -o $(EXEC1) $(OBJS1)
clean:
	rm -f *~
	rm -f *#
	rm -f *.o


