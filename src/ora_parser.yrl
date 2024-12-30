Nonterminals 
stmt_list
stmt
stmt_body
create_table_stmt
table_element_list
table_element
column_definition
column
datatype
char_type
varchar2_type
nchar_type
nvarchar2_type
char_size_spec
char_size_spec_unit
char_unit
size
number_type
float_type
binary_float_type
binary_double_type
number_precision
number_scale
datetime_type
timestamp_type
interval_year_type
interval_day_type
date_precision
datatype_domain
default_rule
in_constraints
inline_constraint_list
inline_constraint
constraint_name
inline_constraint_nocheck
constraint_check
out_constraint
out_of_line_constraint
out_of_line_constraint_nocheck
column_list
references_clause
on_delete_clause
expr
simple_expression
compound_expression
term
factor
term1
factor1
boolean_expression
condition
null_condition
compound_condition
number
.

Terminals 
identifier 
'CREATE'
'TABLE'
'('
')' 
',' 
';'
'+'
'-'
'*'
'/'
'.'
'||'
'='
'!='
'^='
'<>'
'>'
'<'
'>='
'<='
'CHAR'
'VARCHAR2'
'NCHAR'
'NVARCHAR2'
'BYTE'
'NUMBER'
'FLOAT'
'BINARY_FLOAT'
'BINARY_DOUBLE'
'DATE'
'TIMESTAMP'
'WITH'
'LOCAL'
'TIME'
'ZONE'
'INTERVAL' 
'YEAR'
'TO' 
'MONTH'
'DAY'
'SECOND'
'CONSTRAINT'
'NOT'
'NULL'
'UNIQUE'
'PRIMARY'
'KEY'
'CHECK'
'FOREIGN'
'REFERENCES'
'ON'
'DELETE'
'CASCADE'
'SET'
'ROWNUM'
'CURRVAL'
'NEXTVAL'
'TRUE'
'FALSE'
'IS'
'AND'
'OR'
'DEFAULT'
integer
string
float
.


Rootsymbol stmt_list.
% Rootsymbol simple_expression.


stmt_list -> stmt : ['$1'] .
stmt_list -> stmt_list stmt : '$1' ++ ['$2'] .

stmt -> stmt_body ';' : '$1' .

stmt_body -> create_table_stmt : '$1' .

create_table_stmt -> 'CREATE' 'TABLE' identifier '(' table_element_list ')' : {create_table, line('$1'), {name,val('$3')}, {elements,'$5'}} .

table_element_list -> '$empty' : [].
table_element_list -> table_element : ['$1'] .
table_element_list -> table_element_list ',' table_element : '$1' ++ ['$3'] .


%========
% relational_properties
% { column_definition
% | virtual_column_definition
% | period_definition
% | { out_of_line_constraint | out_of_line_ref_constraint }
% | supplemental_logging_props
% }
%  [, { column_definition
%  | virtual_column_definition
%  | period_definition
%  | { out_of_line_constraint | out_of_line_ref_constraint }
%  | supplemental_logging_props
%  }
%  ]...

table_element -> column_definition : {column,'$1'} .
% table_element -> out_constraint : '$1' .

%========
% column_definition
% column  [ datatype_domain ]
%   [ [ COLLATE column_collation_name ] | RESERVABLE ] 
%   [ SORT ] [ VISIBLE | INVISIBLE ]
%   [ DEFAULT [ ON NULL [ FOR ( INSERT { ONLY | AND UPDATE } ) ] ] 
%   | identity_clause ]
%     expr
%   [ ENCRYPT encryption_spec ]
%   [ { inline_constraint }...
%   | inline_ref_constraint
%   | annotations_clause
%   ]

%========
% datatype_domain
% { datatype [ DOMAIN [domain_owner.] domain_name ]
%   | [ DOMAIN ] [domain_owner.] domain_name }

column_definition -> column datatype_domain : ['$1']++['$2'] .
column_definition -> column datatype_domain default_rule in_constraints : ['$1']++['$2']++['$3']++['$4'] .

column -> identifier : [{name, val('$1')}] .

datatype_domain -> '$empty' : [].
datatype_domain -> datatype : [{datatype,'$1'}].

default_rule -> '$empty' : [].
default_rule -> 'DEFAULT' expr : [{default,'$2'}].

in_constraints -> inline_constraint_list : [{constraints,'$1'}] .
% in_constraints -> inline_ref_constraint : '$1' . %% To be added

