class GraphBase {

  constructor() {
    this.nodes = Object.create(null);
    this.edges = Object.create(null);
  }

  setEdge(nodeId1, nodeId2) {
    !this.nodes[nodeId1] && (this.nodes[nodeId1] = {id: nodeId1, color: 'w'});
    !this.nodes[nodeId2] && (this.nodes[nodeId2] = {id: nodeId2, color: 'w'});
    !this.edges[nodeId1] && (this.edges[nodeId1] = [])
    this.edges[nodeId1].push(nodeId2);
  }

  getNode(id) {
    return this.nodes[id];
  }

  getConnections(id) {
    return this.edges[id].map( ele => this.getNode(ele));
  }

  resetColor() {
    for (let key in this.nodes) {
      this.nodes[key]['color'] = 'w';
    }
  }

  toString() {
    return JSON.stringify({
      'node': this.nodes,
      'edges': this.edges
    });
  }

}

module.exports = GraphBase;
