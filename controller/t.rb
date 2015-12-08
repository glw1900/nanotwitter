
def top_n_word(str,n)
	str.split(/\s+/, n+1)[0...n].join(' ')
end


str  = "This syntax is ventax"

print top_n_word(str,20)