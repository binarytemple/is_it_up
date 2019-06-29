build:
	docker build . -t elixir_plug_poc

run: build
	docker run -t -p 4000:4000 --rm elixir_plug_poc
