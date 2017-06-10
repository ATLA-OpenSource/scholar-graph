# Scholar Graph

## Generate and Visualize Graphs from ATLA RDB

These samples illustrate the possibility of generating network graphs from arbitrary ATLA RDB (EBSCOhost) RSS feeds. The XQuery code consists of an XQuery module and script that takes any given RSS feed and converts it into GraphML format, using hashes to link edges and nodes. The Cypher code demonstrates how to import the resulting GraphML file into Neo4j for analysis.

## Requirements

* [BaseX](http://basex.org/) - an open source XML database. This code uses properietary extensions to XQuery to generate the hashes;
* [Neo4j](https://neo4j.com/product/) - an open source graph database. To load the GraphML, you must have installed [APOC](https://github.com/neo4j-contrib/neo4j-apoc-procedures) into the Neo4J plugins folder.

## Samples

The sample folder includes a GraphML file along with a Neo4j visualization.

![GraphML Visualization](sample/anderson-graph.png)
