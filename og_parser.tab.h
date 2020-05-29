#define tREALVAL 257
#define tNULLPTR 258
#define tINTEGER 259
#define tPUBLIC 260
#define tREQUIRE 261
#define tPRIVATE 262
#define tIDENTIFIER 263
#define tSTRING 264
#define tINT 265
#define tREAL 266
#define tSTR 267
#define tAUTO 268
#define tPTR 269
#define tPROCEDURE 270
#define tSIZEOF 271
#define tINPUT 272
#define tWRITE 273
#define tWRITELN 274
#define tBREAK 275
#define tCONTINUE 276
#define tRETURN 277
#define tIF 278
#define tTHEN 279
#define tELSE 280
#define tELIF 281
#define tFOR 282
#define tDO 283
#define tGE 284
#define tLE 285
#define tEQ 286
#define tNE 287
#define tOR 288
#define tAND 289
#define tUNARY 290
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {
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
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;
