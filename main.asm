
INCLUDE Irvine32.inc
.data
;;;;;READING WORDS DATA;;;;;;;;;;;;;;;;;

FileNameStrings byte 50 dup(?) ,0
fileHandle HANDLE ?
DataFileStrings byte 100000 Dup(?),0
character_Strings dword ?
array_Strings byte 100000 Dup(?),0
Strings_Offset dword 100000 Dup(0),0
Size_of_Word_Used_in_play dword ?
counter dword 0
stringoffset dword ?
;;;;;;;;;;;;READING WORD END DATA;;;;;;;;;;;

;;;;;;;;;;;;;;;Game Variables and arrays DATA;;;;;;;;;;;;;;;;;;
beforePlaying dword ?
LevelTrials byte 5
menustate dword ?
wrongLetters byte 5 dup(?)
wrongLettersCount dword ?
trials byte 5
count byte ?
stringout byte 100 dup(?),0
;;;;;;;;;;;;;;;;;;;;;;; END GAME DATA;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;MESSAGES DATA;;;;;;;;;;;;;;;;;;;;;;;;;;;;
messEnter byte "Enter a Chatacter : ",0
notinword byte "Not in Word : ",0
lose byte "		You Lose !",0
livesleft byte "Lives Left : ",0
try byte "		you tried : ",0
let byte " Letters",0
 win byte "		You Win",0
 time byte "		Game Took You : ",0
 mil byte " MilliSeconds.",0
 winlevel1 byte "		Congratulations You have succeeded in Level 1 ",13,10,"			Do you want to Play Level 2 ? (y or n)"	,0
 playagain byte "Do you want to Play again ? (y or n)" , 0
 gameover byte "		Congratulations you have finished the game and Your Score : ",0
  level byte "					Level ",0  	
	messname byte " Enter Your Name : ",0
;;;;;;;;;;;;;;;;;;;;;;;;;;MESSAGES DATA END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;hall of fame DATA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;Data of Read Scores in File;;;;;;;;;;
FileNameScores byte "Scores.txt",0
fileHandleScores HANDLE ?
DataFileScores byte 100000 Dup(?)
character_Scores dword ?
Scores_Offset dword 10 Dup(0)
rows_count dword 0
Scores dword 10 Dup (0)
score_index dword ?
    ;;;;;;End of Data of Read Scores in File;;;;;
	   ;;;;;;;Data of Read Users in File;;;;;;;;;;
FileNameUsers byte "UserNames.txt",0
fileHandleUsers HANDLE ?
DataFileUsers byte 100000 Dup(?)
character_Users dword ?
UsersOffset dword 10 Dup(0)
    ;;;;;;End of Data of Read Users in File;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Score_Right_Postion dword 0
multiplier dword ?
sum dword ?
Score_Size dword 0
UserName byte 100 Dup(?),0
Score dword ?
User_Name_size dword ?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;HALL OF FAME DATA END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.code
DisplayCredits PROC
.data
credits1 byte    "               ||HangMan Game||             ",0
credits2 byte    "    HangMan Game is an amazing game .. you will guess a hidden sentence in a few time to Obtain high Score  ",0

credits3 byte    "          Developed By :",0
credits4 byte    "                       Mahmoud Hamed Mohammed Deif",0
credits5 byte    "                       Ahmed Mohammed SaadAllah",0
credits6 byte    "                       Ahmed AbdelHamid",0
credits7 byte    "                       Asmaa Hamed Mohammed",0
credits8 byte    "                       Shaimaa Ahmed AbdelMaqsoud",0
.code
call clrscr
	call crlf
	call crlf
	call crlf
	call crlf
	call crlf

mov eax, yellow 
	call SetTextColor
	mov edx , offset credits1
	call writestring
	call crlf
	mov edx , offset credits2
	call writestring
		call crlf

	mov edx , offset credits3
	call writestring
		call crlf

	mov edx , offset credits4
	call writestring
		call crlf

	mov edx , offset credits5
	call writestring
		call crlf

	mov edx , offset credits6
	call writestring
		call crlf

	mov edx , offset credits7
	call writestring
		call crlf

	mov edx , offset credits8
	call writestring
		call crlf

RET
DisplayCredits ENDP
;;;;;;;Procedure1;;;;;;;;
; choice in edi
ReadDataStrings proc
.data
animalpath byte "Animals.txt",0
capitalpath byte "Capitals.txt",0
moviespath byte "Movies.txt",0
.code

mov  edx,offset FileNameStrings
mov ecx , 50
clrpath:
	mov byte ptr [edx] , 0
	inc edx
