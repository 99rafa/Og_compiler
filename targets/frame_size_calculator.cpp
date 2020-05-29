#include <string>
#include "targets/frame_size_calculator.h"
#include "targets/type_checker.h"
#include "targets/symbol.h"
#include "ast/all.h"

og::frame_size_calculator::~frame_size_calculator() {
  os().flush();
}

void og::frame_size_calculator::do_add_node(cdk::add_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_and_node(cdk::and_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_assignment_node(cdk::assignment_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_data_node(cdk::data_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_div_node(cdk::div_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_double_node(cdk::double_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_eq_node(cdk::eq_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_ge_node(cdk::ge_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_gt_node(cdk::gt_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_variable_node(cdk::variable_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_integer_node(cdk::integer_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_le_node(cdk::le_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_lt_node(cdk::lt_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_mod_node(cdk::mod_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_mul_node(cdk::mul_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_ne_node(cdk::ne_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_neg_node(cdk::neg_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_nil_node(cdk::nil_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_not_node(cdk::not_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_or_node(cdk::or_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_rvalue_node(cdk::rvalue_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_string_node(cdk::string_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_sub_node(cdk::sub_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_evaluation_node(og::evaluation_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_print_node(og::print_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_read_node(og::read_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_address_node(og::address_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_function_call_node(og::function_call_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_function_declaration_node(og::function_declaration_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_left_index_node(og::left_index_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_continue_node(og::continue_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_nullptr_node(og::nullptr_node * const node, int lvl) {
  // EMPTY
}

void og::frame_size_calculator::do_stack_alloc_node(og::stack_alloc_node * const node, int lvl) {
  // EMPTY
}
void og::frame_size_calculator::do_break_node(og::break_node * const node, int lvl) {
  // EMPTY
}

void og::frame_size_calculator::do_sizeof_node(og::sizeof_node * const node, int lvl) {
  // EMPTY
}

void og::frame_size_calculator::do_identity_node(og::identity_node * const node, int lvl) {
  // EMPTY
}

void og::frame_size_calculator::do_tuple_index_node(og::tuple_index_node * const node, int lvl) {
  // EMPTY
}

void og::frame_size_calculator::do_tuple_node(og::tuple_node * const node, int lvl) {
  // EMPTY
}

void og::frame_size_calculator::do_sequence_node(cdk::sequence_node * const node, int lvl) {
  for (size_t i = 0; i < node->size(); i++) {
    cdk::basic_node *n = node->node(i);
    if (n == nullptr) break;
    n->accept(this, lvl + 2);
  }
}

void og::frame_size_calculator::do_block_node(og::block_node * const node, int lvl) {
  if (node->declarations()) node->declarations()->accept(this, lvl + 2);
  if (node->instructions()) node->instructions()->accept(this, lvl + 2);
}

void og::frame_size_calculator::do_for_node(og::for_node * const node, int lvl) {
  if (node->inits()) node->inits()->accept(this, lvl + 4);
  if (node->block()) node->block()->accept(this, lvl + 4);
}

void og::frame_size_calculator::do_if_node(og::if_node * const node, int lvl) {
  node->block()->accept(this, lvl + 2);
}

void og::frame_size_calculator::do_if_else_node(og::if_else_node * const node, int lvl) {
  node->thenblock()->accept(this, lvl + 2);
  if (node->elseblock()) node->elseblock()->accept(this, lvl + 2);
}

void og::frame_size_calculator::do_variable_declaration_node(og::variable_declaration_node * const node, int lvl) {
	try{
    if(true){
      type_checker checker(_compiler,_symtab,nullptr,this);
      (node)->accept(&checker, 0);
    }
    if(node->is_typed(cdk::TYPE_STRUCT) && node->identifiers().size() == 1 )
      _localsize += 4;
    else
	    _localsize += node->type()->size();
	  if (node->is_typed(cdk::TYPE_STRUCT)) node->type(make_primitive_type(0,cdk::TYPE_UNSPEC)); //hack
	}
	catch(const std::string  &id){}

}

void og::frame_size_calculator::do_return_node(og::return_node * const node, int lvl) {
  if(!_ret){
    try{
      type_checker checker(_compiler,_symtab,nullptr,this);
      (node->retval())->accept(&checker, 0);
      if(node->retval()->is_typed(cdk::TYPE_STRUCT)){
        _localsize += 4;
        _retsize = 4;
      }
      else{
        _localsize += node->retval()->type()->size();
        _retsize = node->retval()->type()->size();
      }
      _ret = true;
    } catch(const std::string  &id){}
  }
}

void og::frame_size_calculator::do_function_definition_node(og::function_definition_node * const node, int lvl) {
  if(!node->is_typed(cdk::TYPE_UNSPEC)){
    _ret = true;
    _localsize += node->type()->size(); // save space for the function's return type
  }
  node->block()->accept(this, lvl + 2);
}
