BIN := dnsmasq/src/dnsmasq

PATCH_DIR  := patches
PATCHES    := $(sort $(wildcard $(PATCH_DIR)/*.patch))
PATCHED    := $(sort $(patsubst $(PATCH_DIR)/%.patch, $(PATCH_DIR)/%.patched, $(PATCHES)))

# turn on/off for regex or regex_ipset
DNSMASQ_COPTS="-DHAVE_REGEX -DHAVE_REGEX_IPSET"

all:$(BIN)

.PHONY: submodule
submodule:
	cd dnsmasq && $(MAKE) COPTS=$(DNSMASQ_COPTS)

$(BIN):$(PATCHED)
	cd dnsmasq && $(MAKE) COPTS=$(DNSMASQ_COPTS)

# disable parallel build for patching files
# for preventing from producing out of order chunks
.NOTPARALLEL: %.patched
%.patched:%.patch
	@echo "Applying $^"
	@patch -p 1 -d dnsmasq < $^ && touch $@
	@echo

.PHONY: reset_submodule
reset_submodule:
	git submodule foreach --recursive git reset --hard

.PHONY: remove_patched
remove_patched:
	find . \( -name \*.orig -o -name \*.rej \) -delete
	rm -rf $(PATCHED)

.PHONY: clean
clean:
	$(MAKE) -C dnsmasq clean
