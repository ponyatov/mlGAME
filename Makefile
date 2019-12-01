
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

NOW = $(shell date +%y%m%d)
REL = $(shell git rev-parse --short=4 HEAD)

MERGE  = Makefile .gitignore README.md
MERGE += $(MODULE).py $(MODULE).ini apt.txt requirements.txt

merge:
	git checkout master
	git checkout shadow -- $(MERGE)

release:
	git tag $(NOW)-$(REL)
	git push -v --tags ; git push -v
	git checkout shadow