loop clrpath
mov  edx,offset FileNameStrings
cmp edi , 1
je animal 
cmp edi , 2
je movies
cmp edi , 3
je capitals
animal:
;;;;;;;;;;;;;Copy String PROCEDURE;;;;;;;;;;;;;;;;;;;;;
; mov source offset in esi
; mov distination offset in edx
;mov ecx length of source
		mov esi , offset animalpath
		mov ecx , 11
		call copystring
	jmp reading
movies:
	mov esi , offset moviespath
		mov ecx , 10
		call copystring
	jmp reading
capitals:
	mov esi , offset capitalpath
		mov ecx , 12
		call copystring

reading:
 mov  edx,offset FileNameStrings
 call OpenInputFile
 mov  fileHandle, eax
 mov  eax,fileHandle
 mov  edx,offset DataFileStrings
 mov  ecx,100000
 call ReadFromFile
 mov character_Strings,eax
 mov eax , fileHandle
 Call CloseFile
ret
ReadDataStrings Endp
;;;;;;;;;;;;;Copy String PROCEDURE;;;;;;;;;;;;;;;;;;;;;
; mov source offset in esi
; mov distination offset in edx
;mov ecx length of source
copystring proc uses edx esi eax
cpy:
	mov al , [esi]
	mov [edx],al
	inc edx
	inc esi
loop cpy

ret
copystring endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;Procedure2;;;;;;;;;;;;;;;;;
operationsDataStrings proc
 mov counter,0
 mov eax,0
 mov esi,offset DataFileStrings
 mov edi,offset array_Strings
 mov edx ,offset Strings_Offset+4
 mov ecx,character_Strings
 L1:
 mov bl,[esi]
 cmp bl,13
 jE NewLine
 mov [edi],bl
 inc counter
 inc esi
 inc edi
 jmp Continue
 NewLine:
 add esi,2
 sub ecx,1
 mov eax,counter
 mov [edx],eax
 add edx,4
 Continue:
 Loop L1
 mov eax,counter
 mov [edx],eax
ret
operationsDataStrings Endp


;;;;;;;;procedure 3;;;;;;;;;;;;;;;;
RandomGeneratorofWords proc
		 mov eax,20
		 call RandomRange
		 
		 mov esi,offset Strings_Offset
		 mov ebx,4
		 mul ebx
		 add esi,eax
		 mov ebx,[esi+4]
		 sub ebx,[esi]
		 mov Size_of_Word_Used_in_play ,ebx
		 mov eax,Size_of_Word_Used_in_play
		 
		 mov edx , offset array_Strings
		 add edx , [esi]
		 mov stringoffset , edx
		
ret
RandomGeneratorofWords ENDP

;Hide a word by converting every character to '_'
; input the offset of the word in edx
; input the offset of the output word in esi
;mov size in ecx
HideWord Proc uses edx ecx esi
l1:                                                        ;;;;;;
	mov al , [edx]                                         ;;;;;;  
	cmp al , ' '                                           ;;;;;;
														   ;;;;;; 

	jne notspace                                           ;;;;;;
	 mov [esi],al                                          ;;;;;;
	 jmp endloop                                           
	notspace:
	mov al , '_'
	mov [esi] , al
	endloop:
		inc edx
		inc esi
loop l1
RET
HideWord ENDP

;move offset of array in esi 
;move size in ecx
PrintWord Proc uses esi ecx
l2:
	mov al , [esi]
	 call writechar
	 mov al ,' '
	  call writechar
	  inc esi
loop l2
call crlf
RET
PrintWord ENDP

;----------------------------------------------
;;;Receiving Inputs;;;
; char to search stored in al
; mov the offset of the word in edx
; mov the offset of the hidden Word in esi
; mov the size in ecx
;;outPut;;
;the hidden word updated by the character found
; if found then bl = 1 else bl = 0
;------------------------------------------------
CheckInWord PROC uses edx esi ecx
	mov bl , 0
	l3:
	cmp al,[edx]
	jne notfound 
	MOV bl , 1
	mov [esi],al
	notfound:
	inc edx
	inc esi
	
	loop l3
RET
CheckInWord ENDP

;;;;Check if any character in the word is '_';;;;;;
;mov the offset of the hidden word in esi
; mov the size in ecx 
; receive bl = 1 if the word doesn't become hidden
CheckFinished PROC uses esi ecx
mov bl , 1
check_:
	mov al , [esi]
	cmp al , '_'
	je equal
	
	jmp nex
	equal:
		mov bl , 0
		nex:
	  inc esi
 
