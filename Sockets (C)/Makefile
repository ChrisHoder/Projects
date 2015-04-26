CC = gcc
CFLAGS = -Wall -pedantic -std=c99
EXEC = client
EXEC1 = server
OBJS = Client.o
SRCS = Client.c
SRCS1 = server.c
OBJS1 = server.o
# Commands start with TAB not spaces

client: $(SRCS)
	$(CC) $(CFLAGS) -c $(SRCS)
	$(CC) $(CFLAGS) -o $(EXEC) $(OBJS)

server: $(SRCS1)
	$(CC) $(CFLAGS) -c $(SRCS1)
	$(CC) $(CFLAGS) -o $(EXEC1) $(OBJS1)

server_debug: $(SRCS1)
	$(CC) $(CFLAGS) -g -ggdb -c $(SRCS1)
	$(CC) $(CFLAGS) -g -ggdb -o $(EXEC1) $(OBJS1)

client_debug: $(SRCS) 
	$(CC) $(CFLAGS) -g -ggdb -c $(SRCS)
	$(CC) $(CFLAGS) -g -ggdb -o $(EXEC) $(OBJS)
clean:
	rm -f *~
	rm -f *#
	rm -f *.o


