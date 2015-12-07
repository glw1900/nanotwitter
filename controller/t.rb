
def top_n_word(str,n)
	str.split(/\s+/, n+1)[0...n].join(' ')
end


str  = "This syntax is very clear (as it doesn't use regular expression, array slice by index). If you program in Ruby, you know that clarity is an important stylistic choice.
A shorthand for join is * So this syntax str.split.first(n) * ' ' is equivalent and shorter (more idiomatic, less clear for the uninitiated)."

print top_n_word(str,20)