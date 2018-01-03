let GraphBase = require('./GraphBase');

class WordGraph extends GraphBase {

  constructor() {
    super();
  }

  create(dictionary) {

    let bucket = {};

    for (let word of dictionary) {
      for (let i = 0; i < word.length; i++) {
        const key = `${word.substr(0, i)}-${word.substr(i+1)}`;
        if(bucket[key]) {
          bucket[key].push(word);
        }
        else {
          bucket[key] = [word];
        }
      }
    }

    for (let key of Object.keys(bucket)) {
      for (let word1 of bucket[key]) {
        for (let word2 of bucket[key]) {
          if(word1 != word2) {
            this.setEdge(word1, word2);
          }
        }
      }
    }

  }

  bfs(startNode) {
    let q = [];

    startNode.distance = 0;
    startNode.parent = null;
    q.push(startNode);

    while(q.length) {
      let currentNode = q.shift();
      for (let node of this.getConnections(currentNode.id)) {
        if(node.color === 'w') {
          node.color = 'g';
          node.distance = currentNode.distance + 1;
          node.parent = currentNode.id;
          q.push(node);
        }
      }
      currentNode.color = 'b';
    }
  }

  traverse(cnode) {
    let ret = [];
    while(cnode.parent) {
      ret.push(cnode.id);
      cnode = this.getNode(cnode.parent);
    }
    ret.push(cnode.id);
    let result="The shortest path between two words:-> "+ret.reverse().join(',');
    return result;
  }

  getWordChain(startWord, endWord) {

    if(!(typeof startWord === 'string' && typeof endWord === 'string')) {
      return 'Sorry, wrong inputs expecting two words as string';
    }

    if(startWord.length !== endWord.length) {
      return "Sorry, both words length needs to be same to find wordchain";
    }

    let startNode = this.getNode(startWord);
    let endNode = this.getNode(endWord);

    if(!(startNode && endNode)) {
      return 'Word not found in dictionary';
    }

    this.resetColor();
    this.bfs(startNode);

    return this.traverse(endNode);
  }
}

module.exports = WordGraph;
