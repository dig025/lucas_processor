/**
 * Program 2 - Decrypter
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
    unsigned char encrypted_message[] = {0x60, 0x21, 0x22, 0x24, 0x28, 0x31, 0x2, 0x64, 0x29, 0x33};
    // The feedback tap patterns in hex
    unsigned char feedback_taps[] = {0x60, 0x48, 0x78, 0x72, 0x6A, 0x69, 0x5C, 0x7E, 0x7B};

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

    printf("THESE ARE STATE BITS\n");
    for (int i = 0; i < 10; i++)
    {
        printf("0x%X\t", state_chars[i]);
    }

    // CODE BELOW USED FOR FINDING THE TAP PATTERN

    unsigned char verified_taps[9];
    memcpy(verified_taps, feedback_taps, sizeof(verified_taps));
    // Outer loop to iterate through each state and the state after
    for (int i = 0; i < 9; i++)
    {
        int counter = 0; // idx of the temp_taps
        unsigned char temp_taps[9];

        printf("\nstate_chars[%d] = 0x%X\n", i, state_chars[i]);

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

            printf("    verified_taps[%d] = 0x%X\n", j, verified_taps[j]);
            printf("    new_state = 0x%X\n", new_state);
            printf("    state_chars[+1] = 0x%X\n", state_chars[i + 1]);

            // checks if the state from the lfsr with the tap pattern at j
            // creates next state that we found
            if (new_state == state_chars[i + 1])
            {
                temp_taps[counter] = verified_taps[j];
                printf("    success with 0x%X\n", verified_taps[j]);
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
            printf("0x%X     ", temp_taps[j]);
        }

        //printf("\n");

    } // end of outer for loop

    printf("\nVERIFIED TAPS\n");
    for (int i = 0; i < strlen(verified_taps); i++)
    {
        //printf("0x%X\n", verified_taps[i]);
    }
    printf("0x%X\n", verified_taps[0]);
}