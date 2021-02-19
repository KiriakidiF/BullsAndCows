// Generated a random integer from 0 to input n (exclusive)
function getRandInt(n) {
	var res =  Math.floor(Math.random() * n);
	return res;
}

// Produces a randomized 4-digits number as an array of unique digits
export function genRand4() {	
	var digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
	var res = [];

	for (var i = 9; i > 5; i = i - 1) {
		// get random index to choose from digits
		var index = getRandInt(i);
		// places digit at correct index in number
		res.push(digits[index]);
		digits.splice(index, 1);
	}

	return res;
}	

// returns whether input string is only made up of digits and every digit is unique
export function uniqueDigits(guess) {
	for (var i = 0; i < guess.length; i++) {
		var chr = guess.substring(i, i+1);
		// checks the case that the character is not a number
		if (chr == " " || isNaN(Number(chr))) {
			return false;
		}
		// return false if current character is found in the rest of the input
		if (guess.substring(i+1, guess.length).includes(chr)) {
			return false;
		}
	}
	return true;
}

export function gameOver(recorded) {
	return gameLost(recorded) || gameWon(recorded);
}

export function gameLost(recorded) {
	if (recorded.length >= 8) {
		return true;
	}
	return false;
}

export function gameWon(recorded) {
	var last = recorded[recorded.length - 1];

	if (last != undefined && last[1] == "A4B0") {
		return true;
	}
	return false;
}
