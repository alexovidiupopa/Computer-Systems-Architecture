#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int readSentence(char *sentence)
{
    scanf("%s",sentence);
	return strlen(sentence);

}

void getLetters(char *letters);

char sentence[6]="ABCDe";
int length;
char bigLetters[101]="";
char smallLetters[101]="";
int main()
{
    length = 5;

    getLetters(bigLetters);
	printf("%c",bigLetters[0]);
    printf("%s",bigLetters);

    //getLetters(sentence,smallLetters,97,122)
    //printf("%s",smallLetters)

   return 0;
}

