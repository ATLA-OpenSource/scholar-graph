xquery version "3.1";

module namespace atlaGraph = "http://www.andersoncliffb.net/atlaGraph";

declare namespace graphml = "http://graphml.graphdrawing.org/xmlns";

import module namespace functx = 'http://www.functx.com' at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2005-11.xq";

declare  %private function atlaGraph:hash-string($string as xs:string?) as xs:string?
{
  xs:string(xs:hexBinary(hash:hash($string,'md5')))
};

declare function atlaGraph:process-rss($ebsco-rss as document-node()?) as element()*
{
  for $item in $ebsco-rss/rss/channel/item
  let $work-node :=
    <graphml:node id="{atlaGraph:hash-string($item/title/text())}" labels=":Work">
      <graphml:data key="title">{$item/title/text()}</graphml:data>
      <graphml:data key="pubDate">{$item/pubDate/text()}</graphml:data>
    </graphml:node>
  let $author-node :=
    for $authors in $item/author/text()
    let $names := fn:tokenize($authors, ";")[position() = 1 to (last() idiv 2)]
    for $name in $names
    return
      <graphml:node id="{atlaGraph:hash-string(fn:normalize-space(fn:translate($name, ".","")))}" labels=":Author">
         <graphml:data key="author">{fn:normalize-space($name)}</graphml:data>
      </graphml:node>
  let $author-work-edge :=
     for $name in $author-node/@id
     return
    <graphml:edge
       source="{$name}"
       target="{$work-node/@id}"
       label="CREATED">
         <graphml:data key="label">CREATED</graphml:data>
     </graphml:edge>
  let $category-node :=
     for $category in $item/category/text()
     return
      <graphml:node id="{atlaGraph:hash-string($category)}" labels=":Category">
        <graphml:data key="category">{$category}</graphml:data>
      </graphml:node>
  let $category-edges :=
       for $category in $category-node
       return
       <graphml:edge
           source="{$work-node/@id}"
           target="{$category/@id}"
           label="ABOUT">
         <graphml:data key="label">ABOUT</graphml:data>
       </graphml:edge>
  return
    ($work-node, $author-node, $author-work-edge, $category-node, $category-edges)
};

declare %private function atlaGraph:make-graphml($data as element()* ) as element(graphml:graphml)? {
  <graphml:graphml
    xmlns:grapml="http://graphml.graphdrawing.org/xmlns"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">
    <graphml:graph id="G" edgedefault="directed">
      {
        functx:distinct-deep(
          for $node in $data
          order by xs:string($node/fn:node-name()) descending, $node/@labels, ($node/graphml:data/text())[1]
          return $node)
      }
    </graphml:graph>
  </graphml:graphml>
};

declare %public function atlaGraph:graph($id as xs:string) as element(graphml:graphml)
{
  let $ebsco-rss := fn:doc("http://rss.ebscohost.com/AlertSyndicationService/Syndication.asmx/GetFeed?guid=" || $id)
  let $data := atlaGraph:process-rss($ebsco-rss)
  return atlaGraph:make-graphml($data)
};