% inline_constraint_list -> '$empty' : [].
inline_constraint_list -> inline_constraint : ['$1'] .
inline_constraint_list -> inline_constraint_list inline_constraint : '$1' ++ ['$2'] .

%========
% inline_constraint
% [ CONSTRAINT constraint_name ]
% { { [ NOT ] NULL
%     | UNIQUE   
%     | PRIMARY KEY
%     | references_clause } [ constraint_state ]
% | CHECK ( condition ) [ constraint_state ] [ precheck_state ]
% }

inline_constraint -> inline_constraint_nocheck : ['$1'].
inline_constraint -> constraint_name inline_constraint_nocheck : ['$1','$2'].
% inline_constraint -> constraint_name constraint_check : {'$1','$2'}.

constraint_name -> 'CONSTRAINT' identifier : {name, val('$2')}.

inline_constraint_nocheck -> 'NULL' : {not_null, false}.
inline_constraint_nocheck -> 'NOT' 'NULL' : {not_null, true}.
inline_constraint_nocheck -> 'UNIQUE' : {unique, true}.
inline_constraint_nocheck -> 'PRIMARY' 'KEY' : {primary_key, true}.
inline_constraint_nocheck -> references_clause : {references, '$1'}.

% constraint_check -> 'CHECK' boolean_expression : {'$1', '$2'}.

%========
% inline_ref_constraint
% { SCOPE  IS [ schema. ] scope_table
% | WITH ROWID
% | [ CONSTRAINT constraint_name ]
%   references_clause
%   [ constraint_state ]
% }
% inline_ref_constraint ->          %% To be added

%========
% out_of_line_constraint
%  [ CONSTRAINT constraint_name ]
%   { { UNIQUE (column [, column ]...)
%     | PRIMARY KEY (column [, column ]...)  
%     | FOREIGN KEY (column [, column ]...) references_clause } 
%       [ constraint_state ]
%     | CHECK ( condition ) [ constraint_state ] [ precheck_state ] }

% out_constraint -> out_of_line_constraint : '$1' .
% out_constraint -> out_of_line_ref_constraint : '$1' .     %% To be added
 
% out_of_line_constraint -> constraint_name out_of_line_constraint_nocheck : {'$1','$2'}.
% out_of_line_constraint -> constraint_name constraint_check : {'$1','$2'}.

% out_of_line_constraint_nocheck -> 'UNIQUE' '(' column_list ')' : {'$1', '$3'}.
% out_of_line_constraint_nocheck -> 'PRIMARY' 'KEY' '(' column_list ')' : {'$1', '$2', '$4'}.
% out_of_line_constraint_nocheck -> 'FOREIGN' 'KEY' '(' column_list ')' references_clause : {'$1', '$2', '$4', '$6'}.

% out_of_line_ref_constraint
% { SCOPE FOR ({ ref_col | ref_attr })
%     IS [ schema. ] scope_table
% | REF ({ ref_col | ref_attr }) WITH ROWID
% | [ CONSTRAINT constraint_name ] FOREIGN KEY
%     ( { ref_col [, ref_col ] | ref_attr [, ref_attr ] } ) references_clause
%     [ constraint_state ]
% }
% out_of_line_ref_constraint ->         %% To be added


%========
% references_clause
% REFERENCES [ schema. ] object [ (column [, column ]...) ]
%   [ON DELETE { CASCADE | SET NULL } ]
references_clause -> 'REFERENCES' identifier '(' column_list ')' : [{remote_table,val('$2')},{columns,'$4'}] .
references_clause -> 'REFERENCES' identifier '(' column_list ')' on_delete_clause : [{remote_table,val('$2')},{columns,'$4'},{on_delete,'$6'}].

on_delete_clause -> 'ON' 'DELETE' 'CASCADE' : cascade.
on_delete_clause -> 'ON' 'DELETE' 'SET' 'NULL' : set_null.

column_list -> column : ['$1'] .
column_list -> column_list ',' column : '$1' ++ ['$3'] .


%========
% expr
% { simple_expression
% | compound_expression
% | calc_meas_expression
% | case_expression
% | cursor_expression
% | datetime_expression
% | function_expression
% | interval_expression
% | JSON_object_access_expr
% | model_expression
% | object_access_expression
% | scalar_subquery_expression
% | type_constructor_expression
% | variable_expression
% | boolean_expression
% }

