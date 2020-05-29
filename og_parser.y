%{
//-- don't change *any* of these: if you do, you'll break the compiler.
#include <cdk/compiler.h>
#include "ast/all.h"
#define LINE               compiler->scanner()->lineno()
#define yylex()            compiler->scanner()->scan()
#define yyerror(s)         compiler->scanner()->error(s)
#define YYPARSE_PARAM_TYPE std::shared_ptr<cdk::compiler>
#define YYPARSE_PARAM      compiler
//-- don't change *any* of these --- END!
%}

%union {
  int                         i;	/* integer value */
  std::string                 *s;	/* symbol name or string literal */
  std::vector<std::string>    *v; 
  double                      d;    /* real value */
  cdk::basic_node             *node;	/* node pointer */
  cdk::sequence_node          *sequence;
  cdk::expression_node        *expression; /* expression nodes */
  cdk::basic_type             *t;       /* expression type */  
  cdk::lvalue_node            *lvalue;
  og::block_node              *b;
};

%token<d> tREALVAL
%token<expression> tNULLPTR
%token <i> tINTEGER tPUBLIC tREQUIRE tPRIVATE
%token <s> tIDENTIFIER tSTRING

%token tINT tREAL tSTR tAUTO tPTR
%token tPROCEDURE
%token tSIZEOF
%token tINPUT tWRITE tWRITELN
%token tBREAK tCONTINUE tRETURN
%token tIF tTHEN tELSE tELIF
%token tFOR tDO
%token tGE tLE tEQ tNE tOR tAND

%nonassoc tIF 
%nonassoc tTHEN tDO
%nonassoc tELSE tELIF

%left tOR 
%left tAND
%right '='
%left tEQ tNE
%left tGE tLE '>' '<'
%left '+' '-' 
%left '*' '/' '%'
%nonassoc tUNARY '~'
%nonassoc '?'


%type <node> declaration variable function procedure instruction condition elifelse iteration tupledecls blockvar blocktup
%type <sequence> exprs file declarations variables blockdecls instructions fargs
%type <v> ids
%type <t> type auto
%type <b> block
%type <s> string
%type <expression> expr integer real tuple
%type <lvalue> lval

%{
//-- The rules below will be included in yyparse, the main parsing function.
%}
%%

file           :                                  { compiler->ast($$ = new cdk::sequence_node(LINE)); }
               | declarations                     { compiler->ast($$ = $1); }
               ;

declarations   : declaration                      { $$ = new cdk::sequence_node(LINE,$1); }
               | declarations declaration         { $$ = new cdk::sequence_node(LINE,$2,$1); }
               ;

declaration    : variable ';'                     { $$ = $1; }
               | tupledecls ';'                   { $$ = $1;}
               | function                         { $$ = $1; }
               | procedure                        { $$ = $1; }
               ;


variable       :           type tIDENTIFIER            { std::vector<std::string> v; v.push_back(*$2) ;$$ = new og::variable_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),v,nullptr); }
               |           type tIDENTIFIER '=' expr   { std::vector<std::string> v; v.push_back(*$2) ;$$ = new og::variable_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),v,$4); }
               | tPUBLIC type tIDENTIFIER              { std::vector<std::string> v; v.push_back(*$3) ;$$ = new og::variable_declaration_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),v,nullptr); }
               | tPUBLIC type tIDENTIFIER '=' expr     { std::vector<std::string> v; v.push_back(*$3) ;$$ = new og::variable_declaration_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),v,$5); }
               | tREQUIRE type tIDENTIFIER             { std::vector<std::string> v; v.push_back(*$3) ;$$ = new og::variable_declaration_node(LINE,tREQUIRE,std::shared_ptr<cdk::basic_type>($2),v,nullptr); }
               ;

tupledecls		:         auto ids '=' tuple           { $$ = new og::variable_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,$4);}
              | tPUBLIC auto ids '=' tuple           { $$ = new og::variable_declaration_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),*$3,$5);}
		          ;


tuple         : exprs                   { $$ = new og::tuple_node(LINE,$1);}
              ;

