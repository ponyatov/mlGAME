
CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

PY  = $(CWD)/bin/python3
PIP = $(CWD)/bin/pip3

run: $(PY) $(MODULE).py $(MODULE).ini
	$^

install: $(PY)
	sudo apt install -u `cat apt.txt`
update: $(PIP)
	$(PIP) install -U pip
	$(PIP) install -r requirements.txt
	$(MAKE) requirements.txt

$(PY) $(PIP):
	python3 -m venv .
	$(MAKE) update

.PHONY: requirements.txt
requirements.txt: $(PIP)
	$(PIP) freeze | egrep -v "(pkg-resources)" > $@
