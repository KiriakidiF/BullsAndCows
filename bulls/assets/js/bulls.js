import React, { useState, useEffect } from 'react';
import * as util from './gameUtil.js';
import * as socket from './socket.js';

// Guess is the input box and button for guessing the digits
// as well as the warning for invalid guesses
// the textbox and button are disabled if the game is over
// Both pressing "Enter" and the button will validate/attempt a guess
function Guess({guess, setGuess, state, tryGuess}) {
	
	function enter(evt) {
		if (evt.key == "Enter") {
			tryGuess();
		}
	}

	function type(evt) {
		setGuess(evt.target.value);
	}

	if (util.gameOver(state.recorded)) {
		return (
			<div>
				<p id="Guess">
					<input disabled type="text" value={guess} onChange={type} onKeyPress={enter} />
					<button disabled onClick={tryGuess}>Guess</button>
				</p>
				<p id="Warn">{state.warning}</p>
			</div>
		);
	}
	else {
		return <div>
				<p id="Guess">
					<input type="text" value={guess} onChange={type} onKeyPress={enter} />
					<button onClick={tryGuess}>Guess</button>
				</p>
				<p id="Warn">{state.warning}</p>
			</div>;
	}
}
	
// A Record is a pairing of a guessed set of 4 unique digits
// and the report of how many digits were correctly guess (A)
// and how many are present in the secret but in a different position (B)
function Record({guess}) {
	if (guess == undefined) {
		return (
			<tr>
				<td></td>
				<td></td>
			</tr>
		);
	}
	return (
		<tr>
			<td>{guess[0]}</td>
			<td>{guess[1]}</td>
		</tr>
	);
}

// Status bar that states the number of guesses remaining while the game is ongoing
// as well as the result if the game is over
function Status({state}) {
		if (util.gameWon(state.recorded)) { 
			return <p id="Win">You Win!</p>
		}
		else if (util.gameLost(state.recorded)) { 
			return <p id="Lose">You Lose!</p>
		}
		else {
			var msg = "Guesses left: " + (8 - state.recorded.length)
			return <p>{msg}</p>;
		}
	}

export function Bulls() {	
	// game state is a warning message for invalid inputs
	// and the recorded guesses
	const [state, setState] = useState({
		warning: "",
		recorded: []
	});
	const [guess, setGuess] = useState("");

	useEffect(() => {
		socket.cb_join(setState);
	});

	// resets the game state and current guess 
	// obtains a new secret set of digits to guess
	function reset() {
		socket.cb_push("reset", "")
		//setState({
		//	secret: util.genRand4(),
		//	warning: "",
		//	recorded: []
		//});
		setGuess("");
	}

	// logic for submitting a guesss assuming it was validated
	// records the guess and resets the current guess
	function tryGuess() {
		socket.cb_push("guess", guess);
		setGuess("");
		//if (!util.gameOver(state.recorded, state.secret)) {
		//	let prev = state.recorded;
	//		prev.push(guess);
	//		setState({secret: state.secret, warning: "", recorded: prev});
	//		setGuess("");
	//	}
	}

	return (
		<div className="Game">
			<header>
				<h1>TKWaffle Bulls and Cows</h1>
			</header>

			<div className="Menu">
				<button onClick={reset}>New Game</button>
			</div>
				
			<div className="StatusBar">
				<Status state={state} />
			</div>

			<Guess guess={guess} setGuess={setGuess}
					state={state} tryGuess={tryGuess} />
			
			<table id="Recorded">
				<tbody>
					<tr>
						<th>Guess</th>
						<th>Result</th>
					</tr>
					<Record guess={state.recorded[0]} />
					<Record guess={state.recorded[1]} />
					<Record guess={state.recorded[2]} />
					<Record guess={state.recorded[3]} />
					<Record guess={state.recorded[4]} />
					<Record guess={state.recorded[5]} />
					<Record guess={state.recorded[6]} />
					<Record guess={state.recorded[7]} />
				</tbody>
			</table>

		</div>
	);
}

export default Bulls;
