#include "set_associative_cache.h"
#include "string"
#include <fstream>
#include <map>
#include <vector>

using namespace std;

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
