-incdir $UVM_HOME
-incdir ./tb
-incdir ./rtl
+UVM_NO_RELNOTES
+UVM_VERBOSITY=UVM_HIGH
-uvm -sv
./tb/apb_agent.sv
./tb/wb_agent.sv
./tb/spi_agent.sv
./tb/my_pkg.sv
./tb/tb_top.sv
