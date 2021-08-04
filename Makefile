#!make

.ONESHELL:

venv:
	python3 -m venv .venv
	make activate && make reqs
	make deps

activate:
	. .venv/bin/activate

install-githooks:
	pre-commit install

reqs:
	pip3 install -r requirements.txt

lint:
	pylint *.py

deps:
	dbt deps

#dbt shortcuts

run:
	dbt --warn-error run

full-refresh:
	dbt --warn-error run --full-refresh

security-init:
	dbt run-operation init_security_demo

t:
	dbt run-operation t --args '{test: t}'

compile:
	dbt compile


.PHONY: activate venv reqs test