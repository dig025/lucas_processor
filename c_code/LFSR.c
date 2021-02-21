#include <stdio.h>
#include <stdlib.h>
#define START 0x40      
#define TAPS 0x60
/* short program to understand linear feed shift register */
int main()
{
  //unsigned char original[] = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'r', 'a', 'n', 'd', };
  unsigned char original[] = "             random message                           "; 
  unsigned char len = 54;
  unsigned char taps, state, next, encrypted;
  unsigned char idx, bit, ones, parity;
  state = START; //Set a non-zero starting state
  taps = TAPS;  //Set tap pattern
  idx = 0;      //idx to first char of string
  printf("value before encryption: %.*s\n", (int)sizeof(original), original);

  while (idx < len) 
  {
    /*if prepend
     * 
     *  
     */
    printf("0x%X\n", state);
    original[idx] = original[idx] ^ state;    //encrypt the character at idx by xoring curr lfsr state with char
    encrypted = original[idx] & 0x7F;         //ignore the msb for parity calculation

    parity = 0x00;
    while(encrypted)
    {
      parity = parity ^ 0x01;
      encrypted = encrypted & (encrypted - 1);
    }
    
    original[idx] = original[idx] & 0x7F | (parity << 7); //set the msb to parity

    ones = state & taps;    //get all the bits in tap positions
    next = state << 1;      //left shift the lfsr for next position
    bit = 0x00;   //default lsb to 0
    while (ones) // This is the naive way to achieve reduction xor
    {
      bit = bit ^ 0x01;
      ones = ones & (ones - 1);
    }

    next = next & 0x7E | bit; //set the lsb to bit
    //next = next & 0x7E| (parity << 7); //set the msb to bit to parity (because 7bit)
    state = next;             //update the current state to be next state
    idx++;
  }

  printf("\nEncrypted Message\n");
  for(int i = 0; i < len; i ++) {
      printf("0x%X,", original[i]);
  }


}
