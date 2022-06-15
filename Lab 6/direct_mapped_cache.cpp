#include "direct_mapped_cache.h"
#include "string"
#include <cstring>
#include <fstream>
#include <unordered_map>
#include <cmath>
using namespace std;

unordered_map <char, string> Hex_to_binary;
unordered_map <string, string> cache;

float direct_mapped(string filename, int block_size, int cache_size){
    int total_num = 0;
    int hit_num = 0;
    int index_len = log2(cache_size / block_size);
    int offset_len = log2(block_size);
    
    ifstream input_stream(filename);
    string s;
    Hex_to_binary['0'] = "0000";
    Hex_to_binary['1'] = "0001";
    Hex_to_binary['2'] = "0010";
    Hex_to_binary['3'] = "0011";
    Hex_to_binary['4'] = "0100";
    Hex_to_binary['5'] = "0101";
    Hex_to_binary['6'] = "0110";
    Hex_to_binary['7'] = "0111";
    Hex_to_binary['8'] = "1000";
    Hex_to_binary['9'] = "1001";
    Hex_to_binary['a'] = "1010";
    Hex_to_binary['b'] = "1011";
    Hex_to_binary['c'] = "1100";
    Hex_to_binary['d'] = "1101";
    Hex_to_binary['e'] = "1110";
    Hex_to_binary['f'] = "1111";
    
    while (getline(input_stream, s)) {
        int tmp[35];
        string addr = "";
        while (s.size() < 8) s = "0" + s;

        for(int i = 0; i < s.size(); i++) addr = addr + Hex_to_binary[s[i]];
        
        string index = addr.substr(32 - index_len - offset_len, index_len);
        string tag = addr.substr(0, 32 - index_len - offset_len);

        if(cache.find(index) != cache.end() && cache[index] == tag) hit_num++;
        else cache[index] = tag;
        total_num++;
    }
     
  
    return (float)hit_num/total_num;
}