ids	          : tIDENTIFIER 			      { std::vector<std::string> v; v.push_back(*$1); $$ = new std::vector<std::string>(v);}
              | ids ',' tIDENTIFIER			{ (*$1).push_back(*$3); $$ = new std::vector<std::string>(*$1);}
              ;


function       :         type tIDENTIFIER '(' ')'                   { $$ = new og::function_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,nullptr); delete $2; }
               |         type tIDENTIFIER '(' fargs ')'             { $$ = new og::function_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,$4); delete $2; }
               |         type tIDENTIFIER '('  ')' block            { $$ = new og::function_definition_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,nullptr,$5); delete $2; }
               |         type tIDENTIFIER '(' fargs ')' block       { $$ = new og::function_definition_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,$4,$6); delete $2; }
               |         auto tIDENTIFIER '(' ')'                   { $$ = new og::function_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,nullptr); delete $2; }
               |         auto tIDENTIFIER '(' fargs ')'             { $$ = new og::function_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,$4); delete $2; }
               |         auto tIDENTIFIER '('  ')' block            { $$ = new og::function_definition_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,nullptr,$5); delete $2; }
               |         auto tIDENTIFIER '(' fargs ')' block       { $$ = new og::function_definition_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,$4,$6); delete $2; }
               | tPUBLIC type tIDENTIFIER '(' ')'                   { $$ = new og::function_declaration_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),*$3,nullptr); delete $3; }
               | tPUBLIC type tIDENTIFIER '(' fargs ')'             { $$ = new og::function_declaration_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),*$3,$5); delete $3; }
               | tPUBLIC type tIDENTIFIER '('  ')' block            { $$ = new og::function_definition_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),*$3,nullptr,$6); delete $3; }
               | tPUBLIC type tIDENTIFIER '(' fargs ')' block       { $$ = new og::function_definition_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),*$3,$5,$7); delete $3; }
               | tPUBLIC auto tIDENTIFIER '(' ')'                   { $$ = new og::function_declaration_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),*$3,nullptr); delete $3; }
               | tPUBLIC auto tIDENTIFIER '(' fargs ')'             { $$ = new og::function_declaration_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),*$3,$5); delete $3; }
               | tPUBLIC auto tIDENTIFIER '('  ')' block            { $$ = new og::function_definition_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),*$3,nullptr,$6); delete $3; }
               | tPUBLIC auto tIDENTIFIER '(' fargs ')' block       { $$ = new og::function_definition_node(LINE,tPUBLIC,std::shared_ptr<cdk::basic_type>($2),*$3,$5,$7); delete $3; }
               | tREQUIRE type tIDENTIFIER '(' ')'                  { $$ = new og::function_declaration_node(LINE,tREQUIRE,std::shared_ptr<cdk::basic_type>($2),*$3,nullptr); delete $3; }
               | tREQUIRE type tIDENTIFIER '(' fargs ')'            { $$ = new og::function_declaration_node(LINE,tREQUIRE,std::shared_ptr<cdk::basic_type>($2),*$3,$5); delete $3; }
               | tREQUIRE auto tIDENTIFIER '(' ')'                  { $$ = new og::function_declaration_node(LINE,tREQUIRE,std::shared_ptr<cdk::basic_type>($2),*$3,nullptr); delete $3; }
               | tREQUIRE auto tIDENTIFIER '(' fargs ')'            { $$ = new og::function_declaration_node(LINE,tREQUIRE,std::shared_ptr<cdk::basic_type>($2),*$3,$5); delete $3; }
               ;


