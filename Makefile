OPENCM3DIR  = ./libopencm3
OPENCM3NAME = opencm3_stm32f4
OPENCM3FILE = $(OPENCM3DIR)/lib/lib$(OPENCM3NAME).a


# LDSCRIPT    = stm32f405x6.ld
LDSCRIPT = stm32f405x6_full.ld
elf/crypto_sign_dilithium5_old_%.elf: LDSCRIPT=stm32f405x6_full.ld
elf/crypto_sign_dilithium5_new_%.elf: LDSCRIPT=stm32f405x6_full.ld


PREFIX     ?= arm-none-eabi
CC          = $(PREFIX)-gcc
LD          = $(PREFIX)-gcc
OBJCOPY     = $(PREFIX)-objcopy

ARCH_FLAGS  = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16



ifndef CRYPTO_ITERATIONS
CRYPTO_ITERATIONS=100
endif

DEFINES     = -DSTM32F4 -DCRYPTO_ITERATIONS=$(CRYPTO_ITERATIONS)


CFLAGS     += -Wall -Wextra -Wimplicit-function-declaration \
              -Wredundant-decls -Wmissing-prototypes -Wstrict-prototypes \
              -Wundef -Wshadow \
              -I$(OPENCM3DIR)/include \
              -fno-common $(ARCH_FLAGS) -MD $(DEFINES)
              
CFLAGS_DEBUG     = -O0 -g $(CFLAGS)
CFLAGS += -O3

CC_HOST    = gcc
LD_HOST    = gcc

CFLAGS_HOST = -O3 -Wall -Wextra -Wpedantic
LDFLAGS_HOST = -lm


# override as desired
# TYPE=sign

COMMONSOURCES= common/fips202.c common/sha2.c common/crypto_hashblocks_sha512.c common/aes-publicinputs.c common/aes.c
COMMONSOURCES_HOST=$(COMMONSOURCES) common/keccakf1600.c
COMMONSOURCES_M4=$(COMMONSOURCES) common/keccakf1600.S common/aes-encrypt.S common/aes-publicinputs.S common/aes-keyschedule.S common/crypto_hashblocks_sha512_inner32.s

COMMONINCLUDES_M4=$(COMMONINCLUDES) -I"common"

RANDOMBYTES_M4=common/randombytes.c

DEST=bin

