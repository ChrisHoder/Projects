CC = gcc
CC1 = ar
CFLAGS1 = -cvq
CFLAGS = -Wall -pedantic -std=c99
EXEC = libtseutl.a
OBJS = dictionary.o file.o hash.o html.o
SRCS = dictionary.c file.c hash.c html.c
# Commands start with TAB not spaces
$(EXEC): $(OBJS)
	$(CC1) $(CFLAGS1) $(EXEC) $(OBJS)
$(OBJS): $(SRCS)
	$(CC) $(CFLAGS) -c $(SRCS)
debug: $(SRCS) 
	$(CC) $(CFLAGS) -g -ggdb -c $(SRCS)
	$(CC1) $(CFLAGS) -g -ggdb -o $(EXEC) $(OBJS)
clean:
	rm -f *~
	rm -f *#
	rm -f *.o


