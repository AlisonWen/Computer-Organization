# Computer Organization : Lab 6 Report

109550083 楊皓宇

109550121 温柏萱

## Part 1 : Implementation Details

### Direct Mapped Cache

```cpp
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
```

First, we need to read in the file, which consists of a series of addresses, each may be $8$ or $7$ digits. To prevent errors, we added $1$ digit $0$ to all the addresses that are $7$-digit long. Then we can transform the address to its binary representation and easily find out the index and tag of each address. When reading in the file, we can stimulate the cache simultaneously, using an `unordered_map <string, string> cache` with index as its key and the tag as its value. If `cache[index]` is not empty and the tag in cache is identical to the current tag, we hit the data in cache, and increase `hit_num` by $1$! Otherwise we missed. 

Finally return $\frac{hit\ num}{total\ num}$.

### Set Associative Cache
```cpp
bool sameBlock(int block_size, unsigned int address1, unsigned int address2) {
    address1 = address1 / block_size;
    address2 = address2 / block_size;
    return address1 == address2;
}

float set_associative(string filename, int way, int block_size, int cache_size)
{
    int total_num = 0;
    int hit_num = 0;

    ifstream f(filename);
    unsigned int addr;
    int indexes = cache_size / (block_size * way);
    vector<vector<unsigned int> > cache(indexes, vector<unsigned int>(way, 0));
    vector<vector<int> > lastUsed(indexes, vector<int>(way, -1));

    while (f >> hex >> addr) {
        total_num++;

        int index = (addr / block_size) % indexes;
        bool hit = false;

        for (int i = 0; i < way; i++) {
            if (sameBlock(block_size, cache[index][i], addr) && lastUsed[index][i] != -1) {
                hit_num++;
                lastUsed[index][i] = total_num;
                hit = true;
                break;
            }
        }

        if (!hit) {
            for (int i = 0; i < way; i++) {
                if (lastUsed[index][i] == -1) {
                    cache[index][i] = addr;
                    lastUsed[index][i] = total_num;
                    hit = true;
                    break;
                }
            }
        } 

        if (!hit) {
            int min = 0;
            for (int i = 0; i < way; i++) {
                if (lastUsed[index][i] < lastUsed[index][min]) {
                    min = i;
                }
            }
            cache[index][min] = addr;
            lastUsed[index][min] = total_num;
        }
    }
    
    return (float)hit_num/total_num;
}
```
- Number of index: `cache_size / (block_size * way)`
- Using `fstream` to read the file. Since addresses are seperated by new line, we can read an address as hex format number until EOF.
- `cache` is a 2D vector that stores addresses.
- `lastUsed` is a 2D vector that sotres last time the cache was accessed.
- Using `sameBlock` to check whether two addresses is at the same block.
- Cache runs in three stages:
    - Search for cached address in the set.
    - If not cached, find a unused place to cache.
    - If no spare space left, relpace the least accessed recently cached address with new one.

## Result

![Result.png](./images/Result.png)
