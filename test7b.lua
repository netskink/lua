

-- This is a test of threads in LUA.

--testy = "c:\\sandbox\\dbgd\\studio\\debug\\test0.exe";
--testy = "c:\\sandbox\\dbgd\\studio\\debug\\versiontest.exe";
testy = "c:\\sandbox\\dbgd\\studio\\debug\\test7.exe";
--testyargs1 = "";
testfile = "c:\\sandbox\\dbgd\\scripts\\tags";


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

-- start here
print("Start of thread test program.")
-- These routines create a coroutine and the return is handle to the coroutine.
tid = coroutine.create(thread_routine);
active_jobs[tid] = {}
active_jobs[tid].program = testy;
active_jobs[tid].args = "AA 1";
active_jobs[tid].mesg = "--- Testy A ---";
active_jobs[tid].rc = false;	  -- This is the return code of the program started.  Assume it failed.
-- todo: add additional jobs.
tid = coroutine.create(thread_routine);
active_jobs[tid] = {}
active_jobs[tid].program = testy;
active_jobs[tid].args = "BB 5";
active_jobs[tid].mesg = "--- Testy B ---";
active_jobs[tid].rc = false;	  -- This is the return code of the program started.  Assume it failed.
-- todo: add additional jobs.
tid = coroutine.create(thread_routine);
active_jobs[tid] = {}
active_jobs[tid].program = testy;
active_jobs[tid].args = "CC 3";
active_jobs[tid].mesg = "--- Testy C ---";
active_jobs[tid].rc = false;	  -- This is the return code of the program started.  Assume it failed.

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

print("program complete.")