expr -> simple_expression : '$1'.
% expr -> compound_expression : '$1'.
% expr -> boolean_expression : '$1'.

%========
% simple_expression
% { [ query_name.
%   | [schema.] { table. | view. | materialized view. }
%   | t_alias.
%   ] { column | ROWID }
% | ROWNUM
% | string
% | number
% | sequence. { CURRVAL | NEXTVAL }
% | NULL
% | TRUE
% | FALSE
% }
simple_expression -> number : '$1' .
simple_expression -> 'ROWNUM' : [cat('$1')] .
simple_expression -> string : [val('$1')] .
simple_expression -> identifier : [val('$1')].
simple_expression -> identifier '.' 'CURRVAL' : [val('$1'),".",cat('$3')].
simple_expression -> identifier '.' 'NEXTVAL' : [val('$1'),".",cat('$3')].
simple_expression -> 'NULL' : [cat('$1')] .
simple_expression -> 'TRUE' : [cat('$1')] .
simple_expression -> 'FALSE' : [cat('$1')] .

%========
% compound_expression
% { (expr)
% | { + | - | PRIOR } expr
% | expr { * | / | + | - | || } expr
% | expr COLLATE collation_name
% }

compound_expression -> compound_expression '+' term: { '+', '$1', '$3' }.
compound_expression -> compound_expression '-' term: { '-', '$1', '$3' }.
compound_expression -> compound_expression '||' term: { '||', '$1', '$3' }.
compound_expression -> term: '$1'.
term -> term '*' factor: { '*', '$1', '$3' }.
term -> term '/' factor: { '/', '$1', '$3' }.
term -> factor: '$1'.
factor -> '(' expr ')': '$2'.


%========
% boolean_expression (condition)
% { comparison_condition
% | floating_point_condition
% | logical_condition
% | model_condition
% | multiset_condition
% | pattern_matching_condition
% | range_condition
% | null_condition
% | XML_condition
% | JSON_condition
% | compound_condition
% | exists_condition
% | in_condition
% | is_of_type_condition
% | boolean_test_condition
% | simple_expression
% }

boolean_expression -> null_condition : '$1' .
boolean_expression -> compound_condition : '$1' .

%========
% null_condition
% expr IS [ NOT ] NULL

null_condition -> expr 'IS' 'NULL' : {'$1','$2','$3'} .
null_condition -> expr 'IS' 'NOT' 'NULL' : {'$1','$2','$3','$4'} .

%========
% compound_condition
% { (condition)
% | NOT condition
% | condition { AND | OR } condition
% }

compound_condition -> compound_condition 'OR' term1: { 'OR', '$1', '$3' }.
compound_condition -> compound_condition 'AND' term1: { 'AND', '$1', '$3' }.
compound_condition -> term1: '$1'.
term1 -> 'NOT' factor1: { 'NOT', '$2' }.
term1 -> factor1: '$1'.
factor1 -> '(' boolean_expression ')': '$2'.


%========
% Number data types
% { NUMBER [ (precision [, scale ]) ]
% | FLOAT [ (precision) ]
% | BINARY_FLOAT
% | BINARY_DOUBLE
% }
datatype -> number_type : '$1'.
datatype -> float_type : '$1'.
datatype -> binary_float_type : '$1'.
datatype -> binary_double_type : '$1'.

number_type -> 'NUMBER' : {{name,cat('$1')}, []}.
number_type -> 'NUMBER' '(' number_precision ')' : {{name,cat('$1')}, [{precision,'$3'}]}.
number_type -> 'NUMBER' '(' number_precision ',' number_scale ')' : {{name,cat('$1')}, [{precision,'$3'}, {scale,'$5'}]}.

float_type -> 'FLOAT' : {{name,cat('$1')}, []}.
float_type -> 'FLOAT' '(' number_precision ')' : {{name,cat('$1')}, [{precision,'$3'}]}.

binary_float_type -> 'BINARY_FLOAT' : {{name,cat('$1')}, []}.

binary_double_type -> 'BINARY_DOUBLE' : {{name,cat('$1')}, []}.

number_precision -> integer : val('$1').
number_scale -> integer : val('$1').

% Char data types
% { CHAR [ (size [ BYTE | CHAR ]) ]
% | VARCHAR2 (size [ BYTE | CHAR ])
% | NCHAR [ (size) ]
% | NVARCHAR2 (size)
% }
datatype -> varchar2_type : '$1'.
datatype -> nvarchar2_type : '$1'.
datatype -> char_type : '$1'.
datatype -> nchar_type : '$1'.

