

-- This is a program for copying the .libs and header files to 
-- the mystr source for building mystr_release.
--
-- Notes: 
--  1.  "src dir" is the source location of an item to copy and not the source code directory.
--
-- John F. Davis
-- August 2010
-- It's just "build -c". That zaps everything under the "obj" directory
-- before doing the build. To do a clean and nothing else, do "build -c -0".
--

top_dir="\\sandbox\\"
--top_dir="\\cygdrive\\c\\sandbox\\"
--top_dir="~\\sandbox\\"
--top_dir="c:\\sandbox\\"


bit_choices = {"bits_32","bits_64"}
--bits=bit_choices[1] --> 32-bits
--bits=bit_choices{2} --> 64-bits

myos_choices = {"linux", "winXP", "win2003"}
--myos = myos_choices[1]  --> linux
--myos=myos_choices[2]  --> Windows XP
--myos=myos_choices[3]  --> Windows Server 2003

build_mode_choices = {"release", "debug"}
--build_mode = build_mode_choices[1]	--> debug
--build_mode = build_mode_choices[1]	--> release


function print_usage() 
	print("Studio and mystr_release update script.");
	print("\tThis program copies files for the driver project. By default it is set");
	print("\tto update a 32-bit winXP debug file sytem.");
	print("\t\to Copies the driverfrom ddk build output direcotry to the studio output folder for testing the .");
	print("\t\t  unit tests built with MS Visual Studio.");
	print("\t\to Copies the driver and libraries to the mystr_release folder for mystr development.");
	print("");
	print("");
	print("\tUSAGE and available options are");
	print("\t lua updatefs.lua [help|usage] [bits=64] [debug|release] [winXP|win2003|linux]");
	print("\t\thelp|usage\t\tprints this table");
	print("");
	print("\t\tOptions which specify the source and destination directories.");
	print("\t\t bits=32|64\t\t\t32-bit or 64-bit");
	print("\t\t debug|release\t\tdebug/checked or release/free.");
	print("\t\t winXP|win2003|linux\t\twinxp, win2003 or linux.");
end

------------------------------------------
-- driver paths
-- src location varies based upon
-- linux|winxp|win2003, 32-bit|64-bit, Debug|Release
--
driver_src_dir_prefix = top_dir.."dbgd\\driver\\"
driver_src_dir_choices = {
						linux =		{
										bits_32 =	{
												release="linux\\", 
												debug="linux\\" 
												},
										bits_64 =	{
												release="linux\\", 
												debug="linux\\" 
												}
									},
						winXP = 	{
										bits_32 =	{
												release="windows\\objfre_wxp_x86\\i386\\", 
												debug="windows\\objchk_wxp_x86\\i386\\"
												},
										bits_64 =	{
												release="winXP\\64\\release\\fixme\\", 
												debug="winXP\\64\\debug\\fixme\\"
												}
										
									},
						win2003 = 	{
										bits_32 =	{
												release="win2K\\32\\relase\\fixme", 
												debug="win2K\\32\\debug\\fixme"
												},
										bits_64 =	{
												release="windows\\objfre_wnet_amd64\\amd64\\", 
												debug="windows\\objchk_wnet_amd64\\amd64\\"
												}
									}
						}


print("--");
print("--");

-- driver is copied to mystr binary directory and the dbgd studio directory.
-- destination location varies based upon
--  32-bit|64-bit, Debug|Release

-- destination location
print("--");
----------------------------------------------
driver_dest_dir1_prefix = top_dir.."dbgd\\studio\\"
driver_dest_dir1_choices = {
						linux =		{
										bits_32 =	{
												release="narelease32\\", 
												debug="nadebug32\\" 
												},
										bits_64 =	{
												release="fixmerelease64\\", 
												debug="fixmedebug64\\" 
												}
									},
						winXP = 	{
										bits_32 =	{
												release="release\\", 
												debug="debug\\"
												},
										bits_64 =	{
												release="x64\\release\\", 
												debug="x64\\debug\\"
												}
										
									},
						win2003 = 	{
										bits_32 =	{
												release="release\\", 
												debug="debug\\"
												},
										bits_64 =	{
												release="x64\\release\\", 
												debug="x64\\debug\\"
												}
									}
						}


