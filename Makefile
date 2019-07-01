build:
	#docker build --cache-from=binarytemple/elixir_plug_poc . -t binarytemple/elixir_plug_poc
	docker build  . -t binarytemple/elixir_plug_poc

run: build
	docker run -ti -p 4000:4000 --rm binarytemple/elixir_plug_poc console

push: build
	docker push binarytemple/elixir_plug_poc:latest