procedure      :         tPROCEDURE tIDENTIFIER '(' ')'                   { $$ = new og::function_declaration_node(LINE,tPRIVATE,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$2,nullptr); delete $2; }
               |         tPROCEDURE tIDENTIFIER '(' fargs ')'         { $$ = new og::function_declaration_node(LINE,tPRIVATE,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$2,$4); delete $2; }
               |         tPROCEDURE tIDENTIFIER '('  ')' block            { $$ = new og::function_definition_node(LINE,tPRIVATE,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$2,nullptr,$5); delete $2; }
               |         tPROCEDURE tIDENTIFIER '(' fargs ')' block   { $$ = new og::function_definition_node(LINE,tPRIVATE,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$2,$4,$6); delete $2; }
               | tPUBLIC tPROCEDURE tIDENTIFIER '(' ')'                   { $$ = new og::function_declaration_node(LINE,tPUBLIC,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$3,nullptr); delete $3; }
               | tPUBLIC tPROCEDURE tIDENTIFIER '(' fargs ')'         { $$ = new og::function_declaration_node(LINE,tPUBLIC,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$3,$5); delete $3; }
               | tPUBLIC tPROCEDURE tIDENTIFIER '('  ')' block            { $$ = new og::function_definition_node(LINE,tPUBLIC,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$3,nullptr,$6); delete $3; }
               | tPUBLIC tPROCEDURE tIDENTIFIER '(' fargs ')' block   { $$ = new og::function_definition_node(LINE,tPUBLIC,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$3,$5,$7); delete $3; }
               | tREQUIRE tPROCEDURE tIDENTIFIER '(' ')'                   { $$ = new og::function_declaration_node(LINE,tREQUIRE,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$3,nullptr); delete $3; }
               | tREQUIRE tPROCEDURE tIDENTIFIER '(' fargs ')'         { $$ = new og::function_declaration_node(LINE,tREQUIRE,cdk::make_primitive_type(0,cdk::TYPE_VOID),*$3,$5); delete $3; }
               ;


fargs          : type tIDENTIFIER             { std::vector<std::string> v; v.push_back(*$2); $$ = new cdk::sequence_node(LINE,new og::variable_declaration_node(LINE,-1,std::shared_ptr<cdk::basic_type>($1),v,nullptr)); }
               | fargs ',' type tIDENTIFIER   { std::vector<std::string> v; v.push_back(*$4); $$ = new cdk::sequence_node(LINE,new og::variable_declaration_node(LINE,-1,std::shared_ptr<cdk::basic_type>($3),v,nullptr),$1); }
               ; 


exprs          : expr                             {  $$ = new cdk::sequence_node(LINE, $1); }
               | exprs ',' expr                   {  $$ = new cdk::sequence_node(LINE, $3, $1); }
               ;

expr           : integer                                    {  $$ = $1; }
               | string                                     {  $$ = new cdk::string_node(LINE, $1); }
               | real                                       {  $$ = $1; }
               | tINPUT					                            {  $$ = new og::read_node(LINE); }
               | tNULLPTR				                            {  $$ = new og::nullptr_node(LINE); }
	             | tIDENTIFIER '(' ')'			                  {  $$ = new og::function_call_node(LINE,*$1, nullptr); delete $1; }
      	       | tIDENTIFIER '(' exprs ')'		              {  $$ = new og::function_call_node(LINE,*$1, $3); delete $1; }
               | '-' expr %prec tUNARY                      {  $$ = new cdk::neg_node(LINE, $2); }
               | '+' expr %prec tUNARY 		                  {  $$ = new og::identity_node(LINE,$2);}
               | '~' expr                                   {  $$ = new cdk::not_node(LINE,$2); }
               | expr '+' expr	                            {  $$ = new cdk::add_node(LINE, $1, $3); }
               | expr '-' expr	                            {  $$ = new cdk::sub_node(LINE, $1, $3); }
               | expr '*' expr	                            {  $$ = new cdk::mul_node(LINE, $1, $3); }
               | expr '/' expr	                            {  $$ = new cdk::div_node(LINE, $1, $3); }
               | expr '%' expr	                            {  $$ = new cdk::mod_node(LINE, $1, $3); }
               | expr '<' expr	                            {  $$ = new cdk::lt_node(LINE, $1, $3); }
               | expr '>' expr	                            {  $$ = new cdk::gt_node(LINE, $1, $3); }
               | expr tGE expr	                            {  $$ = new cdk::ge_node(LINE, $1, $3); }
               | expr tLE expr                              {  $$ = new cdk::le_node(LINE, $1, $3); }
               | expr tNE expr	                            {  $$ = new cdk::ne_node(LINE, $1, $3); }
               | expr tEQ expr	                            {  $$ = new cdk::eq_node(LINE, $1, $3); }
               | '(' expr ')'                               {  $$ = $2; }
               | lval                                       {  $$ = new cdk::rvalue_node(LINE, $1); }
               | lval '=' expr                              {  $$ = new cdk::assignment_node(LINE, $1, $3); }
               | expr tAND expr				                      { $$ = new cdk::and_node(LINE, $1,$3); }
               | expr tOR expr				                      { $$ = new cdk::or_node(LINE, $1,$3); }
               | lval '?' 				                          { $$ = new og::address_node(LINE,$1); }
               |'[' expr ']'				                        { $$ = new og::stack_alloc_node(LINE,$2); }
               | tSIZEOF '(' tuple ')'  		                { $$ = new og::sizeof_node(LINE,$3); }
               ;

