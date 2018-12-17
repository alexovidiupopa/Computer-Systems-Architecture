#include <stdio.h>

void readSentence(char sentence[]);

void getLetters(char sentence[],char letters[],int a,int z);

int main()
{
    char sentence[101];
    readSentence(sentence);
    
    char bigLetters[101];
    char smallLetters[101];
    
    getLetters(sentence,bigLetters,65,90)
    printf("%s",bigLetters)
    
    getLetters(sentence,smallLetters,97,122)
    printf("%s",smallLetters)
    
    return 0;
}

void readSentence(char sentence[])
{
    scanf("%s",sentence)
}