loop check_
RET
CheckFinished ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PLAAAAAAAAAAYYY;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Play Proc
call GetMseconds
mov beforePlaying , eax
call RandomGeneratorofWords

 mov edx , offset level 
 call writestring
 mov eax , 2
 cmp LevelTrials , 2
 je printlevel
 mov eax , 1
 mov Score , 0
 printlevel:
	call writedec
	call crlf
 mov count , 0
 mov wrongLettersCount , 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
              ;converting a word to _ _ _                  ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;mov edx , offset string   
mov edx , stringoffset										  ;;;;;;
mov ecx ,Size_of_Word_Used_in_play ;lengthof string -1                               ;;;;;;
mov esi , offset stringout                                 ;;;;;;
call HideWord
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        print the outword
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
call PrintWord

call DrawNonHang
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov al , LevelTrials
mov trials , al
;;;Printing trials left
	 mov edx ,offset livesleft
	 call writestring
	 movzx eax , trials
	 call writedec
	 call crlf
	 ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov edi , offset wrongLetters


whileloop:
	mov edx , offset messEnter
	call writestring
	mov edx , stringoffset
	mov esi , offset stringout
	mov ecx ,Size_of_Word_Used_in_play ;lengthof string
	call readchar 
	inc count 
	call writechar
	call crlf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	      check if the entered character is in the word
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
	call CheckInWord
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	cmp bl , 0
	jne success
	mov ah , trials
	dec ah 
	mov trials , ah
	
	mov [edi] , al
	inc edi
	inc wrongLettersCount

	jmp next
	success:
	
next:
	call clrscr
	push edx
	push eax
	mov edx , offset level 
 call writestring
 mov eax , 1
 cmp LevelTrials , 5
 je pritlevel
 mov eax , 2
 pritlevel:
	call writedec
	call crlf
	
	pop eax
	pop edx

	call PrintWord

	call CheckFinished

	mov ecx , wrongLettersCount
	cmp ecx , 0
	je ou
	
	mov edx ,offset notinword
	call writestring
	
	mov esi , offset wrongLetters
	call PrintWord

	ou:
	mov dl , bl
	mov dh , ah
	
	cmp wrongLettersCount , 0
	jne hanged
	call DrawNonHang
	jmp skiphanged
	hanged:
	movzx eax , LevelTrials
	movzx ebx , trials
	sub eax , ebx
	cmp LevelTrials , 5
	je lev1
	mov ebx , 2
	jmp lev2
	lev1:
	mov ebx , 1
	lev2:
	call DrawHang
	
	skiphanged:
	push edx
	;;;Printing trials left
	 mov edx ,offset livesleft
	 call writestring
	 movzx eax , trials
	 call writedec
	 call crlf
	 ;;;;;;;;;;;;;;;
	 pop edx
	cmp dl , 1
	je won
	cmp dh , 0
jne whileloop

	mov ebx , 0
	mov eax, lightred (lightGray * 16) 
	call SetTextColor
mov edx , offset lose
call writestring 
call crlf
mov eax, DefaultColor 
	call SetTextColor
	mov edx , stringoffset
	mov ecx , Size_of_Word_Used_in_play
	rightword:
		mov al , [edx]
		call writechar
		inc edx
	loop rightword
	call crlf
jmp endgame
won:
	mov ebx , 1
	mov edx , offset win
	call writestring
	call crlf
endgame:
mov edx, offset  try 
call writestring 
movzx eax ,count 
call writedec
mov edx , offset let
call writestring
call crlf 
mov edx , offset time
call writestring 
call GetMseconds
sub eax , beforePlaying
call writedec
add Score , eax
mov edx , offset mil 
call writestring
call crlf 
RET
Play ENDP
;;;;;;;;;;;;;;;;;WRITE MENU PROCEDURE;;;;;;;;;;;;;;;;;;;;
; state in ebx
writeMenu PROC
.data
menuborder byte  "				<><><><><><><><><><><><><><><><><><><><><><><><><>",0
playmenu byte    "				||                     Play                     ||",0
hallmenu byte    "				||                 Hall of Fame                 ||",0
creditsmenu byte "				||                    Credits                   ||",0
exitmenu byte    "				||                      Exit                    ||",0
.code
mov eax, white 
	call SetTextColor
	call clrscr

	call crlf
call crlf
call crlf
call crlf
call crlf
call crlf
call crlf

