# erlang-huffman-algorithm

In this repository, I am are going to implement the algorithm of Huffman coding, which is used for data compression. First, I am are
going to define the code table. This is based on the given text. As a next step, I will define functions for encoding and decoding the text.

The elements in the Huffman code table have variable lengths, based on the frequencies of the elements that appear in the sequence. The most frequent elements will be shorter than the less frequent. For more information see Huffman coding on Wikipedia.

The interface of the module
- **build_code_table/1**: The argument is a list/text of elements that will be used for calculating the code table. The code table is a
list of tuples, where the first element of a tuple is an element of the given text, and the second element is the corresponding list of binary code. For a better reading, both the elements and codes can be represented as "Strings".
- **encode/1**: The function gets a list/text, calculates the code table and encodes the provided list/text using the code table. The result should be a tuple of the code table and the encoded text (a String of values 0 and 1).
- **decode/1**: The function gets a tuple containing the code table used for encoding and the encoded text ( a string of
values 0 and 1) and reproduces the original text. Note, the argument of the function is the same as the value of the encode/1 function.
