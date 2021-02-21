/**
 * Program 3 - Decrypter version2
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    // Starting state: 0x01
    // Feedback positions: [6,5]=0x60
    // The encrypted message found using this idea
    //unsigned char encrypted_message[] = {0x21, 0x22, 0x24, 0x28, 0x30, 0x00, 0x61, 0x23, 0x26, 0x2C};
    unsigned char encrypted_message[] = { 
                      0x60,0x21,0x22,0x24,0x28,0x30,0x0,0xE1,0xA3,0xA6,0xAC,0x38,0x90,0x93,0xA3,0xEB,0xEE,0x7B,
                      0xC5,0x71,0x4E,0x22,0xFC,0xED,0xDD,0x1E,0x17,0x44,0xE8,0xB1,0x82,0x65,0x2B,0x36,0xC,0xF9,
                      0x93,0x47,0xEE,0xBD,0x9A,0x55,0xCA,0x74,0x9,0xF3,0x87,0x6F,0x3F,0x1E,0xDD,0x5A,0xD4,0x48
    };

  //pos 12 changed to 0x89 for corruption, was 0xB8

    // The feedback tap patterns in hex
    unsigned char feedback_taps[] = {0x60, 0x48, 0x78, 0x72, 0x6A, 0x69, 0x5C, 0x7E, 0x7B};
    unsigned char start_state;
    unsigned char tap_pattern;

    unsigned char space_char = 0x20;
    // Stores the state bytes found
    unsigned char state_chars[10];

    // CODE BELOW USED TO GET STATE BITS
    // examining first 10 chars
    // xor with known space_char in order to get state chars
    for (int i = 0; i < 10; i++)
    {
        state_chars[i] = encrypted_message[i] ^ space_char;
    }

    //printf("THESE ARE STATE BITS\n");
    for (int i = 0; i < 10; i++)
    {
        //printf("0x%X\t", state_chars[i]);
    }

    start_state = state_chars[0];

    // CODE BELOW USED FOR FINDING THE TAP PATTERN

    unsigned char verified_taps[9];
    memcpy(verified_taps, feedback_taps, sizeof(verified_taps));
    // Outer loop to iterate through each state and the state after
    for (int i = 0; i < 9; i++)
    {
        int counter = 0; // idx of the temp_taps
        unsigned char temp_taps[9];

        //printf("\nstate_chars[%d] = 0x%X\n", i, state_chars[i]);

        // Inner loop to iterate through different feedback tap patterns
        for (int j = 0; j < sizeof(verified_taps) / sizeof(unsigned char); j++)
        {

            // to get whether LSB should be 1 or 0
            // gets stored in  bit
            unsigned char ones = verified_taps[j] & state_chars[i];
            unsigned char bit = 0x00;
            while (ones)
            {
                bit = bit ^ 0x01;
                ones = ones & (ones - 1);
            }

            // getting the new state with the lsb decded by feedback_taps[j]
            unsigned char new_state = state_chars[i] << 1;
            new_state = (new_state | bit) & 0x7F;

            //printf("    verified_taps[%d] = 0x%X\n", j, verified_taps[j]);
            //printf("    new_state = 0x%X\n", new_state);
            //printf("    state_chars[+1] = 0x%X\n", state_chars[i + 1]);

            // checks if the state from the lfsr with the tap pattern at j
            // creates next state that we found
            if (new_state == state_chars[i + 1])
            {
                temp_taps[counter] = verified_taps[j];
                //printf("    success with 0x%X\n", verified_taps[j]);
                counter += 1;
            }

        } // end of inner for loop

        // in order to set new verified_taps
        for (int j = 0; j < sizeof(verified_taps) / sizeof(unsigned char); j++)
        {
            verified_taps[j] = '\0';
            if (j < strlen(temp_taps))
            {
                verified_taps[j] = temp_taps[j];
            }
            //printf("0x%X     ", temp_taps[j]);
        }

        //printf("\n");

    } // end of outer for loop

    printf("\nVERIFIED TAPS\n");
    for (int i = 0; i < strlen(verified_taps); i++)
    {
        //printf("0x%X\n", verified_taps[i]);
    }
    printf("0x%X\n", verified_taps[0]);

    tap_pattern = verified_taps[0];
    printf("start_state = 0x%X\n", start_state);
        
    printf("tap_pattern = 0x%X\n", tap_pattern);
        
    // CHECKING PARITY BIT

    for (int i = 0; i < 54; i ++) {
      unsigned char temp = encrypted_message[i];
      temp = temp & 0x7F; // gets rid of the MSB
      unsigned char tbit = 0x00;
      unsigned char pbit = (encrypted_message[i] & 0x80) >> 7;
      while (temp) // checking to see what the parity bit should be 
        {
          tbit = tbit ^ 0x01;
          temp = temp & (temp - 1);
        }
      if (tbit != pbit) { // if what the parity bit should be is not what was found in MSB of encrypted message
        encrypted_message[i] = 0x80;
      }
    } // end of checking parity bit 

  //Removing space chars
  unsigned char decrypted[54];    //the decrypted message received from lfsr (error checking included)
  unsigned char formatted[54];    //the decrypted message after removing leading spaces and adding padding to the end

  unsigned char len = 54;
  unsigned char state, taps, next;//encrypted;
  unsigned char idx, bit, ones, parity;
  state = start_state; //Set a non-zero starting state
  taps = tap_pattern;
  idx = 0;      //idx to first char of string
  //parity = 0x00;

  printf("pre-decrypted string:\"");
  for(int i = 0; i < 54; i ++) {
    printf("0x%X ", encrypted_message[i]);
  }
  printf("\"\n");

  while (idx < len) 
  {
    // if the error flag was inserted we ignore on decryption
    if (encrypted_message[idx] == 0x80) {
      decrypted[idx] = 0x21;
    } 
    else
    {
      encrypted_message[idx] = encrypted_message[idx] & 0x7F;
      decrypted[idx] = encrypted_message[idx] ^ state;    //encrypt the character at idx by xoring curr lfsr state with char
    }
      //printf("0x%X\n", state);

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

  unsigned char msg_idx = 0;

  printf("decrypted string:\"");
  for(int i = 0; i < 54; i ++) {
    printf("%c", decrypted[i]);
  }
  printf("\"\n");

  while(decrypted[msg_idx] == 0x20)
  {
      msg_idx++;                  //find the first non space character
  }

  for(int i = 0; i < 54; i++, msg_idx++)
  {
    if(msg_idx < 54)
    {
      formatted[i] = decrypted[msg_idx]; //Write the message starting at first nonspace char to formatted
    }
    else
    {
      formatted[i] = 0x20;                //pad left over space with space chars
    }
  }

  printf("formatted string:\"");
  for(int i = 0; i < 54; i ++) {
    printf("%c", formatted[i]);
  }
  printf("\"\n");
}
