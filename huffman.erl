% 2.0 Freq Implementation

-module(huffman).
% -import(lists,[sort/1]).
-compile(export_all).

% !! Function to test functionality
test() ->
    String = "The quick brown fox jumps over the lazy dog",
    encode(String),
    decode(huffman:encode(String)).


% !!Helper Functions
sort_by_freq(ListOfMaps)-> lists:sort(fun(A,B) -> maps:get(freq,A) =< maps:get(freq,B) end,ListOfMaps ). 
to_char(Char) -> io_lib:format("~c", [Char]). 

find_code_in_table(Char,CodeTable) -> 
    {_,{_,Code}} = lists:keysearch(to_char(Char),1, CodeTable),
    Code.
find_char_in_table(Code,CodeTable) ->
    case lists:keysearch(Code,2, CodeTable) of
        false -> false; 
        {_,{Char,_}} -> Char
    end.


% !! Frequency List Constructor
freq_list(Sample) -> freq_list(lists:sort(Sample),[]).
freq_list([], FreqList) -> sort_by_freq(FreqList);
freq_list([Char | Rest],Freq) -> 
    {Block,MBlocks} = lists:splitwith(fun (Block) -> Block ==Char end, Rest),
    Frequency = #{char => Char, freq=> 1+length(Block) , leftNode => #{}, rightNode => #{}},
    freq_list(MBlocks,[Frequency | Freq]).

% !!Huffman Tree Constructor
huffman_tree(Freq) when length(Freq) =:=1 -> lists:nth(1, Freq);

huffman_tree([Fst, Snd | Rest ]) ->  
    TotalFreq= maps:get(freq,Fst) + maps:get(freq,Snd),
    Node = #{char=> "", freq=> TotalFreq, leftNode => Fst, rightNode => Snd},
    Res = [Node | Rest],
    SortedRes = sort_by_freq(Res),
    huffman_tree(SortedRes).






build_code_table(String) ->
    case io_lib:char_list(String) of
        true ->
    FrequencyList = freq_list(String),
    HuffmanTree =huffman_tree(FrequencyList),
    CodeTable = [{to_char(Char),find_code_in_tree(HuffmanTree,Char)} || #{char:=Char} <- FrequencyList],
    CodeTable;
        false -> erlang:error("Provided Input is not a valid String, please check the input")
    end.

find_code_in_tree(Tree,Key) -> find_code_in_tree(Tree,Key,"").
find_code_in_tree(Node,Key,Code) ->
        case Node of 
            #{char:= Char,leftNode := LeftNode, rightNode := RightNode} -> 
            case Char=:=Key of 
                true -> Code; 
                false ->
                    Res1 = find_code_in_tree(LeftNode,Key,Code++"0"),
                    case Res1 of 
                        true -> Code;
                        false -> find_code_in_tree(RightNode,Key,Code++"1");
                        _ -> Res1
                    end
            end;
        #{} -> false
        end.    


% !!Encode Function
encode(String) ->
    case io_lib:char_list(String) of
        true-> 
            CodeTable = build_code_table(String),
            {CodeTable,encode(String,CodeTable)};
        false ->  erlang:error("Provided Input is not a valid String, please check the input")
    end.
    
        
encode([],_) -> "";
encode([X | Rest],CodeTable) -> find_code_in_table(X,CodeTable) ++ encode(Rest, CodeTable).

% !!Decode Function
decode(EncodeFunction) -> 
    {CodeTable,EncodedString} = EncodeFunction,
    io:fwrite("EncodedString: ~p\n",[EncodedString]),
    DecodedString = decode(EncodedString,CodeTable),
    io:fwrite("DecodedString: ~p\n",[DecodedString]).

decode(EncodedString,CodeTable) -> decode(EncodedString,CodeTable,"").
decode([],CodeTable,Acc) ->
    case find_char_in_table(Acc,CodeTable) of 
        false -> erlang:error("Could not find Code in the CodeTable, please check your EncodedString or CodeTable");
        Char -> Char
    end;

decode([Head|Rest],CodeTable,Acc) -> 
    case find_char_in_table(Acc,CodeTable) of
        false -> decode(Rest,CodeTable,Acc++to_char(Head));
        Char -> Char ++ decode(Rest,CodeTable,to_char(Head)) 
    end.
