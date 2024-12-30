-module(sqlmig).

%% API exports
-export([main/1]).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main(Args) ->
    if
        length(Args) >= 1 ->
            [FileName|_] = Args,
            Lines = lpfile:read(FileName),
            {ok, Tokens, _} = ora_lexer:string(Lines),
            io:format("~p~n", [Tokens]),
            {ok, Expr} = ora_parser:parse(Tokens),
            io:format("~p~n", [Expr]);
        true ->
            ok
    end,
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================


% graph ""
% {
%     fontname="Helvetica,Arial,sans-serif"
%     node [fontname="Helvetica,Arial,sans-serif"]
%     edge [fontname="Helvetica,Arial,sans-serif"]
%     label=""

%     n0 [label="cons"];
%     n1 [label="atom (1, abc)"];
%     n2 [label="cons"];
%     n3 [label="atom (1, def)"];
%     n4 [label="cons"];
%     n5 [label="atom (1, ghi)"];
%     n6 [label="cons"];
%     n7 [label="cons"];
%     n8 [label="atom (1, jkl)"];
%     n9 [label="cons"];
%     n10 [label="atom (1, abc)"];
%     n11 [label="nil"];
%     n12 [label="atom (1, ddd)"];
%     n13 [label="nil"];

%     n0 -- n1; // {atom,1,abc}
%     n0 -- n2;
    
%     n2 -- n3; // {atom,1,def}
%     n2 -- n4;
    
%     n4 -- n5; // {atom,1,ghi}
%     n4 -- n6;
    
%     n6 -- n7; // nested cons
%     n6 -- n12;
    
%     n7 -- n8; // {atom,1,jkl}
%     n7 -- n9;
    
%     n9 -- n10; // {atom,1,abc}
%     n9 -- n11; // nil
    
%     n12 -- n13; // nil
% }



% graph ""
% {
%     fontname="Helvetica,Arial,sans-serif"
%     node [fontname="Helvetica,Arial,sans-serif"]
%     edge [fontname="Helvetica,Arial,sans-serif"]
%     label=""

%     // Root node
%     n001 [label="cons"];
    
%     // First child of root
%     n001 -- n002;
%     n002 [label="cons"];
    
%     n002 -- n003;
%     n003 [label="cons"];
    
%     n003 -- n004;
%     n004 [label="cons"];
    
%     n004 -- n005;
%     n005 [label="cons"];
    
%     n005 -- n006;
%     n006 [label="atom\n1, abc"];
    
%     n005 -- n007;
%     n007 [label="nil"];
    
%     n004 -- n008;
%     n008 [label="atom\n1, def"];
    
%     n003 -- n009;
%     n009 [label="atom\n1, ghi"];
    
%     n002 -- n010;
%     n010 [label="cons"];
    
%     n010 -- n011;
%     n011 [label="cons"];
    
%     n011 -- n012;
%     n012 [label="atom\n1, jkl"];
    
%     n011 -- n013;
%     n013 [label="nil"];
    
%     n010 -- n014;
%     n014 [label="atom\n1, abc"];
    
%     // Second child of root
%     n001 -- n015;
%     n015 [label="atom\n1, ddd"];
% }

