const exec = require('child_process').exec;

const inputs = [
  {start: 'ape', end: 'man'},
  {start: 'cat', end: 'dog'},
  {start: 'lead', end: 'gold'},
  {start: 'take', end: 'fort'},
  {start: 'poor', end: 'rich'},
  {start: 'might', end: 'teeth'},
  {start: 'flower', end: 'golden'},
];

inputs.forEach( ele => {
  exec(`curl http://localhost:3001/solvewordchain/${ele.start}/${ele.end}`, (error, stdout, stderr) => {
    let out = `Input: ${ele.start}|${ele.end} - ${stdout}`;
    console.log(out);
  });
});
