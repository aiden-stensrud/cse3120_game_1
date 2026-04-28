# CSE 3120 Project # 2
By Prottasha Deb and Aiden Stensrud<br>
Our game is "Super Hangman!" A player must "guess" a phrase by inputting letters into the program. The player has a limited number of guesses. Users can add their own phrases to customize their experience!
### Compilation Instructions
* To assemble the program, you must have a Windows machine with Visual Studio 2015 installed.
* Navigate into the ```Game Files/src``` and run ```assemble.bat```
* The program is now assembled and can be run with ```hangman.exe```, which is located within the ```Game Files/src``` folder.
* If you would like to compile using VSCode, or the above method does not work, it is possible to do so. Be sure to load all of the .asm files (```main.asm```, ```words.asm```, ```hangman_art.asm```, ```music.asm```) into the solution before building.
### Gameplay Instructions
* Type a lowercase letter a-z into the keyboard. Other keyboard inputs will not be considered valid, but will not penalize you.
* To add your own phrases to the pool of phrases, open the ```words.txt``` file in ```src```. Enter your new phrase on a separate line. The phrase must contain ONLY LOWERCASE LETTERS a-z AND SPACES. DO NOT LEAVE EMPTY LINES IN THE .TXT FILE.

Note: Some commits contain more than 20 changed lines of code. This is because the ASCII art images, which contain many lines, were moved around, which does not make sense across several commits. Additionally, issues with the batch files required larger commits to compile properly.

Music/Sound Credits:
* Title Screen:  <https://www.youtube.com/watch?v=7j01pC49VHY>
* Game:          <https://www.youtube.com/watch?v=TJEL-Bt5Yg8>
* Win:           <https://freesound.org/people/mlteenie/sounds/169233/>
* Lose:          <https://freesound.org/people/Robinhood76/sounds/687017/>
