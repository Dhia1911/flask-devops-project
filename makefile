# Variables
APP=app/main.py

install:
	pip install -r requirements.txt

run:
	python $(APP)

test:
	pytest

lint:
	flake8 .

format:
	black .

check: lint test

clean:
	find . -type d -name "__pycache__" -exec rm -r {} +

freeze:
	pip freeze > requirements.txt