variables      : variable                         { $$ = new cdk::sequence_node(LINE,$1); }
               | variables ',' variable           { $$ = new cdk::sequence_node(LINE,$3,$1); }
               ;

type           : tINT                             { $$ = new cdk::primitive_type(4,cdk::TYPE_INT); }
               | tREAL                            { $$ = new cdk::primitive_type(8,cdk::TYPE_DOUBLE); }
               | tSTR                             { $$ = new cdk::primitive_type(4,cdk::TYPE_STRING); }
               | tPTR '<' type '>'                { $$ = new cdk::reference_type(4,std::shared_ptr<cdk::basic_type>($3));}
               | tPTR '<' auto '>'                { $$ = new cdk::reference_type(4,std::shared_ptr<cdk::basic_type>($3));}
               ;

auto          : tAUTO                             {$$ = new cdk::primitive_type(0,cdk::TYPE_UNSPEC); };

block          : '{' '}'                                { $$ = new og::block_node(LINE,nullptr,nullptr); }
               | '{' blockdecls '}'                     { $$ = new og::block_node(LINE,$2,nullptr); }
               | '{' instructions '}'                   { $$ = new og::block_node(LINE,nullptr,$2); }
               | '{' blockdecls instructions '}'        { $$ = new og::block_node(LINE,$2,$3); }
               ;

blockdecls      : blockvar ';'                { $$ = new cdk::sequence_node(LINE, $1);     }
                | blocktup ';'              { $$ = new cdk::sequence_node(LINE, $1);     }
                | blockdecls blockvar ';'     { $$ = new cdk::sequence_node(LINE, $2, $1); }
                | blockdecls blocktup ';'   { $$ = new cdk::sequence_node(LINE, $2, $1); }
                ;


blockvar        :           type tIDENTIFIER            { std::vector<std::string> v; v.push_back(*$2); $$ = new og::variable_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),v,nullptr); }
                |           type tIDENTIFIER '=' expr   { std::vector<std::string> v; v.push_back(*$2); $$ = new og::variable_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),v,$4); }
                ;
  

blocktup        :         auto ids '=' tuple           { $$ = new og::variable_declaration_node(LINE,tPRIVATE,std::shared_ptr<cdk::basic_type>($1),*$2,$4);}
                ;



instructions   : instruction                           { $$ = new cdk::sequence_node(LINE, $1); }
               | instructions instruction              { $$ = new cdk::sequence_node(LINE, $2, $1); }
               ;

instruction    : expr ';'               { $$ = new og::evaluation_node(LINE,$1); }
               | tWRITE exprs ';'       { $$ = new og::print_node(LINE,$2,false); }
               | tWRITELN exprs ';'     { $$ = new og::print_node(LINE,$2,true); }
               | tBREAK                 { $$ = new og::break_node(LINE); }
               | tCONTINUE              { $$ = new og::continue_node(LINE); }
               | tRETURN ';'            { $$ = new og::return_node(LINE,nullptr); }
               | tRETURN tuple ';'      { $$ = new og::return_node(LINE,$2); }
               | condition              { $$ = $1;}
               | iteration              { $$ = $1; }
               | block                  { $$ = $1; }
               ;

