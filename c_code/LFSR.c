#include <stdio.h>
#include <stdlib.h>
#define START 0x20        
#define TAPS 0x48        
#define NUM_SPACES 0x1A   //26 spaces
/* short program to understand linear feed shift register */
int main()
{
  unsigned char original[] = "Mr. Watson, come here. I want to see you."; 
  unsigned char len = 54;
  unsigned char new_message[54];
  unsigned char taps, state, next, encrypted;
  unsigned char idx, bit, ones, parity, num_spaces;
  state = START; //Set a non-zero starting state from "memory"
  taps = TAPS;  //Set tap pattern from "memory"
  num_spaces = NUM_SPACES; //Set number of spaces from "memory"
  idx = 0;      //idx to first char of string
  printf("value before encryption: %.*s\n", (int)sizeof(original), original);

  while (idx < len) 
  {
    /** added check for correct num spaces **/
    if(num_spaces < 10)
    {
      num_spaces = 10;
    }
    if(num_spaces > 26)
    {
      num_spaces = 26;
    }

    /** Changed encryption logic to check index in relation to num_spaces
     * if we are done with prepending spaces, idx will be >= num_spaces
     * in this case we get char idx - num_spaces and encrypt that
     **/
    if(idx < num_spaces)
    {
      new_message[idx] = 0x20 ^ state;    //encrypt a space character and replac
      encrypted = new_message[idx] & 0x7F;         //ignore the msb for parity calculation
    } else
    {
      //encrypt the character at idx - number of spaces by xoring curr lfsr state with char
      new_message[idx] = original[idx-num_spaces] ^ state;    
      encrypted = new_message[idx] & 0x7F;         //ignore the msb for parity calculation
    }

    parity = 0x00;
    while(encrypted)
    {
      parity = parity ^ 0x01;
      encrypted = encrypted & (encrypted - 1);
    }
    
    new_message[idx] = new_message[idx] & 0x7F | (parity << 7); //set the msb to parity

    ones = state & taps;    //get all the bits in tap positions
    next = state << 1;      //left shift the lfsr for next position
    bit = 0x00;   //default lsb to 0
    while (ones) // This is the naive way to achieve reduction xor
    {
      bit = bit ^ 0x01;
      ones = ones & (ones - 1);
    }

    next = next & 0x7E | bit; //set the lsb to bit
    /** NOTE: NOT SURE WHY LINE UNDER THIS ONE IS COMMENTED PLEASE CHECK LOGIC IS STILL RIGHT **/
    //next = next & 0x7E| (parity << 7); //set the msb to bit to parity (because 7bit)
    state = next;             //update the current state to be next state
    idx++;
  }

  printf("\nEncrypted Message\n");
  for(int i = 0; i < len; i ++) {
      printf("0x%X\n", new_message[i]);
  }

  printf("\nEncrypted Message String\n");
  for(int i = 0; i < len; i ++) {
      printf("%c", new_message[i]);
  }
}
