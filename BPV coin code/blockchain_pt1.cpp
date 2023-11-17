#include <iostream>
#include <vector>
#include <string>
#include <openssl/sha.h>

using namespace std;

class Block {
public:
    string prevHash;
    string blockHash;
    string data;
    Block(string data, string prevHash) {
        this->data = data;
        this->prevHash = prevHash;
        this->blockHash = calculateHash();
    }

    string calculateHash() {
        string toHash = prevHash + data;
        unsigned char hash[SHA256_DIGEST_LENGTH];
        SHA256_CTX sha256;
        SHA256_Init(&sha256);
        SHA256_Update(&sha256, toHash.c_str(), toHash.size());
        SHA256_Final(hash, &sha256);
        stringstream ss;
        for(int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
            ss << hex << (int)hash[i];
        }
        return ss.str();
    }
};

class Blockchain {
private:
    vector<Block> chain;
public:
    Blockchain() {
        Block genesis = Block("Genesis Block", "0");
        chain.push_back(genesis);
    }

    void addBlock(Block newBlock) {
        newBlock.prevHash = chain.back().blockHash;
        newBlock.blockHash = newBlock.calculateHash();
        chain.push_back(newBlock);
    }

    void printChain() {
        for(int i = 0; i < chain.size(); i++) {
            cout << "Block " << i << " [" << endl;
            cout << "  Previous Hash: " << chain[i].prevHash << "," << endl;
            cout << "  Data: " << chain[i].data << "," << endl;
            cout << "  Hash: " << chain[i].blockHash << endl;
            cout << "]" << endl;
        }
    }
};

int main() {
    Blockchain myBlockchain;
    myBlockchain.addBlock(Block("Block 1 Data", ""));
    myBlockchain.addBlock(Block("Block 2 Data", ""));
    myBlockchain.printChain();
    return 0;
}
