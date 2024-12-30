.PHONY: test

all: compile

compile:
	rebar3 escriptize

test:
	rebar3 eunit

clean:
	rebar3 clean

