BINS = trimax copiemem

AS = gcc
ASFLAGS32 = -m32 -g -c
ASFLAGS = -m64 -g -c
CC = gcc
CFLAGS32 = -Wall -Wextra -Werror -m32 -g -std=gnu99
CFLAGS = -Wall -Wextra -Werror -m64 -g -std=gnu99
LD = gcc
LDFLAGS32 = -m32
LDFLAGS = -m64

OBJS = \
	   $(foreach f, $(BINS), $(addsuffix .o, $f)) \
	   $(foreach f, $(BINS), $(addprefix fct_, $(addsuffix .o, $f)))

.PHONY: all
all: $(BINS)

trimax: trimax.o fct_trimax.o

copiemem: copiemem.o fct_copiemem.o
	$(LD) $(LDFLAGS32) -o $@ $^

copiemem.o: copiemem.c
	$(CC) $(CFLAGS32) -c -o $@ $<

fct_copiemem.o: fct_copiemem.s
	$(AS) $(ASFLAGS32) -c -o $@ $<

.PHONY: clean
clean:
	$(RM) -r $(BINS) $(OBJS)