varchar2_type -> 'VARCHAR2' char_size_spec_unit : {{name,cat('$1')}, '$2'}.

nvarchar2_type -> 'NVARCHAR2' char_size_spec : {{name,cat('$1')}, '$2'}.

char_type -> 'CHAR' : {{name,cat('$1')}, [{size,1},{unit,'BYTE'}]} .
char_type -> 'CHAR' char_size_spec_unit : {{name,cat('$1')}, '$2'}.

nchar_type -> 'NCHAR' : {{name,cat('$1')}, [{size,1}]}.
nchar_type -> 'NCHAR' char_size_spec : {{name,cat('$1')}, '$2'}.

char_size_spec -> '(' size ')' : [{size,'$2'}].

char_size_spec_unit -> '(' size ')' : [{size,'$2'},{unit,'BYTE'}].
char_size_spec_unit -> '(' size char_unit ')' : [{size,'$2'},{unit,'$3'}].

char_unit -> 'BYTE' : cat('$1').
char_unit -> 'CHAR' : cat('$1').

size -> integer : val('$1').

% Date & time datatypes
% { DATE
% | TIMESTAMP [ (fractional_seconds_precision) ]
%      [ WITH [ LOCAL ] TIME ZONE ]
% | INTERVAL YEAR [ (year_precision) ] TO MONTH
% | INTERVAL DAY [ (day_precision) ] TO SECOND
%      [ (fractional_seconds_precision) ]
% }
datatype -> datetime_type : '$1'.
datatype -> timestamp_type : '$1'.
datatype -> interval_year_type : '$1'.
datatype -> interval_day_type : '$1'.

datetime_type -> 'DATE' : {{name,cat('$1')}, []}.

timestamp_type -> 'TIMESTAMP' : {{name,cat('$1')}, []}.
timestamp_type -> 'TIMESTAMP' 'WITH' 'TIME' 'ZONE' : {{name,cat('$1')}, [{with_timezone,true}]}.
timestamp_type -> 'TIMESTAMP' 'WITH' 'LOCAL' 'TIME' 'ZONE' : {{name,cat('$1')}, [{with_local_timezone,true}]}.
timestamp_type -> 'TIMESTAMP' '(' date_precision ')' : {{name,cat('$1')}, [{fractional_seconds_precision,'$3'}]}.
timestamp_type -> 'TIMESTAMP' '(' date_precision ')' 'WITH' 'TIME' 'ZONE' : {{name,cat('$1')}, [{with_timezone,true},{fractional_seconds_precision,'$3'}]}.
timestamp_type -> 'TIMESTAMP' '(' date_precision ')' 'WITH' 'LOCAL' 'TIME' 'ZONE' : {{name,cat('$1')}, [{with_local_timezone,true},{fractional_seconds_precision,'$3'}]}.

interval_year_type -> 'INTERVAL' 'YEAR' 'TO' 'MONTH' : {{name,cat('$1')}, [{year_to_month,true}]}.
interval_year_type -> 'INTERVAL' 'YEAR' '(' date_precision ')' 'TO' 'MONTH' : {{name,cat('$1')}, [{year_to_month,true},{year_precision,'$4'}]}.

interval_day_type -> 'INTERVAL' 'DAY' 'TO' 'SECOND' : {{name,cat('$1')}, [{day_to_second,true}]}.
interval_day_type -> 'INTERVAL' 'DAY' '(' date_precision ')' 'TO' 'SECOND' : {{name,cat('$1')}, [{day_to_second,true},{day_precision,'$4'}]}.
interval_day_type -> 'INTERVAL' 'DAY' 'TO' 'SECOND' '(' date_precision ')' : {{name,cat('$1')}, [{day_to_second,true},{fractional_seconds_precision,'$6'}]}.
interval_day_type -> 'INTERVAL' 'DAY' '(' date_precision ')' 'TO' 'SECOND' '(' date_precision ')' : {{name,cat('$1')}, [{day_to_second,true},{day_precision,'$4'},{fractional_seconds_precision,'$9'}]}.

date_precision -> integer : val('$1').

number -> integer : val('$1').
number -> float : val('$1').

Erlang code.

% unwrap({_,_,V}) -> V.

cat(T) -> element(1, T).
line(T) -> element(2, T).
val(T) -> element(3, T).


