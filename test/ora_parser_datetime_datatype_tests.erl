-module(ora_parser_datetime_datatype_tests).
-include_lib("eunit/include/eunit.hrl").

% Valid datetime datatypes
parse_valid_datetime_datatype_01_test() ->
    Input = "
        CREATE Table tab31 (
            name1 date,
            name2 timestamp,
            name3 timestamp WITH TIME ZONE ,
            name4 timestamp WITH LOCAL TIME ZONE ,
            name5 timestamp (100),
            name6 timestamp (100) WITH TIME ZONE ,
            name7 timestamp (100) WITH LOCAL TIME ZONE,
            name8 INTERVAL YEAR TO MONTH ,
            name9 INTERVAL YEAR (644) TO MONTH, 
            name10 INTERVAL DAY TO SECOND,
            name11 INTERVAL DAY (172) TO SECOND,
            name12 INTERVAL DAY TO SECOND (100),
            name13 INTERVAL DAY (65) TO SECOND (200)
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({ok,[{create_table,_,_,_}]}, Result).


% Invalid char datatypes
parse_invalid_datetime_datatype_01_test() ->
    Input = "
        CREATE Table tab31 (
            name1 date time
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_datetime_datatype_02_test() ->
    Input = "
        CREATE Table tab31 (
            name2 timestamp bobo
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_datetime_datatype_03_test() ->
    Input = "
        CREATE Table tab31 (
            name2 timestamp (200),
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_datetime_datatype_04_test() ->
    Input = "
        CREATE Table tab31 (
            name6 timestamp (100) WITHOUT TIME ZONE
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_datetime_datatype_05_test() ->
    Input = "
        CREATE Table tab31 (
            name9 INTERVAL YEAR (644) TO MONTH (300), 
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

