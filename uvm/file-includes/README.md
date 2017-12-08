<p>There are multiple ways to arrange files within the testbench environment filesystem, and different ways to include them and provide to the compiler. In this example we'll probe a few ways in which you can include files for compilation.</p>

<p><code>`include</code> works similar to the C pre-processor macro #include where it takes the actual file and places it in the file where <code>`include</code> is called.</p>

<b>Style1</b>
<p>Here only the top file, tb_top.sv will be provided to the compiler (see irun.f) and the directory to look for `include files. All other files are `included in the top file tb_top.sv and hence the compiler will take them up for compilation.</p>
<br>
<b>Style2</b>
<p>In this case we have put all the three agents as a package, and imported it in <i>my_pkg.sv</i>. Since <i>my_pkg.sv</i> and <i>agent_pkg.sv</i> are not included anywhere else we have to provide them to the compiler in addition to <i>tb_top.sv</i>.</p>
<br>
<b>Style3</b>
<p>Here we skip creating any package or including any file within other files, unless required. Instead we provide a list of all the files to the compiler directly</p>

