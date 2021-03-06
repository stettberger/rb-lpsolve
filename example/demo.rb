#!/usr/bin/env ruby
# $Id: demo.rb,v 1.7 2007/03/28 02:11:59 rocky Exp $
require "rubygems"
require 'highline/import'

Mypath  = File.expand_path(File.dirname(__FILE__))
old_dir = File.expand_path(Dir.pwd)
if old_dir != Mypath
  Dir.chdir(Mypath)
end
$: << Mypath + '/../ext'
require "lpsolve"

def press_ret
  ask("[return]") { |q| q.echo = true }
end

def error() 
  STDERR.print "Error\n"
  exit 1
end

lp = LPSolve.new(0, 4)

Vers=lp.version
Vers_str = "%d.%d.%d.%d" % Vers
puts "lp_solve %s demo\n\n" % Vers_str

if not lp
  error
end

puts "This demo will show most of the features of lp_solve %s" % Vers_str
press_ret
puts "We start by creating a new problem with 4 variables and 0 constraints"
puts "We use: lp=make_lp(0,4);"
press_ret

puts "We can show the current problem with print_lp(lp)"
lp.print_lp
press_ret

puts "Now we add some constraints"
puts "str_add_constraint(lp, \"3 2 2 1\" ,LE,4)"
puts "This is the string version of add_constraint. For the normal version"
puts "of add_constraint see the help file"

if not lp.str_add_constraint("3 2 2 1", LPSolve::LE, 4)
  puts "Error in adding constraint"
  error
end

lp.print_lp()
press_ret

puts "str_add_constraint(lp, \"0 4 3 1\" ,GE,3)"
if not lp.str_add_constraint("0 4 3 1", LPSolve::GE, 3)
  puts "Error in adding constraint"
  error
end
lp.print_lp()
press_ret

puts "Set the objective function"
puts "str_set_obj_fn(lp, \"2 3 -2 3\")"
if not lp.str_set_obj_fn("2 3 -2 3")
  puts "Error in setting objective function"
  error
end
lp.print_lp()
press_ret

puts "Now solve the problem with printf(solve(lp));"
solution = lp.solve
puts "%d" % solution
press_ret

puts "The value is 0, this means we found an optimal solution"
puts "We can display this solution with print_objective(lp) and print_solution(lp)"

lp.print_objective
lp.print_solution(1)
lp.print_constraints(1)
press_ret

puts "The dual variables of the solution are printed with"
puts "print_duals(lp);"
lp.print_duals()
press_ret

puts "We can change a single element in the matrix with"
puts "set_mat(lp,2,1,0.5)"

if (!lp.set_mat(2,1,0.5))
  error
end  
  
lp.print_lp
press_ret
puts "If we want to maximize the objective function use set_maxim(lp);"
lp.set_maxim
lp.print_lp
press_ret
puts  "after solving this gives us:\n"
lp.solve
lp.print_objective
lp.print_solution(1)
lp.print_constraints(1)
lp.print_duals
press_ret
puts "Change the value of a rhs element with set_rh(lp,1,7.45)"
lp.set_rh(1,7.45)
lp.print_lp
lp.solve
lp.print_objective
lp.print_solution(1)
lp.print_constraints(1)
press_ret
puts "We change %s to the integer type with" % lp.get_col_name(4)
puts "set_int(lp, 4, TRUE)"
lp.set_int(4, true)
lp.print_lp
puts "We set branch & bound debugging on with set_debug(lp, TRUE)"
lp.set_debug(true)
puts "and solve..."
press_ret()
lp.solve
lp.print_objective
lp.print_solution(1)
lp.print_constraints(1)
press_ret()
puts "We can set bounds on the variables with"
puts "set_lowbo(lp,2,2); & set_upbo(lp,4,5.3)"
lp.set_lowbo(2,2)
lp.set_upbo(4,5.3)
lp.print_lp
press_ret
lp.solve
lp.print_objective
lp.print_solution(1)
lp.print_constraints(1)
press_ret
puts "Now remove a constraint with del_constraint(lp, 1)"
lp.del_constraint(1)
lp.print_lp
puts ("Add an equality constraint")
if not lp.str_add_constraint("1 2 1 4", LPSolve::EQ, 8)
    error()
end
lp.print_lp
press_ret
printf("A column can be added with:\n")
printf("str_add_column(lp,\"3 2 2\");\n")
if (not lp.str_add_column("3 2 2"))
  error
end
lp.print_lp
press_ret
printf("A column can be removed with:\n");
printf("del_column(lp,3);\n");
lp.del_column(3)
lp.print_lp
press_ret
printf("We can use automatic scaling with:\n")
printf("set_scaling(lp, SCALE_MEAN);\n")
lp.set_scaling(LPSolve::SCALE_MEAN)
lp.print_lp
press_ret

printf("The function get_mat(lprec *lp, int row, int column) returns a single\n");
printf("matrix element\n");
printf("%s get_mat(lp,2,3), get_mat(lp,1,1); gives\n","printf(\"%f %f\\n\",");
printf("%f %f\n", lp.get_mat(2,3), lp.get_mat(1,1));
printf("Notice that get_mat returns the value of the original unscaled problem\n");
press_ret();
printf("If there are any integer type variables, then only the rows are scaled\n");
printf("set_int(lp,3,FALSE);\n");
printf("set_scaling(lp, SCALE_MEAN);\n");
lp.set_scaling(LPSolve::SCALE_MEAN);
lp.set_int(3,FALSE);
lp.print_lp
press_ret
lp.solve
printf("print_objective, print_solution gives the solution to the original problem\n");
lp.print_objective
lp.print_solution(1);
lp.print_constraints(1);
press_ret

printf("Scaling is turned off with unscale(lp);\n");
lp.unscale;
lp.print_lp
press_ret();
printf("Now turn B&B debugging off and simplex tracing on with\n");
printf("set_debug(lp, FALSE), set_trace(lp, TRUE) and solve(lp)\n");
lp.set_debug(FALSE);
lp.set_trace(TRUE);
press_ret();
lp.solve

printf("Where possible, lp_solve will start at the last found basis\n");
printf("We can reset the problem to the initial basis with\n");
printf("default_basis(lp). Now solve it again...\n");
press_ret();
lp.default_basis
lp.solve

printf("It is possible to give variables and constraints names\n");
printf("set_row_name(lp,1,\"speed\"); & set_col_name(lp,2,\"money\")\n");
if (not lp.set_row_name(1,"speed"))
    error();
end
if (!lp.set_col_name(2,"money"))
  error();
end  
lp.print_lp
printf("As you can see, all column and rows are assigned default names\n");
printf("If a column or constraint is deleted, the names shift place also:\n");
press_ret();
printf("del_column(lp,1);\n");
lp.del_column(1);
lp.print_lp
press_ret();
