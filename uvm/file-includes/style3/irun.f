-incdir $UVM_HOME
-incdir ./tb
+UVM_NO_RELNOTES
-uvm -sv
./tb/apb_agent.sv
./tb/wb_agent.sv
./tb/spi_agent.sv
./tb/my_pkg.sv
./tb/tb_top.sv

/* Note that since we are providing all the files directly, 
sometimes compilation order matters, and hence independent files
are listed first, followed by dependents.

For example, if tb_top.sv is listed before my_pkg.sv, then the 
import construct in tb_top.sv will fail saying it can't find
the package called my_pkg.sv
*/
