for j=-6,127 do
	local b = {}
	for k=0,100,5 do
		if math.floor(k*j/100) ~= math.floor(k*(j-1)/100) then
			b[#b+1] = k
		end
	end
	print(j, table.concat(b, ", "))
end