mov edx , offset menuborder
call writestring
call crlf
cmp menustate , 0
je playselected
cmp menustate , 1
je hallselected
cmp menustate , 2
je creditsselected
jmp exitselected

	playselected:
	mov eax, Red ; white on blue
	call SetTextColor
	mov edx , offset playmenu
	call writestring
	call crlf
	mov eax, white ; white on blue
	call SetTextColor
	mov edx , offset hallmenu 
	call writestring
	call crlf
	mov edx , offset creditsmenu
	call writestring
	call crlf
	mov edx , offset exitmenu
	call writestring
	call crlf
	jmp endmenu

	hallselected:
		
	mov edx , offset playmenu
	call writestring
	call crlf

	mov eax, Red ; white on blue
	call SetTextColor

	mov edx , offset hallmenu 
	call writestring
	call crlf
	mov eax, white ; white on blue
	call SetTextColor

	mov edx , offset creditsmenu
	call writestring
	call crlf
	mov edx , offset exitmenu
	call writestring
	call crlf
	jmp endmenu

	creditsselected:
	mov edx , offset playmenu
	call writestring
	call crlf

	

	mov edx , offset hallmenu 
	call writestring
	call crlf

	mov eax, Red ; white on blue
	call SetTextColor

	mov edx , offset creditsmenu
	call writestring
	call crlf
	mov eax, white ; white on blue
	call SetTextColor
	mov edx , offset exitmenu
	call writestring
	call crlf
	jmp endmenu
		exitselected:
			mov edx , offset playmenu
	call writestring
	call crlf

	

	mov edx , offset hallmenu 
	call writestring
	call crlf

	

	mov edx , offset creditsmenu
	call writestring
	call crlf
	mov eax, Red ; white on blue
	call SetTextColor

	mov edx , offset exitmenu
	call writestring
	call crlf
	mov eax, white ; white on blue
	call SetTextColor
	jmp endmenu
			
	endmenu:
		mov eax, white ; white on blue
	call SetTextColor
	mov edx , offset menuborder
	call writestring 
	call crlf

RET
writeMenu ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;DRAW NON-HANG PROCEDURE;;;;;;;;;;;;;;;;;;
DrawNonHang proc 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; the empty drawing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

push edx
mov edx , offset line1
call writestring
call crlf
mov edx , offset line2
call writestring
call crlf
mov edx , offset line3
call writestring
call crlf
mov edx , offset line4
call writestring
call crlf
mov edx , offset line5
call writestring
call crlf
mov edx , offset line6
call writestring
call crlf
mov edx , offset line7
call writestring
call crlf
mov edx , offset line8
call writestring
call crlf
mov edx , offset line9
call writestring
call crlf
mov edx , offset line10
call writestring
call crlf
mov edx , offset line11
call writestring
call crlf
mov edx , offset line12
call writestring
call crlf
pop edx
ret 
DrawNonHang ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;DRAW HANG PROCEDURE;;;;;;;;;;;;;;;;;;;;;;;;;
;mov trials rest in eax
;mov level in ebx
DrawHang Proc
.data
line1 byte       "              _____________________________",0
line2 byte       "               |                           |",0
line3 byte       "               |                           |",0
line4 byte       "               |",0
line5 byte       "               |",0
line6 byte       "               |",0
line7 byte       "               |",0
line8 byte       "               |",0
line9 byte       "               |",0
line10 byte      "               |",0
line11 byte      "          _____|_____",0
line12 byte      "      ---------------------------------------",0
wrong1 byte                       "                           O",0
wrong2 byte                       "                       >---|---<",0
wrong3 byte                       "                           |",0
wrong4 byte                       "                          / \",0
wrong5 byte                       "                        _/   \_",0
.code
push edx

cmp ebx , 1

je level1
mov edx , offset line1
call writestring
call crlf
mov edx , offset line2
call writestring
call crlf
mov edx , offset line3
call writestring
call crlf
mov edx , offset line4
call writestring
mov edx , offset wrong1
call writestring
call crlf


mov edx , offset line5
call writestring
mov edx , offset wrong2
call writestring
call crlf

mov edx , offset line6
call writestring
mov edx , offset wrong3
call writestring
call crlf
cmp eax , 1
je Edrawing

mov edx , offset line7
call writestring
mov edx , offset wrong4
call writestring
call crlf


mov edx , offset line8
call writestring
mov edx , offset wrong5
call writestring
call crlf
cmp eax , 2
je Edrawing

level1:
mov edx , offset line1
call writestring
call crlf
mov edx , offset line2
call writestring
call crlf
mov edx , offset line3
call writestring
call crlf
mov edx , offset line4
call writestring
mov edx , offset wrong1
call writestring
call crlf
cmp eax , 1
je Edrawing

