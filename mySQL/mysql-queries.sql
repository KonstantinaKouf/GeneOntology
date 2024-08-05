#Gene-Product node associated with the most GO terms
SELECT GeneProduct_Symbol, COUNT(DISTINCT GO_terms) AS TermCount
FROM GO_Annotations
GROUP BY GeneProduct_Symbol
ORDER BY TermCount DESC
LIMIT 1;

#Count of GO Terms/Gene Product
SELECT GeneProduct_Symbol, COUNT(DISTINCT GO_terms) AS TermCount
FROM GO_Annotations
GROUP BY GeneProduct_Symbol
ORDER BY TermCount DESC;

#Terms associated with the Gene-Product node with Symbol 'TNF'
SELECT go_terms.Name
FROM go_terms
INNER JOIN go_annotations ON go_terms.GO_ID = go_annotations.GO_terms
WHERE go_annotations.GeneProduct_Symbol = 'TNF';

#genes associated with activated neuropilin signaling pathway through VEGF
Select GO_Annotations.GeneProduct_Symbol
FROM GO_terms, GO_Annotations, go_terms_synonyms
WHERE go_terms_synonyms.Synonym LIKE '%activated neuropilin signaling pathway%' AND GO_terms.GO_ID=GO_Annotations.GO_terms AND GO_terms.GO_ID=go_terms_synonyms.GO_terms;

#Common terms between TNF kai Tnf?
SELECT GO_Annotations.GO_terms,GO_terms.Name,group_concat(GO_Annotations.GeneProduct_Symbol) AS GENES_SYMBOLS 
FROM GO_Annotations,GO_terms
WHERE GO_terms.GO_ID=GO_Annotations.GO_terms
GROUP BY  GO_Annotations.GO_terms
HAVING COUNT(*)>1;
