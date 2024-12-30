-module(ora_parser_number_datatype_tests).
-include_lib("eunit/include/eunit.hrl").


% Valid number datatypes
parse_valid_number_datatype_01_test() ->
    Input = "
        CREATE Table tab21 (
            name1 number,
            name2 number(10),
            name3 number (10,5),
            name4 float,
            name5 float (12),
            name6 binary_float,
            name7 BINARY_DOUBLE
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({ok,[{create_table,_,_,_}]}, Result).


% Invalid number datatypes
parse_invalid_number_datatype_01_test() ->
    Input = "
        CREATE Table tab21 (
            name1 number (12,6,4)
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_number_datatype_02_test() ->
    Input = "
        CREATE Table tab21 (
            name1 float (12,6)
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_number_datatype_03_test() ->
    Input = "
        CREATE Table tab21 (
            name1 binary_float(10)
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_number_datatype_04_test() ->
    Input = "
        CREATE Table tab21 (
            name1 binary_float(8)
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