mov edx , offset line5
call writestring
mov edx , offset wrong2
call writestring
call crlf
cmp eax , 2
je Edrawing

mov edx , offset line6
call writestring
mov edx , offset wrong3
call writestring
call crlf
cmp eax , 3
je Edrawing

mov edx , offset line7
call writestring
mov edx , offset wrong4
call writestring
call crlf
cmp eax , 4
je Edrawing

mov edx , offset line8
call writestring
mov edx , offset wrong5
call writestring
call crlf
cmp eax , 5
je Edrawing


Edrawing:
mov edx , offset line9
call writestring
call crlf
mov edx , offset line10
call writestring
call crlf
mov edx , offset line11
call writestring
call crlf
mov edx , offset line12
call writestring
call crlf
pop edx
RET
DrawHang ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;PLAYING PROCEDURE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Playing PROC
.data
mes byte 13,"Enter a choice number to select Words Category : Animals(1) :: Movies(2) :: Capitals(3) ",0
.code
call clrscr
mov edx , offset messname
call writestring
  mov edx , offset UserName
 mov ecx , lengthof UserName
 call readstring
 mov User_Name_size,eax
 

 
 P:
		mov edx , offset mes
	call writestring
	call crlf
	call readdec
	mov edi , eax
	 call ReadDataStrings
	 call operationsDataStrings
	DefaultColor = black (lightGray * 16)
	mov eax, DefaultColor ; white on blue
	call SetTextColor
	call clrscr
	
 call Play ; when the user wins -> ebx = 1 else = 0
 mov ecx ,  character_Strings
	mov edx , offset DataFileStrings
	mov esi , offset array_Strings
	mov edi , offset Strings_Offset
	call ClearDataFile
 cmp ebx , 1
 
 je wi

 mov edx , offset playagain 
 call writestring
 call readchar 
 cmp al , 'y'
 je P
 jmp en
 
 wi:
cmp LevelTrials , 5
je winlvl1
cmp LevelTrials , 2
je finishgame

winlvl1:
 mov edx , offset winlevel1 
 call writestring
	 call readchar 
 cmp al , 'y'
 je accept
 jmp en
 accept:
	mov LevelTrials , 2
	jmp P
	
finishgame:
mov edx , offset gameover
call writestring 
mov eax , Score
call writedec
call crlf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;update and save in scores;;;;;;;;;;;;;;;;;;;;;;;;;;
call Find_Score_Right_Postion
  cmp Score_Right_Postion,5
  jge cont
call AlterScores
call AlterDataFileScores
call AlterScores_Offset
call AlterDataFileUsers
call AlterUsers_Offset
cmp rows_count,5
jae cont
inc rows_count
mov eax,rows_count
or al,00110000b
mov DataFileScores,al
mov DataFileUsers,al
cont:
call crlf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;Save update data in files after user finished game;;;;;;;;;;;;;;;;;;;;;;;;;
call SaveUsersinfile
call SaveScoresinfile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov edx , offset playagain
call writestring 
call readchar
cmp al , 'y'
jne en
mov LevelTrials , 5
jmp P
en:
RET 
Playing ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;CLEAR DATA FILE PROCEDURE;;;;;;;;;;;;;;;;;;;;;;;
;mov ecx ,  character_Strings
	;mov edx , offset DataFileStrings
	;mov esi , offset array_Strings
	;mov edi , offset Strings_Offset
	ClearDataFile PROC
	cler:
		mov byte ptr [edx],0
		mov byte ptr [esi],0
		mov byte ptr [edi],0
		inc edx 
		inc esi
		inc edi
	loop cler
	RET
	ClearDataFile ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;Procedure1;;;;;;;;
;;;;;Read data from Scores File;;;;;
ReadDataScores proc
mov  edx,offset FileNameScores
 call OpenInputFile
 mov  fileHandleScores, eax
 mov  eax,fileHandleScores
 mov  edx,offset DataFileScores
 mov  ecx,100000
 call ReadFromFile
 mov character_Scores,eax
 mov eax,fileHandleScores
 call closefile
 mov eax,0
 mov al,DataFileScores
 and al,11001111b
 mov rows_count,eax
