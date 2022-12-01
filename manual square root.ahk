; method from https://www.youtube.com/watch?v=AMnDmDOXH04

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

InputBox, input, , Please enter any number., , 185, 125 ; only supports integers
InputBox, iterations, , Please enter how many decimal places the result should have., , 380, 125


MsgBox % "Manual Root: " getRoot(input, iterations)"`nRoot-Function: " Sqrt(input)

getRoot(input, iterations) {
	setFloatFormat(iterations)
	
	perfectSquare := input
	While !isInt？(Sqrt(perfectSquare)) {
		perfectSquare -= 1
	}
	perfectRoot := floor(Sqrt(perfectSquare)) ; floor for removing trailing zeros BUT also any decimals
	
	finalRoot := perfectRoot
	
	i := 0
	remPrev := (Input - perfectSquare)*100 	  ; for the 2 extra (red) zeros
	While (i < iterations) { 			  ; maybe an extra function?
		rem := doIteration(i, remPrev, finalRoot)
		remPrev := rem
		i++
	}
	
	return Round(finalRoot* shiftComma(iterations+1)) * shiftComma(-(iterations+1))
}

doIteration(i, remPrev, ByRef fR) {
	resVec := checkWeirdFormula(fR*shiftComma(i)*2, remPrev)
	remNext := (remPrev - resVec.x)*100 ; resVec.x = res
	fR += resVec.y*shiftComma(-(i+1))   ; resVec.y = 1 digit outcome
	return remNext
}


setFloatFormat(dp) { ; when I try to use switch, it errors
	if (dp == 1)
		SetFormat, Float, 0.1
	else if (dp == 2)
		SetFormat, Float, 0.2
	else if (dp == 3)
		SetFormat, Float, 0.3
	else if (dp == 4)
		SetFormat, Float, 0.4
	else if (dp == 5)
		SetFormat, Float, 0.5
	else if (dp == 7)
		SetFormat, Float, 0.7
	else if (dp == 8)
		SetFormat, Float, 0.8
	else if (dp == 9)
		SetFormat, Float, 0.9
	else SetFormat, Float, 0.6
}

isInt？(input) { ; if input is any number of digits, a decimal point and 2 to * zeros
	return RegExMatch(input, "^\d*\.00*$")
}

shiftComma(by) { ; by < 0 => move it to the right ; by > 0 => move it to the left
	return (10 ** (by))
}

checkWeirdFormula(double, max) { ; 12_ * _ <= 200
	i := 1 								; exclude 0 because x*0 = 0<max in every case
	double *= 10 							; to easily "add" i
	resList := [] 							; because it can be multiple results
	While (i <= 9) {		
		res := (double + i) * i 				; 12i * i <= 200 ; 122i * i <= 7900 (just the first 2 iterations as shown in the video)
		If (res <= max) {
			resVec := New Vec2(res,  i) 			; for returning res as well as i
			resList.Push(resVec)
		}
		i := i + 1
	}
	
	lastVec := resList[resList.MaxIndex()] 				; i only want the highest result that is still smaller than max
	return lastVec
}

Class Vec2 {
	__New(x ,y){
		This.X:=x
		This.Y:=y
	}
}
