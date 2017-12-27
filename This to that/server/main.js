const fs = require('fs');
const express = require('express');

const app = express();

const WordGraph = require('./lib/WordGraph');
const dictionary = fs.readFileSync('resources/web2.txt').toString().split(/\r?\n/);

const wordGraph = new WordGraph();
wordGraph.create(dictionary);

app.get('/solvewordchain/:startWord/:endWord', (req, res) => {
  let result = wordGraph.getWordChain(req.params.startWord, req.params.endWord);
  res.send(result);
});

app.listen(3001, () => {
  console.log('wordchain app listening on port 3001!')
});