ret
ReadDataScores Endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;procedure2;;;;;;;;;;;;;;
;;;;;;;;;;Procedure to write Final Scores in file;;;;;;;;;;;;;;
SaveScoresinfile proc
mov edx,offset FileNameScores
call createoutputfile
mov   fileHandleScores,eax
mov eax, fileHandleScores
mov edx,offset DataFileScores
mov ecx,character_Scores
call writetofile
mov eax,fileHandleScores
call closefile
ret
SaveScoresinfile ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;procedure3;;;;;;;;;;;;;;;;;;
;;;;;;;; procedure to calculate the offsets of Scores when after reading file Scores ;;;;;;;;;;;;;;;;;;;;;;;;;
operationsDataScores proc
 mov counter,3
 mov Scores_Offset,3
 mov eax,0
 mov esi,offset DataFileScores+3
 mov edx ,offset Scores_Offset+4
 mov ecx,character_Scores
 sub ecx,3
 cmp ecx,0
 jng nxt
 L1:
 mov bl,[esi]
 cmp bl,13
 jE NewLine
 inc counter
 inc esi
 jmp Continue
 NewLine:
 add esi,2
 sub ecx,1
 add counter,2
 mov eax,counter
 mov [edx],eax
 add edx,4
 Continue:
 Loop L1
 add counter,2
 mov eax,counter
 mov [edx],eax
 nxt:
ret
operationsDataScores Endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;procedure4;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;covert score as string come from file into integer;;;;;;;;;;;;;;; 
Store_in_Scores proc
mov score_index,0
mov edi,offset DataFileScores+3
mov esi,offset Scores_Offset
mov ecx,rows_count
cmp ecx,0
jna nxt
l1:
	push ecx
	mov multiplier,1
	mov sum, 0
	mov ecx,[esi+4]
	sub ecx,[esi]
	sub ecx,2
	mov edi,offset DataFileScores
	add edi,[esi+4]
	sub edi,3
	l2:
		mov eax,0
		mov al,[edi]
		and al,11001111b
		mov ebx,multiplier
		mul ebx
		add sum,eax
		dec edi
		mov eax,10
		mov ebx,multiplier
		mul ebx
		mov multiplier,eax
	loop l2
	mov eax,sum
	mov edx,score_index
	mov Scores[edx],eax
	add esi,4
	add score_index,4
	pop ecx
loop l1
nxt:
ret
Store_in_Scores ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;procedure5;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;Find postion of new score in array scores;;;;;;;;;;;;;;; 
Find_Score_Right_Postion proc 
mov Score_Right_Postion,0
mov esi,offset Scores
mov ecx,rows_count
cmp ecx,0
jng break
L1:
mov ebx,[esi]
cmp ebx,Score
JA break
Continue:
inc Score_Right_Postion
add esi,4
Loop L1
break:
ret
Find_Score_Right_Postion ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;procedure6;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;update in array scores when get new score;;;;;;;;;;;;;;; 
AlterScores proc
mov esi,offset Scores
mov eax,rows_count
shl eax,2
add esi,eax
sub esi,4
mov ecx,rows_count
sub ecx,Score_Right_Postion
cmp ecx,0
jng nxt
L1:
mov eax,[esi]
mov [esi+4],eax
sub esi,4
Loop L1
nxt:
mov esi,offset Scores
mov eax,Score_Right_Postion
shl eax,2
add esi,eax
mov eax,Score
mov [esi],eax
mov eax,[esi]
ret
AlterScores ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;procedure7;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;update in array data file Scores when get new score;;;;;;;;;;;;;;; 
AlterDataFileScores proc
mov Score_Size,0
mov ecx,Score
FindScoreSize:
cmp Score,0
JE break
mov edx,0
mov eax,Score
mov ebx,10
div ebx
inc Score_Size
mov Score,eax
jmp FindScoreSize
break:
mov eax,Score_Size
;call writeint
;call crlf
mov Score,ecx
mov esi,offset Scores_Offset
mov eax,Score_Right_Postion
shl eax,2
add esi,eax
mov ecx,character_Scores
add ecx,2
sub ecx,[esi]
cmp ecx,0
jng Continue
mov esi,offset DataFileScores
add esi,character_Scores
mov eax,character_Scores
inc esi
altDataFileScores:
mov al,[esi]
mov ebx,esi
add esi,2
add esi,Score_Size
mov [esi],al
mov esi,ebx
dec esi
Loop altDataFileScores
Continue:
mov edi,offset Scores_Offset
mov esi,offset DataFileScores
mov eax,Score_Right_Postion
shl eax,2
add edi,eax
add esi,[edi]
mov eax,10
mov [esi-1],al
mov eax,13
mov [esi-2],al
add esi,Score_Size
dec esi
mov ecx,Score_Size
storenewscore:
mov edx,0
mov eax,Score
mov ebx,10
div ebx
mov Score,eax
mov eax,Score
mov eax,0
or dl,00110000b
mov al,dl
mov [esi],al
dec esi
Loop storenewscore
mov eax,Score_Right_Postion
cmp eax,rows_count
JNB Cont
mov edi,offset Scores_Offset
mov esi,offset DataFileScores
mov eax,Score_Right_Postion
shl eax,2
add edi,eax
add esi,[edi]
add esi,Score_Size
dec esi
mov eax,13
mov [esi+1],al
mov eax,10
mov [esi+2],al
Cont:
mov eax,Score_Size
add character_Scores,eax
add character_Scores,2
cmp rows_count,5
jb nxt
mov edx,rows_count
shl edx,2
sub edx,4
mov eax,Scores_Offset[edx+4]
sub eax,Scores_Offset[edx]
sub character_Scores,eax
nxt:
ret
AlterDataFileScores ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;procedure8;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;update in array scoresoffset when get new score;;;;;;;;;;;;;;; 
AlterScores_Offset proc
mov edx,0
add edx,rows_count
shl edx,2
mov ecx,rows_count
sub ecx,Score_Right_Postion
add ecx,1
cmp ecx,0
jle continue
alterScore_offset:

