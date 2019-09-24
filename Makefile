CROSS_COMPILE ?= 
CC := $(CROSS_COMPILE)gcc
CFLAGS += -g -Wall

OBG = rhost

all: rhost.o
	$(CC) $(CFLAGS) $^ -o $(OBG)
    
clean:
	rm -rf *.o
	rm $(OBG)
