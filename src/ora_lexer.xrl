Definitions.

WS = [\s\t]
LB = \n|\r\n|\r
INT = [0-9]+
FLOAT = [0-9]+\.[0-9]+([eE][-+]?[0-9]+)?
NAME = [A-Za-z][_A-Za-z0-9]*
STR = '(\\\^.|\\.|[^'])*'
COM = --[^\n]*

Rules.

{INT}       : {token, {'integer', TokenLine, list_to_integer(TokenChars)}}.
{STR}       : {token, {'string', TokenLine, string:substr(TokenChars,2,length(TokenChars)-2)}}.
{FLOAT}     : {token, {'float', TokenLine, list_to_float(TokenChars)}}.
{NAME}      : {token, reserved_or_identifier(TokenChars, TokenLine)}.
\(          : {token, {'(',  TokenLine}}.
\)          : {token, {')',  TokenLine}}.
\,          : {token, {',',  TokenLine}}.
\;			: {token, {';',  TokenLine}}.
\+			: {token, {'+',  TokenLine}}.
\-			: {token, {'-',  TokenLine}}.
\*			: {token, {'*',  TokenLine}}.
\/			: {token, {'/',  TokenLine}}.
\.			: {token, {'.',  TokenLine}}.
\|\|		: {token, {'||', TokenLine}}.
{WS}+		: skip_token.
{LB}+       : skip_token.

Erlang code.

-export([is_reserved/1]).

reserved_or_identifier(String, TokenLine) ->
	StringUC = string:to_upper(String),
	case is_reserved(StringUC) of
		true ->
			{list_to_atom(StringUC), TokenLine};
		false ->
			{identifier, TokenLine, list_to_atom(String)}
	end.

is_reserved("CREATE")   		-> true;
is_reserved("INT")   			-> true;
is_reserved("INTEGER")   		-> true;
is_reserved("TABLE")    		-> true;
is_reserved("CHAR")    			-> true;
is_reserved("BYTE")    			-> true;
is_reserved("VARCHAR2")    		-> true;
is_reserved("NCHAR")    		-> true;
is_reserved("NVARCHAR2")    	-> true;
is_reserved("NUMBER")    		-> true;
is_reserved("FLOAT")    		-> true;
is_reserved("BINARY_FLOAT")    	-> true;
is_reserved("BINARY_DOUBLE")	-> true;
is_reserved("DATE")    			-> true;
is_reserved("TIMESTAMP")    	-> true;
is_reserved("WITH")    			-> true;
is_reserved("LOCAL")    		-> true;
is_reserved("TIME")    			-> true;
is_reserved("ZONE")    			-> true;
is_reserved("INTERVAL")    		-> true;
is_reserved("YEAR")    			-> true;
is_reserved("TO")    			-> true;
is_reserved("MONTH")    		-> true;
is_reserved("DAY")    			-> true;
is_reserved("SECOND")    		-> true;
is_reserved("CONSTRAINT")   	-> true;
is_reserved("NOT")    			-> true;
is_reserved("NULL")    			-> true;
is_reserved("UNIQUE")    		-> true;
is_reserved("PRIMARY")    		-> true;
is_reserved("KEY")    			-> true;
is_reserved("CHECK")    		-> true;
is_reserved("FOREIGN")    		-> true;
is_reserved("REFERENCES")   	-> true;
is_reserved("ON")    			-> true;
is_reserved("DELETE")    		-> true;
is_reserved("CASCADE")    		-> true;
is_reserved("SET")    			-> true;
is_reserved("ROWNUM")    		-> true;
is_reserved("CURRVAL")    		-> true;
is_reserved("NEXTVAL")    		-> true;
is_reserved("TRUE")    			-> true;
is_reserved("FALSE")    		-> true;
is_reserved("IS")    			-> true;
is_reserved("AND")    			-> true;
is_reserved("OR")    			-> true;
is_reserved("DEFAULT")  		-> true;
is_reserved(_)          		-> false.

