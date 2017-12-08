-incdir $UVM_HOME
-incdir ./tb
+UVM_NO_RELNOTES
-uvm -sv
./tb/agent_pkg.sv
./tb/my_pkg.sv
./tb/tb_top.sv

/* We need to provide tb_top.sv, my_pkg.sv and agent_pkg.sv to the compiler.
my_pkg and agent_pkg is required because it is not `included anywhere else.
*/