condition      : tIF expr tTHEN instruction                           { $$ = new og::if_node(LINE,$2,$4); }
               | tIF expr tTHEN instruction elifelse                  { $$ = new og::if_else_node(LINE,$2,$4,$5); }
               ;

elifelse       : tELSE instruction                                   { $$ = $2; }
               | tELIF expr tTHEN instruction                        { $$ = new og::if_node(LINE,$2,$4); }
               | tELIF expr tTHEN instruction elifelse               { $$ = new og::if_else_node(LINE,$2,$4,$5); }
               ;


iteration      : tFOR ';' ';'  tDO instruction                        { $$ = new og::for_node(LINE,nullptr,nullptr,nullptr,$5); }
               | tFOR variables ';' ';' tDO instruction               { $$ = new og::for_node(LINE,$2,nullptr,nullptr,$6); }
               | tFOR ';' exprs ';' tDO instruction                   { $$ = new og::for_node(LINE,nullptr,$3,nullptr,$6); }
               | tFOR ';' ';' exprs tDO instruction                   { $$ = new og::for_node(LINE,nullptr,nullptr,$4,$6); }
               | tFOR variables ';' exprs ';' tDO instruction         { $$ = new og::for_node(LINE,$2,$4,nullptr,$7); }
               | tFOR variables ';' ';' exprs tDO instruction         { $$ = new og::for_node(LINE,$2,nullptr,$5,$7); }
               | tFOR variables ';' exprs ';' exprs tDO instruction   { $$ = new og::for_node(LINE,$2,$4,$6,$8); }
               | tFOR exprs ';' ';' tDO instruction                   { $$ = new og::for_node(LINE,$2,nullptr,nullptr,$6); }
               | tFOR exprs ';' exprs ';' tDO instruction             { $$ = new og::for_node(LINE,$2,$4,nullptr,$7); }
               | tFOR exprs ';' ';' exprs tDO instruction             { $$ = new og::for_node(LINE,$2,nullptr,$5,$7); }
               | tFOR ';' exprs ';' exprs tDO instruction             { $$ = new og::for_node(LINE,nullptr,$3,$5,$7); }
               | tFOR exprs ';' exprs  ';' exprs tDO instruction      { $$ = new og::for_node(LINE,$2,$4,$6,$8); }
               ;

lval    : tIDENTIFIER                               { $$ = new cdk::variable_node(LINE, *$1); delete $1;}
        | lval '@' tINTEGER                         { $$ = new og::tuple_index_node(LINE,new cdk::rvalue_node(LINE,$1),$3); }
        | '(' expr ')' '@' tINTEGER                 { $$ = new og::tuple_index_node(LINE,$2,$5); }
	      | tIDENTIFIER '(' ')' '@' tINTEGER          { $$ = new og::tuple_index_node(LINE, new og::function_call_node(LINE,*$1, nullptr), $5); delete $1;}
        | tIDENTIFIER '(' exprs ')' '@' tINTEGER    { $$ = new og::tuple_index_node(LINE, new og::function_call_node(LINE,*$1, $3), $6); delete $1;}        
        | lval '[' expr ']' 	                      { $$ = new og::left_index_node(LINE, new cdk::rvalue_node(LINE,$1), $3); }
	      | '(' expr ')' '[' expr ']'                 { $$ = new og::left_index_node(LINE, $2, $5); }
	      | tIDENTIFIER '(' ')' '[' expr ']' 	        { $$ = new og::left_index_node(LINE, new og::function_call_node(LINE,*$1, nullptr), $5); delete $1;}
        | tIDENTIFIER '(' exprs ')' '[' expr ']'    { $$ = new og::left_index_node(LINE, new og::function_call_node(LINE,*$1, $3), $6); delete $1;}
        ;

integer         : tINTEGER                      { $$ = new cdk::integer_node(LINE, $1); };
real            : tREALVAL                      { $$ = new cdk::double_node(LINE, $1); };
string          : tSTRING                       { $$ = $1; }
                | string tSTRING                { $$ = new std::string(*$1 + *$2); delete $1; delete $2; }
                ;

%%
