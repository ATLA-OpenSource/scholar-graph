xquery version "3.1";

import module namespace atlaGraph = "http://www.andersoncliffb.net/atlaGraph" at "https://raw.githubusercontent.com/ATLA-OpenSource/scholar-graph/master/xquery/atlaGraph.xqm";

(: Create an alert (i.e. RSS feed) on ATLA religion database with ATLASerials. Use the value of the guid as input to the function :)

atlaGraph:graph("5227892")

  