----------------------------------------------


-- directories for mystr gaa
driver_inc_dir_prefix = top_dir.."dbgd\\inc\\"
driver_mystr_dir_prefix = top_dir.."mystr_release\\"


function dump_dir_tables() 
	print("vvvvvvvvvvvvvvvvvvvvvvvvvvv")
	print("Build Inputs are:")
	print("bits = "..bits)
	print("myos = "..myos)
	print("build mode = "..build_mode)
	print("--");
--	print("ddk build to studio copy uses");
--	driver_src_dir = driver_src_dir_prefix..driver_src_dir_choices[myos][bits][build_mode];
--	driver_dest_dir1 = driver_dest_dir1_prefix..driver_dest_dir1_choices[myos][bits][build_mode];
--	print("driver src directory resolves to: "..driver_src_dir);
--	print("\tdriver dest dir1:"..driver_dest_dir1);
--	print("--");
--	print("studio mystr copy uses");
--	print("\ttodo");
	print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
end


function update_for_studio_build() 

	print("Update Studio Driver Libs Build");

	driver_src_dir = driver_src_dir_prefix..driver_src_dir_choices[myos][bits][build_mode];
	driver_dest_dir1 = driver_dest_dir1_prefix..driver_dest_dir1_choices[myos][bits][build_mode];
	copycmd="copy "..driver_src_dir.."dbgdrv.sys "..driver_dest_dir1
	print(copycmd);
	os.execute(copycmd);
	print("************************");
end

fw_dest_dir_prefix = top_dir.."mystr_release\\"
fw_dest_dir_choices = {
						linux =		{
										bits_32 =	{
												release="narelease32\\", 
												debug="nadebug32\\" 
												},
										bits_64 =	{
												release="fixmerelease64\\", 
												debug="fixmedebug64\\" 
												}
									},
						winXP = 	{
										bits_32 =	{
												release="Framework\\build\\ia32\\win2k\\release\\bin\\", 
												debug="Framework\\build\\ia32\\win2k\\debug\\bin\\"
												},
										bits_64 =	{
												release="x64\\release\\", 
												debug="x64\\debug\\"
												}
									},
						win2003 = 	{
										bits_32 =	{
												release="release\\", 
												debug="debug\\"
												},
										bits_64 =	{
												release="Framework\\build\\x64\\win2k\\release\\bin\\", 
												debug="Framework\\build\\x64\\win2k\\debug\\bin\\"
												}
									}
						}
function update_for_mystr_gaa_build() 

	print("Update mystr gaa Build");
	-- src includes
	driver_src_inc_dir1 = driver_inc_dir_prefix
	driver_src_inc_dir2 = driver_inc_dir_prefix.."windows\\"

	-- dest includes
	driver_dest_dir1 = driver_mystr_dir_prefix.."gaa\\Include\\"

	-- do the inc copies
	copycmd="copy "..driver_src_inc_dir1.."*.h "..driver_dest_dir1
	print(copycmd);
	os.execute(copycmd);
	copycmd="copy "..driver_src_inc_dir2.."*.h "..driver_dest_dir1
	print(copycmd);
	os.execute(copycmd);
	print("************************");

	-- src lib dir
	-- the src here is the studio directory which was the destination of the first copy.  That is
	-- why the variable gets its name from the driver_dest... stuff.
	driver_src_dir1 = driver_dest_dir1_prefix..driver_dest_dir1_choices[myos][bits][build_mode];
	
	-- dest lib dir
	driver_dest_dir1 = driver_mystr_dir_prefix.."gaa\\"

	-- do the lib copies
	copycmd="copy "..driver_src_dir1.."*.lib "..driver_dest_dir1
	print(copycmd);
	os.execute(copycmd);
	print("************************");
	-- copy the driver dbgdrv.sys to the final runtime directory
	driver_src_dir = driver_src_dir_prefix..driver_src_dir_choices[myos][bits][build_mode];
	fw_dest_dir = fw_dest_dir_prefix..fw_dest_dir_choices[myos][bits][build_mode];
	copycmd="copy "..driver_src_dir.."dbgdrv.sys "..fw_dest_dir
	print(copycmd);
	os.execute(copycmd);
	print("************************");
end


