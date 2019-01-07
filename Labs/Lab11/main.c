#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int readSentence(char *sentence)
{
    scanf("%s",sentence);
	return strlen(sentence);
}

void getLetters(char *letters);

char sentence[101];
int length;
char bigLetters[101]="";
char smallLetters[101]="";
int main()
{
	length = readSentence(sentence);

    getLetters(bigLetters,65,90);
    printf("%s",bigLetters);

    //getLetters(sentence,smallLetters,97,122)
    //printf("%s",smallLetters)

   return 0;
}

