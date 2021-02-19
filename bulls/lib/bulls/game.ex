defmodule Bulls.Game do
	def new do
		%{
			digits: random_digits(),
			warning: "",
			recorded: []
		}
	end

	def guess(st, digits) do
		#player cannot guess if game is over
		if gameOver(st) do
			st
		end
		#validate guess for format
		newWarning = validate(st, digits)
		#update recorded guesses as needed
		if (String.length(newWarning) > 0) do
			%{
				digits: st.digits,
				warning: newWarning,
				recorded: st.recorded
			}
		else
			guessArr = String.graphemes(digits) |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end) 
			newRecorded = st.recorded ++ [[digits, report(st.digits, guessArr)]]
			IO.inspect(newRecorded)
			%{
				digits: st.digits,
				warning: newWarning,
				recorded: newRecorded
			}
		end
	end

	# provides a comparison report of guessed digits to the secret
	# assumes digits is a validated array of digits
	# returns string form "A{perfect}B{misplaced}"
	def report(secret, digits) do
		res = for n <- 0..3 do
			cond do
				Enum.fetch!(digits, n) == Enum.fetch!(secret, n) -> "A"
				Enum.member?(secret, Enum.fetch!(digits, n)) -> "B"
				true -> "C"
			end
		end
		
		"A" <> Integer.to_string(Enum.count(res, fn x -> x == "A" end))
		<> "B" <> Integer.to_string(Enum.count(res, fn y -> y == "B" end))
	end

	def validate(st, guess) do
		cond do
			String.length(guess) != 4 -> 
				"Valid guesses must be exactly 4 digits";
			!uniqueDigits(guess) ->
				"Valid guesses cannot have duplicate digits or non-digit characters.";
			duplicateGuess?(st.recorded, guess) ->
				"Cannot reuse recorded guess";
			true ->
				""
		end
	end

	def duplicateGuess?(recorded, guess) do
		Enum.map(recorded, fn n -> Enum.fetch!(n, 0) end) |> Enum.member?(guess)
	end
	
	def uniqueDigits(guess) do
		guessList = String.graphemes(guess)
		!Enum.any?(guessList, fn x ->
			Enum.count(guessList, fn n -> n == x end) > 1
			|| !isDigit(x) end)
	end

	def isDigit(digit) do
		case Integer.parse(digit) do
			{n, ""} -> 
				true
			:error -> false
			_ -> false
		end
	end

	def view(st) do
		%{
			warning: st.warning,
			recorded: st.recorded
		}
	end
	
	def random_digits(available \\ 0..9) do
		if Enum.count(available) > 6 do
			a = Enum.random(available)
			[a | random_digits(Enum.filter(available, fn n -> n != a end))]
		else
			[]
		end
	end
	
	def gameOver(state) do
		Enum.count(state.recorded) == 8 ||
		Enum.any?(state.recorded,
			fn x -> Enum.fetch!(x, 0) |> String.graphemes |> Enum.map(fn y -> elem(Integer.parse(y), 0) end) == state.digits end)
	end
end
