# Computer Organization : Lab 6 Report

109550083 楊皓宇

109550121 温柏萱

## Part 1 : Implementation Details
#### Direct Mapped Cache

First, we need to read in the file, which consists of a series of addresses, each may be $8$ or $7$ digits. To prevent errors, we added $1$ digit to all the addresses that are $7$ digit long. Then we can transform the address to its binary representation and easily find out the index and tag of each address. When reading in the file, we can stimulate the cache simultaneously, using an `unordered_map <string, string> cache` with index as its key and the tag as its value. If `cache[index]` is not empty and the tag in cache is identical to the current tag, we hit the data in cache, and add the `hit_num` by $1$! Otherwise we missed. 

Finally return $\frac{hit\ num}{total\ num}$.
