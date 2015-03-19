

-- This is a test of threads in LUA.


-- This routine is for each thread.
-- To maintain thread context you must exit the tread with yield.
-- If you exit with return, there is no way to resume.
function thread_routine (message, count)


	if (10 == count) then
--		coroutine.yield(message,os.execute("notepad.exe")) -- this will return "true for yield, message and then count"
		coroutine.yield(message,io.popen("notepad.exe")) -- this will return "true for yield, message and then count"

	end

	while(true) do
		print("This is the thread routine: "..message.." "..count);

		if (0 == count) then
			return false  -- this will return "true for return, then false"
		end

		count = count - 1;

		coroutine.yield(message, count) -- this will return "true for yield, message and then count"
	end
end

--printf("Hello %s from %s on %s\n", os.getenv"USER" or "there", _VERSION, os
function printf(fmt, ...)
	io.write(string.format(fmt, ...))
end

-- start here
print("Start of thread test program.")
-- These routines create a coroutine and the return is handle to the coroutine.
a = coroutine.create(thread_routine);
b = coroutine.create(thread_routine);
c = coroutine.create(thread_routine);
print("Threads have been created.")


-- resume will start a coroutine specified by a handle.  It will continue to run until the coroutine yields itself.
-- The second parameter is the parameter passed to the coroutine.
rca, msga, counta = coroutine.resume(a,"testa", 10)

rcb, msgb, countb = coroutine.resume(b,"testb", 3)
rcc, msgc, countc = coroutine.resume(c,"testc", 4)
print("---Threads have been started.----------")


while (msga or msgb or msgc) do
	if ( coroutine.status(a) ~= 'dead') then
		rca, msga, counta = coroutine.resume(a)
		if ( msga ) then
			printf("A rca=%s \t msg = <%s> \t count =%s\n", tostring(rca), msga, counta)
		end
	end
	if ( coroutine.status(b) ~= 'dead') then
		rcb, msgb, countb  = coroutine.resume(b)
--		rcb, msgb, countb  = coroutine.resume(b, rcb, msgb, countb )
--      Either way it does not matter.
		if ( msgb ) then
			printf("B rcb=%s \t msg = <%s> \t count =%s\n", tostring(rcb), msgb, countb)
		end
	end
	if ( coroutine.status(c) ~= 'dead') then
		rcc, msgc, countc  = coroutine.resume(c, rcc, msgc, countc )
		if ( msgc ) then
			printf("C rcc=%s \t msg = <%s> \t count =%s\n", tostring(rcc), msgc, countc)
		end
	end
end


print("Resumes are complete.")


--d = os.execute("notepad.exe c:\\foo.txt")
--print(d);

print("programcomplete.")


