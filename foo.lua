return

while (rca) do
	if ( coroutine.status(a) ~= 'dead') then
		rc, rca, prog_success = coroutine.resume(a)
--		if ( prog_success==true and boolean == type(prog_success)) then
		if ( prog_success==true) then
			printf("A prog_success=%s  \n", tostring(prog_sucess))
		end
	end
--	if ( coroutine.status(b) ~= 'dead') then
--		rcb, msgb = coroutine.resume(b)
--		if ( msgb ) then
--			--printf("B rcb=%s \t msg = <%s> \n", tostring(rcb), msgb)
--		end
--	end
--	if ( coroutine.status(c) ~= 'dead') then
--		rcc, msgc  = coroutine.resume(c, rcc, msgc)
--		if ( msgc ) then
--			printf("C rcc=%s \t msg = <%s> \n", tostring(rcc), msgc)
--		end
--	end
end
