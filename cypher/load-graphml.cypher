// requires the APOC library to be installed in the Neo4j plugins folder.
// replace $URI with the file name or web addres of the GraphML file.

call apoc.import.graphml({$URI}", {batchSize: 10000, readLabels: true, storeNodeIds: false, defaultRelationshipType:"RELATED"})
