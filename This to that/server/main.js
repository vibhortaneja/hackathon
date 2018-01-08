const fs = require('fs');
const express = require('express');

const app = express();

const WordGraph = require('./lib/WordGraph');
const dictionary = fs.readFileSync('resources/web2.txt').toString().split(/\r?\n/);

const wordGraph = new WordGraph();
wordGraph.create(dictionary);

app.get('/ThisToThat/:startWord/:endWord', (req, res) => {
  let result = wordGraph.getWordChain(req.params.startWord, req.params.endWord);
  res.send(result);
 // console.log(result)
});

app.listen(4000, () => {
  console.log('listening on port 4000!')
});