mov eax,Scores_Offset[edx]
add eax,Score_Size
add eax,2
mov Scores_Offset[edx+4],eax
sub edx,4
loop alterScore_offset
continue:
ret
AlterScores_Offset ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;procedure9;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;Read users data from file;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ReadUsersData proc
mov edx,offset FileNameUsers
 call OpenInputFile
 mov  fileHandleUsers, eax
 mov  eax,fileHandleUsers
 mov  edx,offset DataFileUsers
 mov  ecx,100000
 call ReadFromFile
 mov character_Users,eax
 mov eax,fileHandleUsers
 Call CloseFile
ret
 ReadUsersData ENDP
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;procedure10;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;Save Name of user after finish game;;;;;;;;;;;;
 SaveUsersinfile proc
mov edx,offset FileNameUsers
call createoutputfile
mov   fileHandleUsers,eax
mov eax, fileHandleUsers
mov edx,offset DataFileUsers
mov ecx,character_Users
call writetofile
mov eax,fileHandleUsers
call closefile
ret
SaveUsersinfile ENDP
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;procedure11;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; procedure to calculate the offsets of usersnames when after reading file Scores ;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 operationsDataUsers proc
 mov counter,3
 mov UsersOffset,3
 mov eax,0
 mov esi,offset DataFileUsers+3
 mov edx ,offset UsersOffset+4
 mov ecx,character_Users
 sub ecx,3
 cmp ecx,0
 jng nxt
 L1:
 mov bl,[esi]
 cmp bl,13
 jE NewLine
 inc counter
 inc esi 
 jmp Continue
 NewLine:
 add esi,2
 sub ecx,1
 add counter,2
 mov eax,counter
 mov [edx],eax
 add edx,4
 Continue:
 Loop L1
 add counter,2
 mov eax,counter
 mov [edx],eax
 nxt:
ret
operationsDataUsers Endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;procedure12;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;Update array of data users ;;;;;;;;;;;;;;;;;;;;;;
AlterDataFileUsers proc
mov esi,offset UsersOffset
mov eax,Score_Right_Postion
shl eax,2
add esi,eax
mov ecx,character_Users
add ecx,2
sub ecx,[esi]
cmp ecx,0
jng continue
mov esi,offset DataFileUsers
add esi,character_Users
inc esi
altDataFileUsers:
mov al,[esi]
mov ebx,esi
add esi,2
add esi,User_Name_size
mov [esi],al
mov esi,ebx
dec esi
loop altDataFileUsers

continue:
mov edi,offset UsersOffset
mov esi,Offset DataFileUsers
mov eax,Score_Right_Postion
shl eax,2
add edi,eax
add esi,[edi]

mov eax,10
mov [esi-1],al
mov eax,13
mov [esi-2],al
add esi,User_Name_size
dec esi
mov edi,offset UserName
add edi,User_Name_size
dec edi
mov ecx,User_Name_size
storenew_username:
mov al,[edi]
mov [esi],al
dec esi
dec edi
Loop storenew_username

