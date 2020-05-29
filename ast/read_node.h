#ifndef __OG_AST_READ_H__
#define __OG_AST_READ_H__

#include <cdk/ast/expression_node.h>

namespace og {

  class read_node: public cdk::expression_node {
  public:
    read_node(int lineno) :
        cdk::expression_node(lineno) {
    }

  public:
    void accept(basic_ast_visitor *sp, int level) {
      sp->do_read_node(this, level);
    }

  };

} // og

#endif