#ifndef __OG_AST_ADDRESS_H__
#define __OG_AST_ADDRESS_H__

#include <cdk/ast/expression_node.h>
#include <cdk/ast/lvalue_node.h>

namespace og {

  class address_node: public cdk::expression_node {
    cdk::lvalue_node *_lvalue;

  public:
    inline address_node(int lineno, cdk::lvalue_node *lvalue) :
        cdk::expression_node(lineno), _lvalue(lvalue) {
    }

  public:
    cdk::lvalue_node *lvalue() {
      return _lvalue;
    }
 
    void accept(basic_ast_visitor *sp, int level) {
      sp->do_address_node(this, level);
    }

  };

} 

#endif
