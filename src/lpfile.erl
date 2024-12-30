    -module(lpfile).

%% API exports
-export([read/1,read_lines/1]).

     read(FileName) ->
       case file:open(FileName, [read]) of
                                             {ok, File} ->
            Tokens = read_lines(File),
            file:close(File),
        Tokens;
        {error, Reason} ->
            {error, Reason}
    end.

read_lines(File) ->
    read_lines(File,[]).
read_lines(File,Lines) ->
    case io:get_line(File, "") of
        eof ->
            Lines;
        {error, Reason} ->
            {error, Reason};
        Line ->
            read_lines(File,Lines++Line)
    end.
