#!/bin/bash

# Loop indefinitely
while true; do
    # Print the prompt
    echo "Please input a number or 'end' to stop:"

    # Read user input
    read input

    # Check if the input is 'end'
    if [ "$input" = "end" ]; then
        # If 'end', break the loop and end the script
        break
    elif [[ $input =~ ^[0-9]+$ ]]; then
        # If the input is a number, print it
        echo "You entered: $input"
        break
    else
        # If the input is not a number and not 'end', prompt again
        echo "Invalid input, please enter a number or 'end'."
    fi
done