mov eax,Score_Right_Postion
cmp eax,rows_count
JNB Cont
mov edi,offset UsersOffset
mov esi,offset DataFileUsers
mov eax,Score_Right_Postion
shl eax,2
add edi,eax
add esi,[edi]
add esi,User_Name_size
dec esi
mov eax,13
mov [esi+1],al
mov eax,10
mov [esi+2],al
Cont:
mov eax,User_Name_size
add character_Users,eax
add character_Users,2
cmp rows_count,5
jb nxt
mov edx,rows_count
shl edx,2
sub edx,4
mov eax,UsersOffset[edx+4]
sub eax,UsersOffset[edx]
sub character_Users,eax
nxt:
ret
AlterDataFileUsers endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;procedure12;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;update of array user offset ;;;;;;;;;;;;;;;;
AlterUsers_Offset proc
mov edx,0
add edx,rows_count
shl edx,2
mov ecx,rows_count
sub ecx,Score_Right_Postion
add ecx,1
cmp ecx,0
jle continue
alterScore_offset:
mov eax,UsersOffset[edx]
add eax,User_Name_size
add eax,2
mov UsersOffset[edx+4],eax
sub edx,4
loop alterScore_offset
continue:
ret
AlterUsers_Offset ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Display_Hall_Of_Fame proc
	.data
	number_of_spaces dword ?
	username_string byte 'UserName',0
	score_string byte 'Score',0
	.code
	call clrscr
	call crlf
	call crlf 
	call crlf
	;;;; displaying space before username_string;;;;;
	mov ecx,2
	mov al,' '
	display_spaces1:
		call writechar
	loop display_spaces1


	;;;;;displaying username_string;;;;;;
	mov edx,offset username_string
	call writestring

	;;;;;displaying spaces between username_string and score_string;;;;;;
	mov number_of_spaces,40
	sub number_of_spaces,lengthof username_string
	sub number_of_spaces,2
	mov ecx,number_of_spaces
	mov al,' '
	display_spaces2:
		call writechar
	loop display_spaces2

	;;;displaying score_string;;;;
	mov edx,offset score_string
	call writestring
	call crlf 
	;;;;;;;displaying each username and its score;;;;;;;;;

	;;;counter to know which username is printed 
	mov counter,0
	mov edx,offset Scores
	mov ecx,rows_count
	display:
		push ecx
		mov esi,offset UsersOffset
		mov eax,counter
		shl eax,2
		add esi,eax
		mov ecx,[esi+4]
		sub ecx,[esi]
		sub ecx,2
		mov number_of_spaces,40
		sub number_of_spaces,ecx
		mov edi,offset DataFileUsers
		add edi,[esi]
		display_username:
			mov al,[edi]
			call writechar
			inc edi
		loop display_username

		mov ecx,number_of_spaces
		mov al,' '
		display_spaces3:
			call writechar
		loop display_spaces3

		;;;;display score
		mov eax,[edx]
		call writedec
		call crlf

		add edx,4
		inc counter
		pop ecx
	loop display
	ret
Display_Hall_Of_Fame endp


main PROC
	.data
	asktomenu byte "Press b to back to Main Menu or any key to Exit",0
	.code
call ReadDataScores
call operationsDataScores
call Store_in_Scores
call ReadUsersData
call operationsDataUsers


; Up arrow 48 
;Dn arrow 50 
mov menustate , 0

start:
mov LevelTrials , 5
mov eax , 0

call writeMenu

s:
call readkey
jz s
cmp ah,50h
je down
cmp ah , 48h
je up
cmp ah , 28
je checkstate

up:
	cmp menustate , 0
	je circle
	dec menustate
	jmp start
	circle:
		mov menustate , 3
	jmp start

 down:
	;mov eax,1000
	;call writeint
	;call crlf
	mov eax , menustate
	inc eax 
	mov edx,0
	mov ebx , 4
	div ebx
	mov eax , edx
	mov menustate , eax
jmp start

checkstate:
	cmp menustate , 0
	je entrplay
	 cmp menustate , 1
	je halloffame
	cmp  menustate , 2
	je credits
	jmp Exitt
entrplay:
	call Playing
	;;;Clear the arrays filled by the datfile
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	jmp start
halloffame:
	call Display_Hall_Of_Fame
	call crlf 
   call crlf
	mov edx , offset asktomenu
	call writestring
	call crlf 
	call readchar
	cmp al , 'b'
	je start
	jmp en
   credits:
   call DisplayCredits
   call crlf 
   call crlf
   mov edx , offset asktomenu
	call writestring
	call crlf 
	call readchar
	cmp al , 'b'
	je start
   jmp en
   Exitt:
   call clrscr
	 en:
  ; 
	exit
main ENDP
END main