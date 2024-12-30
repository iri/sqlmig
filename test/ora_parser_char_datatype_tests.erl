-module(ora_parser_char_datatype_tests).
-include_lib("eunit/include/eunit.hrl").


% Valid char datatypes
parse_valid_char_datatype_01_test() ->
    Input = "
        CREATE Table tab1 (
            name2 char, 
            name1 char(20), 
            name3 char(20 byte), 
            name4 char(20 char),
            name1 varchar2(200), 
            name2 varchar2(200 byte), 
            name3 varchar2(200 char),  
            name1 nchar,
            name2 nchar(234),
            name1 NVARCHAR2(234)
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({ok,[{create_table,_,_,_}]}, Result).


% Invalid char datatypes
parse_invalid_char_datatype_01_test() ->
    Input = "
        CREATE Table tab2 (
            name1 varchar2
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_char_datatype_02_test() ->
    Input = "
        CREATE Table tab2 (
            name1 varchar2(300 abc__char)
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_char_datatype_03_test() ->
    Input = "
        CREATE Table tab2 (
            name1 char(300 abcc__char)
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_char_datatype_04_test() ->
    Input = "
        CREATE Table tab2 (
            name1 nchar(300 BYTE)
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

parse_invalid_char_datatype_05_test() ->
    Input = "
        CREATE Table tab2 (
            name1 nvarchar2
        );",
    {ok, Tokens,_} = ora_lexer:string(Input),
    Result = catch ora_parser:parse(Tokens),
    ?assertMatch({error,_}, Result).

