

-- This is a program for testing multiple program runs of the
-- the driver test7 unit test.

-- Windows Setup
testy = "test7.exe";
driverList="drivers.exe"	-- windows
--
--
-- Linux Setup
--testy = "./test7";
--driverList="lsmod"			-- linux
--
--
--testy = "c:\\sandbox\\dbgd\\studio\\debug\\test7.exe";

testfile = "c:\\sandbox\\dbgd\\scripts\\tags";
numberOfTasks = 10;
maxdelay = 10;

-- This global table contains the thread id's.
-- The key will be the thread ID.
-- The value will be a second table which contains job info.
active_jobs = {};


-- This routine is for each thread.
-- To maintain thread context you must exit the tread with yield.
-- If you exit with return, there is no way to resume.
--"C:\Program Files\Lua\5.1\lua.exe"
function thread_routine (message, program_args)

	print ("testy program is: ",testy);
	print ("testy args are: ",program_args);


	local f = io.popen(testy.." "..program_args);
	local line;


	while(f) do
--		print(".");
		line = f:read("*line"); -- *all, *line, *number, num

		if (line == nil) then
			f:close();
			return;		-- This will kill the thread.  The program has exited.
		end
		print(line);
		if string.find(line, "Normal exit") then
			local tid = coroutine.running();
			active_jobs[tid].rc=true;
		end;
		coroutine.yield()
	end
end

--printf("Hello %s from %s on %s\n", os.getenv"USER" or "there", _VERSION, os
function printf(fmt, ...)
	io.write(string.format(fmt, ...))
end

-- default parameter example
-- if n is not specified it will increment the global count by 1.
function incCount (n)
      n = n or 1
      count = count + n
end


-- Convert number to letter
function numToLetter(myNumber)
	local myLookup = { "A", "B", "C", "D", "E", "F", "G",
	                    "H", "I", "J", "K", "L", "M", "N",
						"O", "P", "Q", "R", "S", "T", "U",
						"V", "W", "X", "Y", "Z"};

	if (0 == myNumber%26) then
		return ("Z");
	else
		return myLookup[myNumber%26];
	end;
end




--  This function is determines if the driver is loaded
--  or not.  It uses the sysinternals.com driver utility.
--  need to change it for linux to use lsmod.
function isDriverLoaded()


	local f = io.popen(driverList);
	local line;

	while(f) do
--		print(".");
		line = f:read("*line"); -- *all, *line, *number, num

		if (line == nil) then
			f:close();
			return false;		-- This will kill the thread.  The program has exited.
		end
--		print(line);
		if string.find(line, "dbgdrv") then
			return true;
		end;
	end
end


-- start here
print("Start of test7 test framework.")


-- create the thread table
for i=1,numberOfTasks do
	tid = coroutine.create(thread_routine);
	active_jobs[tid] = {}
	active_jobs[tid].program = testy;
	active_jobs[tid].args = numToLetter(i).." "..math.random(1,maxdelay);  -- ID and sleep time.
	active_jobs[tid].mesg = "--- Testy "..i.." ---";
	active_jobs[tid].rc = false;	  -- This is the return code of the program started.  Assume it failed.
	print(active_jobs[tid].args);
end

if isDriverLoaded() then
	printf("driver is already loaded. Type enter to continue.\n");
else
	printf("Driver is not loaded.  Type enter to continue.")
end

userinput = io.stdin:read'*l'
print('userinput',userinput)



print("Threads are created.")


-- Kick start all the jobs once.
-- The resume will start a coroutine specified by a handle.  It will continue to run until the coroutine yields itself.
-- The second parameters are the parameters passed to the coroutine.
for key, value in pairs(active_jobs) do
	coroutine.resume(key, value.mesg, value.args);
end
print("---Threads are started.----------")


while (next(active_jobs)) do
	for key, value in pairs(active_jobs) do
		if ( coroutine.status(key) ~= 'dead') then
			coroutine.resume(key)
		else
			-- The job is done.  Remove it from the list of jobs.
			printf("\t Job Complete -----------------\n")
			printf("\t program \t %s \n", value.program)
			printf("\t args \t %s \n", value.args)
			printf("\t rc \t %s \n", tostring(value.rc))
			printf("\t-------------------------------\n")
			active_jobs[key] = nil;
		end
	end
end
print("---Threads have finished.----------")

-- Check for driver loaded.


if isDriverLoaded() then
	printf("Diver is still loaded.  This is bad. \n");
else
	printf("Diver is not loaded.  This is good. \n");
end



print("program complete.")
print("Normal exited")