TARGET_NAME = $(shell echo $(IMPLEMENTATION_PATH) | sed 's@/@_@g')
TYPE = $(shell echo $(IMPLEMENTATION_PATH) | sed 's@^\([^/]*/\)*crypto_\([^/]*\)/.*$$@\2@')
IMPLEMENTATION_SOURCES = $(wildcard $(IMPLEMENTATION_PATH)/*.c) $(wildcard $(IMPLEMENTATION_PATH)/*.s) $(wildcard $(IMPLEMENTATION_PATH)/*.S)
IMPLEMENTATION_HEADERS = $(IMPLEMENTATION_PATH)/*.h

LDFLAGS    += --static -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group \
              -T$(LDSCRIPT) -nostartfiles -Wl,--gc-sections \
               $(ARCH_FLAGS) -L$(OPENCM3DIR)/lib -lm -l$(OPENCM3NAME)

.PHONY: all
all:
	@echo "Please use the scripts in this directory instead of using the Makefile"
	@echo
	@echo "If you really want to use it, please specify IMPLEMENTATION_PATH=path/to/impl"
	@echo "and a target binary, e.g.,"
	@echo "make IMPLEMENTATION_PATH=crypto_kem/kyber768/new bin/crypto_kem_kyber768_new_test.bin"
	@echo "make clean also works"

$(DEST_HOST)/%_testvectors: $(COMMONSOURCES_HOST) $(IMPLEMENTATION_SOURCES) $(IMPLEMENTATION_HEADERS)
	mkdir -p $(DEST_HOST)
	$(CC_HOST) -o $@ \
		$(CFLAGS_HOST) -DMUPQ_NAMESPACE=$(MUPQ_NAMESPACE)\
		mupq/crypto_$(TYPE)/testvectors-host.c \
		$(COMMONSOURCES_HOST) \
		$(IMPLEMENTATION_SOURCES) \
		-I$(IMPLEMENTATION_PATH) \
		$(COMMONINCLUDES) \
		$(LDFLAGS_HOST)

$(DEST)/%.bin: elf/%.elf
	mkdir -p $(DEST)
	$(OBJCOPY) -Obinary $^ $@


# pattern rules, intended to match % to the type of test (i.e. test, speed, stack)
# note that this excludes testvectors, as that is a special case that provides its own randombytes
# TODO use notrandombytes more generically rather than included in testvectors.c
elf/$(TARGET_NAME)_%.elf: crypto_$(TYPE)/%.c $(COMMONSOURCES_M4) $(RANDOMBYTES_M4) $(IMPLEMENTATION_SOURCES) $(IMPLEMENTATION_HEADERS) $(OPENCM3FILE) common/hal-stm32f4.c
	mkdir -p elf
	$(CC) -o $@ $(CFLAGS) -DMUPQ_NAMESPACE=$(MUPQ_NAMESPACE) \
		$< $(COMMONSOURCES_M4) $(RANDOMBYTES_M4) $(IMPLEMENTATION_SOURCES) common/hal-stm32f4.c \
		-I$(IMPLEMENTATION_PATH) $(COMMONINCLUDES_M4) $(LDFLAGS)

elf/$(TARGET_NAME)_f_speed.elf: crypto_$(TYPE)/f_speed.c $(COMMONSOURCES_M4) $(RANDOMBYTES_M4) $(IMPLEMENTATION_SOURCES) $(IMPLEMENTATION_HEADERS) $(OPENCM3FILE) common/hal-stm32f4.c
	mkdir -p elf
	$(CC) -o $@ $(CFLAGS) -DMUPQ_NAMESPACE=$(MUPQ_NAMESPACE) -Dbenchmark \
		$< $(COMMONSOURCES_M4) $(RANDOMBYTES_M4) $(IMPLEMENTATION_SOURCES) common/hal-stm32f4.c crypto_$(TYPE)/f_speed.S \
		-I$(IMPLEMENTATION_PATH) $(COMMONINCLUDES_M4) $(LDFLAGS)

elf/$(TARGET_NAME)_testvectors.elf: crypto_$(TYPE)/testvectors.c $(COMMONSOURCES_M4) $(IMPLEMENTATION_SOURCES) $(IMPLEMENTATION_HEADERS) $(OPENCM3FILE) common/hal-stm32f4.c
	mkdir -p elf
	$(CC) -o $@ $(CFLAGS_DEBUG) -DMUPQ_NAMESPACE=$(MUPQ_NAMESPACE)\
		$< $(COMMONSOURCES_M4) $(IMPLEMENTATION_SOURCES) common/hal-stm32f4.c \
		-I$(IMPLEMENTATION_PATH) $(COMMONINCLUDES_M4) $(LDFLAGS)

elf/$(TARGET_NAME)_hashing.elf: crypto_$(TYPE)/hashing.c $(COMMONSOURCES_M4) $(IMPLEMENTATION_SOURCES) $(IMPLEMENTATION_HEADERS) $(OPENCM3FILE) common/hal-stm32f4.c
	mkdir -p elf
	$(CC) -o $@ $(CFLAGS) -DPROFILE_HASHING -DMUPQ_NAMESPACE=$(MUPQ_NAMESPACE) \
		$< $(COMMONSOURCES_M4) $(RANDOMBYTES_M4) $(IMPLEMENTATION_SOURCES) common/hal-stm32f4.c \
		-I$(IMPLEMENTATION_PATH) $(COMMONINCLUDES_M4) $(LDFLAGS)

obj/$(TARGET_NAME)_%.o: $(IMPLEMENTATION_PATH)/%.c $(IMPLEMENTATION_HEADERS)
	mkdir -p obj
	$(CC) -o $@ -c $(CFLAGS) -DMUPQ_NAMESPACE=$(MUPQ_NAMESPACE) \
		-I$(IMPLEMENTATION_PATH) $(COMMONINCLUDES_M4) $<

obj/$(TARGET_NAME)_%.o: $(IMPLEMENTATION_PATH)/%.s $(IMPLEMENTATION_HEADERS)
	mkdir -p obj
	$(CC) -o $@ -c $(CFLAGS) -DMUPQ_NAMESPACE=$(MUPQ_NAMESPACE) \
		-I$(IMPLEMENTATION_PATH) $(COMMONINCLUDES_M4) $<

obj/$(TARGET_NAME)_%.o: $(IMPLEMENTATION_PATH)/%.S $(IMPLEMENTATION_HEADERS)
	mkdir -p obj
	$(CC) -o $@ -c $(CFLAGS) -DMUPQ_NAMESPACE=$(MUPQ_NAMESPACE) \
		-I$(IMPLEMENTATION_PATH) $(COMMONINCLUDES_M4) $<

$(OPENCM3FILE):
	@if [ ! "`ls -A $(OPENCM3DIR)`" ] ; then \
		printf "######## ERROR ########\n"; \
		printf "\tlibopencm3 is not initialized.\n"; \
		printf "\tPlease run (in the root directory):\n"; \
		printf "\t$$ git clone https://github.com/libopencm3/libopencm3\n"; \
		printf "\tbefore running make.\n"; \
		printf "######## ERROR ########\n"; \
		exit 1; \
		fi
	make -C $(OPENCM3DIR)

.PHONY: clean libclean

clean:
	rm -rf elf/
	rm -rf bin/
	rm -rf bin-host/
	rm -rf obj/
	rm -rf testvectors/
	rm -rf benchmarks/

libclean:
	make -C $(OPENCM3DIR) clean