function print_all_tables() 

	-- 32-bit linux debug
	bits=bit_choices[1] 
	myos=myos_choices[1] 
	build_mode = build_mode_choices[2]
	dump_dir_tables();


	-- 32-bit linux release
	bits=bit_choices[1] 
	myos=myos_choices[1] 
	build_mode = build_mode_choices[1]
	dump_dir_tables();

	-- 64-bit linux debug
	bits=bit_choices[2] 
	myos=myos_choices[1] 
	build_mode = build_mode_choices[2]
	dump_dir_tables();

	-- 64-bit linux release
	bits=bit_choices[2] 
	myos=myos_choices[1] 
	build_mode = build_mode_choices[1]
	dump_dir_tables();

	-- 32-bit windows debug
	bits=bit_choices[1] 
	myos=myos_choices[2] 
	build_mode = build_mode_choices[2]
	dump_dir_tables();


	-- 32-bit windows release
	bits=bit_choices[1] 
	myos=myos_choices[2] 
	build_mode = build_mode_choices[1]
	dump_dir_tables();

	-- 64-bit windows debug
	bits=bit_choices[2] 
	myos=myos_choices[2] 
	build_mode = build_mode_choices[2]
	dump_dir_tables();

	-- 64-bit windows release
	bits=bit_choices[2] 
	myos=myos_choices[2] 
	build_mode = build_mode_choices[1]
	dump_dir_tables();



	-- 32-bit windows2003 debug
	bits=bit_choices[1] 
	myos=myos_choices[3] 
	build_mode = build_mode_choices[1]
	dump_dir_tables();

	-- 32-bit windows release
	bits=bit_choices[1] 
	myos=myos_choices[3] 
	build_mode = build_mode_choices[2]
	dump_dir_tables();


	-- 64-bit windows2003 debug
	bits=bit_choices[2] 
	myos=myos_choices[3] 
	build_mode = build_mode_choices[1]
	dump_dir_tables();

	-- 64-bit windows release
	bits=bit_choices[2] 
	myos=myos_choices[3] 
	build_mode = build_mode_choices[2]
	dump_dir_tables();

end


-- Default configuration is 32-bit debug.
-- 32-bit windows debug
bits=bit_choices[1] 
myos=myos_choices[2] 
build_mode = build_mode_choices[2]

-- However, they can be overridden by command line options.


--- [[ Command line parameters are passed to your lua program as a table of strings called arg ]]
--

print("--");
-- Command line option handling
for posn, val in ipairs (arg) do

	cmdFound = nil;

	-- look for help or usage parameter
	if val=="usage" or val=="help" then 
		cmdFound = 1;
		print_usage() 
	end
	
	-- look for bits specifier
	the_start,the_end=string.find(val,"bits=")
	if the_start==1 and the_end==5 then 
		--print(string.find(val,"bits="));
		--print(#val);
		specified_bits= string.sub(val,the_end+1, #val);
		--print(specified_bits);
		if specified_bits=="32" then
			cmdFound = 1;
			bits=bit_choices[1] 
		elseif specified_bits=="64" then
			cmdFound = 1;
			bits=bit_choices[2] 
		else
			print("invalid bit specifier ("..specified_bits..") Early Exit.");
			os.exit();
		end
	end
	
	-- look for mode specifier
	if val=="debug" or val=="checked" then 
		cmdFound = 1;
		build_mode = build_mode_choices[2]
	end
	if val=="free" or val=="release" then 
		cmdFound = 1;
		build_mode = build_mode_choices[1]
	end

	
	-- look for OS specifier
	if val=="winXP" or val=="win" or val=="winxp" then 
		cmdFound = 1;
		myos=myos_choices[2] 
	end
	if val=="win2003" or val=="win2K" or val=="win2k" then 
		cmdFound = 1;
		myos=myos_choices[3] 
	end
	if val=="linux"  then 
		cmdFound = 1;
		myos=myos_choices[1] 
	end

	-- look for help or usage parameter
	if cmdFound == nil then 
		print("Unknown option ("..val..") Early Exit.");
		print_usage() 
		os.exit();
	end
	

end


print("--");
dump_dir_tables() 
update_for_studio_build(); 
update_for_mystr_gaa_build() 


print("--");
print("program complete.")
print("Normal exit.")
