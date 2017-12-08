-incdir $UVM_HOME
-incdir ./tb
+UVM_NO_RELNOTES
-uvm -sv
./tb/tb_top.sv

/* Comment
---------- 
Note that only top file tb_top.sv is provided to the compiler.
And all other files are `included within the top file tb_top
*/
