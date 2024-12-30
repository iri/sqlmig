-module(ora_parser_inline_constraint_tests).
-include_lib("eunit/include/eunit.hrl").


% Valid number datatypes
parse_valid_inline_constraint_01_test() ->
    Input = "
        CREATE Table tab41 (
            name1 date not null primary key constraint namec1 unique constraint namec2 references aaa ( bbb,ccc ) on delete cascade,
            name2 timestamp null references abc ( bbb,ccc ) on delete SET NULL
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({ok,[{create_table,_,_,_}]}, Result).


% Invalid number datatypes
parse_invalid_inline_constraint_01_test() ->
    Input = "
        CREATE Table tab41 (
            name1 date not unull
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_inline_constraint_02_test() ->
    Input = "
        CREATE Table tab41 (
            name1 date references ( ccc )
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_inline_constraint_03_test() ->
    Input = "
        CREATE Table tab41 (
            name1 char not null primary key abc 
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).
