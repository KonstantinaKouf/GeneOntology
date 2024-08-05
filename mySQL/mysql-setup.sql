CREATE DATABASE go;
USE go;

#Delete tables:
#DROP DATABASE go;
SHOW TABLES;
DROP TABLE genetype;
DROP TABLE genesynonyms;
DROP TABLE go_terms_aspect;
DROP TABLE go_terms_synonyms;
DROP TABLE goannotations_evidencereliability;
DROP TABLE goannotations_evidencetype;
DROP TABLE organismsynonyms;
DROP TABLE go_annotations;
DROP TABLE geneproduct;
DROP TABLE go_terms;
DROP TABLE organism;


#Create tables:
CREATE TABLE Organism (
    Name varchar(45) ,
    Taxa_ID int,
    NCBI_ID varchar(45),
    Count int DEFAULT 0,
    PRIMARY KEY (Name)
);

CREATE TABLE OrganismSynonyms (
    OrganismName varchar(45),
    Synonym varchar(45),
    PRIMARY KEY (OrganismName, Synonym),
    FOREIGN KEY (OrganismName) REFERENCES Organism(Name)
);

CREATE TABLE GeneProduct(
Symbol varchar(45) COLLATE utf8mb4_bin,
NCBI_ID int,
Uniprot_ID varchar(45),
OrganismName varchar(45), 
PRIMARY KEY (Symbol),
FOREIGN KEY (OrganismName) REFERENCES Organism(Name) );

CREATE TABLE GeneSynonyms (
  GeneProduct varchar(45) COLLATE utf8mb4_bin,
  Synonym varchar(255),
  PRIMARY KEY (GeneProduct, Synonym),
  FOREIGN KEY (GeneProduct) REFERENCES GeneProduct(Symbol) 
);

CREATE TABLE GeneType(
GeneProduct varchar(45) COLLATE utf8mb4_bin,
Type varchar(45),
PRIMARY KEY (GeneProduct, Type),
FOREIGN KEY (GeneProduct) REFERENCES GeneProduct(Symbol));

CREATE TABLE GO_terms(
GO_ID varchar(255), 
Name varchar(45),
Definition varchar(45),
PRIMARY KEY(GO_ID),
RelationType varchar(45),
Related_GO_ID varchar(255)
);

CREATE TABLE GO_terms_Synonyms(
GO_terms varchar(255),
Synonym varchar(45),
PRIMARY KEY(GO_terms, Synonym),
FOREIGN KEY (GO_terms) REFERENCES GO_terms(GO_ID)
);

CREATE TABLE GO_terms_Aspect(
GO_terms varchar(255),
Aspect varchar(45),
PRIMARY KEY (GO_terms,Aspect),
FOREIGN KEY (GO_terms) REFERENCES GO_terms(GO_ID)
);


CREATE TABLE GO_Annotations(
Annotation_ID int NOT NULL AUTO_INCREMENT,
GO_terms varchar(255),
GeneProduct_Symbol varchar(45) COLLATE utf8mb4_bin,
Source varchar(45),
Title varchar(45),
PMID varchar(45),
PRIMARY KEY (Annotation_ID),
FOREIGN KEY (GO_terms) REFERENCES GO_terms(GO_ID),
FOREIGN KEY (GeneProduct_Symbol) REFERENCES GeneProduct(Symbol)
);

CREATE TABLE GOAnnotations_EvidenceReliability(
Annotation_ID int AUTO_INCREMENT,
Reliability varchar(45),
PRIMARY KEY (Annotation_ID,Reliability),
FOREIGN KEY (Annotation_ID) REFERENCES GO_Annotations(Annotation_ID)
);

CREATE TABLE GOAnnotations_EvidenceType(
Annotation_ID int AUTO_INCREMENT,
Type varchar(45),
PRIMARY KEY (Annotation_ID,Type),
FOREIGN KEY (Annotation_ID) REFERENCES GO_Annotations(Annotation_ID)
);

#Modify the tables:

ALTER TABLE GO_terms
MODIFY COLUMN Name VARCHAR(500);

ALTER TABLE GO_terms
MODIFY COLUMN Definition VARCHAR(800);

#Insert values to tables:
INSERT INTO Organism (Name, Taxa_ID, NCBI_ID)
VALUES
	("Homo Sapiens",9606,"txid9606"),
    ("Mus musculus",10090,"txid10090"),
    ("Escherichia coli",562, "txid562"); 

INSERT INTO OrganismSynonyms
VALUES 
("Homo Sapiens","Human"),
("Mus musculus","House mouse"),
("Escherichia coli","E.coli");

INSERT INTO GeneProduct
VALUES
("caiB",948997,"P31572", "Escherichia coli"),
("BamE",945583,"P0A937","Escherichia coli"),
("polA",948356,"P00582","Escherichia coli"),
("Vegfa",22339,"Q00731","Mus musculus"),
("Trp53",22059,"Q549C9","Mus musculus"),
("Tnf",21926,"P06804","Mus musculus"),
("TNF",7124,"P01375","Homo Sapiens"),
("SELL",6402, "P14151","Homo Sapiens"),
("POLH",5429,"Q9Y253", "Homo Sapiens");

INSERT INTO GeneSynonyms (GeneProduct, Synonym) VALUES
("caiB", '["b0038", "ECK0039", "yaaN"]'),
("BamE", '["b2617", "ECK2613", "smpA", "smqA"]'),
("polA", '["b3863","ECK3855","resA"]'),
("Vegfa",'["Vpf", "Vegf", "L-VEGF"]'),
("Trp53",'["bbl", "bfy", "bhy", "p44", "p53", "Tp53"]'),
("Tnf",'["DIF","Tnfa"," TNF-a"," TNFSF2","Tnlg1f"," Tnfsf1a","TNFalpha","TNF-alpha"]'),
("TNF",'["DIF","TNFA","TNFSF2","TNLG1F","TNF-alpha"]'),
("SELL",'["Q1","LAM1","LEU8"]'),
("POLH",'["XPV","XP-V","RAD30","RAD30A"]')
;

INSERT INTO genetype
VALUES
('caiB', "Gene"),
('BamE', "Gene"),
('polA', "Gene"),
('Vegfa',"protein coding"),
("Trp53","protein coding"),
("Tnf","Gene"),
("TNF","Gene"),
("SELL","Gene"),
("POLH","Gene")
;

INSERT INTO Go_terms(GO_ID, Name, Definition,RelationType,Related_GO_ID)
VALUES
("GO:0051205","protein insertion in to membrane","The process that results in the incorporation of a protein into a biological membrane. Incorporation in this context means having some part or covalently attached group that is inserted into the the hydrophobic region of one or both bilayers.",NULL,NULL),
("GO:0006950","response to stress","Any process that results in a change in state or activity of a cell or an organism (in GO_TERMs of movement, secretion, enzyme production, gene expression, etc.) as a result of a disturbance in organismal or cellular homeostasis, usually, but not necessarily, exogenous (e.g. temperature, humidity, ionizing radiation). Source: GOC:mah",NULL,NULL),
("GO:0042413","carnitine catabolic process","The chemical reactions and pathways resulting in the breakdown of carnitine (hydroxy-trimethyl aminobutyric acid), a compound that participates in the transfer of acyl groups across the inner mitochondrial membrane",NULL,NULL),
("GO:0008735","L-carnitine CoA-transferase activity", "Catalysis of the reactions: (E)-4-(trimethylammonio)but-2-enoyl-CoA + L-carnitine = (E)-4-(trimethylammonio)but-2-enoate + L-carnitinyl-CoA and 4-trimethylammoniobutanoyl-CoA + L-carnitine = 4-trimethylammoniobutanoate + L-carnitinyl-CoA. PMID:7815937 PMID:8188598",NULL,NULL),
("GO:0006259","DNA metabolic process","Any cellular metabolic process involving deoxyribonucleic acid. This is one of the two main types of nucleic acid, consisting of a long, unbranched macromolecule formed from one, or more commonly, two, strands of linked deoxyribonucleotides. Source: ISBN:0198506732",NULL,NULL),
("GO:0035900","response to isolation stress","Any process that results in a change in state or activity of a cell or an organism (in GO_TERMs of movement, secretion, enzyme production, gene expression, etc.) as a result of a lack of contact with other members of the same species.",NULL,NULL),
("GO:0030730","sequestering of triglyceride","The process of binding or confining any triester of glycerol such that it is separated from other components of a biological system.",NULL,NULL),
("GO:0071230","cellular response to amino acid stimulus","Any process that results in a change in state or activity of a cell (in GO_TERMs of movement, secretion, enzyme production, gene expression, etc.) as a result of an amino acid stimulus. An amino acid is a carboxylic acids containing one or more amino groups.",NULL,NULL),
("GO:1901701","cellular response to oxygen-containing compound","Any process that results in a change in state or activity of a cell (in GO_TERMs of movement, secretion, enzyme production, gene expression, etc.) as a result of an oxygen-containing compound stimulus","is_a","GO:0070887"),
("GO:0070887","cellular response to chemical stimulus","Any process that results in a change in state or activity of a cell (in GO_TERMs of movement, secretion, enzyme production, gene expression, etc.) as a result of a chemical stimulus",NULL,NULL),
("GO:0050901","leukocyte tethering or rolling","Transient adhesive interactions between leukocytes and endothelial cells lining blood vessels. Carbohydrates on circulating leukocytes bind selectins on the vessel wall causing the leukocytes to slow down and roll along the inner surface of the vessel wall. During this rolling motion, transitory bonds are formed and broken between selectins and their ligands. Typically the first step in cellular extravasation (the movement of leukocytes out of the circulatory system, towards the site of tissue damage or infection)","part_of","GO:0045123"),
("GO:0045123","cellular extravasation","The migration of a leukocyte from the blood vessels into the surrounding tissue",NULL,NULL),
("GO:0006915","apoptotic process","A programmed cell death process which begins when a cell receives an internal (e.g. DNA damage) or external signal (e.g. an extracellular death ligand), and proceeds through a series of biochemical events (signaling pathway phase) which trigger an execution phase. The execution phase is the last step of an apoptotic process, and is typically characterized by rounding-up of the cell, retraction of pseudopodes, reduction of cellular volume (pyknosis), chromatin condensation, nuclear fragmentation (karyorrhexis), plasma membrane blebbing and fragmentation of the cell into apoptotic bodies.","is_a","GO:0012501"),
("GO:0012501","programmed cell death","A process which begins when a cell receives an internal or external signal and activates a series of biochemical events (signaling pathway). The process ends with the death of the cell." ,NULL,NULL),
("GO:0043065","positive regulation of apoptotic process","Any process that activates or increases the frequency, rate or extent of cell death by apoptotic process.","regulates","GO:0006915"),
("GO:0006260","DNA replication","The cellular metabolic process in which a cell duplicates one or more molecules of DNA. DNA replication begins when specific sequences, known as origins of replication, are recognized and bound by the origin recognition complex, and ends when the original DNA molecule has been completely duplicated and the copies topologically separated. The unit of replication usually corresponds to the genome of the cell, an organelle, or a virus. The template for replication can either be an existing DNA molecule or RNA. ",NULL,NULL),
("GO:0038190","VEGF-activated neuropilin signaling pathway","The series of molecular signals initiated by vascular endothelial growth factor (VEGF) binding to a neuropilin protein on the surface of a target cell, and ending with the regulation of a downstream cellular process",NULL,NULL),
("GO:1902378","VEGF-activated neuropilin signaling pathway involved in axon guidance", "Any VEGF-activated neuropilin signaling pathway that is involved in axon guidance",NULL,NULL),
("GO:1901612","cardiolipin_binding","Binding to cardiolipin.",NULL,NULL),
("GO:0034061","DNA polymerase activity","Catalysis of the reaction: deoxynucleoside triphosphate + DNA(n) = diphosphate + DNA(n+1); the synthesis of DNA from deoxyribonucleotide triphosphates in the presence of a nucleic acid template and a 3'hydroxyl group.",NULL,NULL),
("GO:0003824","catalytic activity","Catalysis of a biochemical reaction at physiological temperatures. In biologically catalyzed reactions, the reactants are known as substrates, and the catalysts are naturally occurring macromolecular substances known as enzymes. Enzymes possess specific binding sites for substrates, and are usually composed wholly or largely of protein, but RNA that has catalytic activity (ribozyme) is often also regarded as enzymatic.",NULL,NULL),
("GO:0033691","sialic acid binding","Binding to a sialic acid, a N- or O- substituted derivative of neuraminic acid, a nine carbon monosaccharide. Sialic acids often occur in polysaccharides, glycoproteins, and glycolipids in animals and bacteria. ",NULL,NULL),
("GO:0030246","carbohydrate binding","Binding to a carbohydrate, which includes monosaccharides, oligosaccharides and polysaccharides as well as substances derived from monosaccharides by reduction of the carbonyl group (alditols), by oxidation of one or more hydrox","capable_of","GO:1990724"),
("GO:0005509","calcium ion binding","Binding to a calcium ion (Ca2+).",NULL,NULL),
("GO:0005125","cytokine activity","The activity of a soluble extracellular gene product that interacts with a receptor to effect a change in the activity of the receptor to control the survival, growth, differentiation and effector function of tissues and cells.","is_a","GO:0048018"),
("GO:0042802","identical protein binding","Binding to an identical protein or proteins.",NULL,NULL),
("GO:0048018","receptor ligand activity","The activity of a gene product that interacts with a receptor to effect a change in the activity of the receptor. Ligands may be produced by the same, or different, cell that expresses the receptor. Ligands may diffuse extracellularly from their point of origin to the receiving cell, or remain attached to an adjacent cell surface (e.g. Notch ligands).",NULL,NULL),
("GO:0003887","DNA-directed DNA polymerase activity","Catalysis of the reaction: deoxynucleoside triphosphate + DNA(n) = diphosphate + DNA(n+1); the synthesis of DNA from deoxyribonucleotide triphosphates in the presence of a DNA template and a 3'hydroxyl group",NULL,NULL),
("GO:0043183","vascular endothelial growth factor receptor 1 binding", "Binding to a vascular endothelial growth factor receptor 1",NULL,NULL),
("GO:0038085","VEGF binding", "Binding to a vascular endothelial growth factor",NULL,NULL),
("GO:1990063","Bam protein complex","Protein complex which is involved in assembly and insertion of beta-barrel proteins into the outer membrane. In E. coli it is composed of BamABCDE, of the outer membrane protein BamA, and four lipoproteins BamB, BamC, BamD, and BamE. BamA interacts directly with BamB and the BamCDE subcomplex.",NULL,NULL),
("GO:0031241","periplasmic side of cell outer membrane","The side (leaflet) of the outer membrane that faces the periplasm of the cell.","part_of","GO:1990063"),
("GO:0005737","cytoplasm","The contents of a cell excluding the plasma membrane and nucleus, but including other subcellular structures.",NULL,NULL),
("GO:1990724","galectin complex","A homodimeric protein complex that is capable of binding a range of carbohydrates and is involved in anti-inflammatory and pro-apoptotic processes." ,"part_of","GO:0043065"),
("GO:0005615","extracellular space","That part of a multicellular organism outside the cells proper, usually taken to be outside the plasma membranes, and occupied by fluid.",NULL,NULL),
("GO:0005886","plasma membrane","The membrane surrounding a cell that separates the cell from its external environment. It consists of a phospholipid bilayer and associated proteins.",NULL,NULL),
("GO:0042774","plasma membrane ATP synthesis coupled electron transport","The transfer of electrons through a series of electron donors and acceptors, generating energy that is ultimately used for synthesis of ATP in the plasma membrane.","occurs_in","GO:0005886"),
("GO:0009986","cell surface","The external part of the cell wall and/or plasma membrane." ,NULL,NULL),
("GO:0005829","cytosol","The part of the cytoplasm that does not contain organelles but which does contain other particulate matter, such as protein complexes. ",NULL,NULL),
("GO:1990150","VEGF-A complex","A homodimeric, extracellular protein complex containing two VEGF-A monomers. Binds to and activates a receptor tyrosine kinase",NULL,NULL),
("GO:0043293","apoptosome", "A multisubunit protein complex involved in the signaling phase of the apoptotic process. In mammals, it is typically composed of seven Apaf-1 subunits bound to cytochrome c and caspase-9. A similar complex to promote apoptosis is formed from homologous gene products in other eukaryotic organisms",NULL,NULL),
("GO:0001774","microglial cell activation", "The change in morphology and behavior of a microglial cell resulting from exposure to a cytokine, chemokine, cellular ligand, or soluble factor. Source: GOC:mgi_curators",NULL,NULL),
("GO:0038177","death receptor agonist activity", "Interacting with a death receptor such that the proportion of death receptors in an active form is increased. Ligand binding to a death receptor often induces a conformational change to activate the receptor.",NULL,NULL)
;

#Modify GO_terms
UPDATE GO_terms
SET GO_ID = "GO:1902378", Name = "VEGF-activated neuropilin signaling pathway involved in axon guidance",
Definition = "Any VEGF-activated neuropilin signaling pathway that is involved in axon guidance"
WHERE GO_ID = "VEGF-activated neuropilin signaling pathway involved in axon guidance" AND Name = "GO:1902378";

SELECT * FROM go_terms
WHERE GO_ID = 'GO:1902378';

SELECT GO_ID
FROM go_terms
WHERE GO_ID = 'GO:0051205';

ALTER TABLE go_terms_synonyms
MODIFY COLUMN Synonym VARCHAR(255);


INSERT INTO go_terms_synonyms(GO_terms, Synonym)
VALUES
("GO:0051205","protein-membrane insertion"),
("GO:0006950","response to abiotic stress,response to biotic stress"),
("GO:0042413","carnitine degradation"),
("GO:0008735","L-carnitine hydro-lyase activity,L-carnitine dehydratase activity"),
("GO:0006259","DNA metabolism,cellular DNA metabolism"),
("GO:0035900","response to social isolation"),
("GO:0030730","retention of triacylglycerol, retention of triglyceride, sequestering of triacylglycerol"),
("GO:0071230","None"),
("GO:1901701","None"),
("GO:0070887","None"),
("GO:0050901","None"),
("GO:0045123","immune cell cellular extravasation,leucocyte cellular extravasation"),
("GO:0006915", "apoptotic cell death, apoptotic programmed cell death"),
("GO:0012501", "PCD, RCD"),
("GO:0043065","up regulation of apoptosis"),
("GO:0006260","None"),
("GO:0038190","VEGF-Npn-1 signaling, vascular endothelial growth factor-activated neuropilin signaling pathway"),
("GO:1902378","VEGF-activated neuropilin signaling pathway involved in axon pathfinding"),
("GO:1901612","None"),
("GO:0034061","DNA nucleotidyltransferase activity"),
("GO:0003824","enzyme activity"),
("GO:0033691","None"),
("GO:0030246","sugar binding, selectin"),
("GO:0005509","calcium ion storage activity"),
("GO:0005125","autocrine activity,paracrine activity"),
("GO:0042802","isoform-specific homophilic binding, protein homopolymerization"),
("GO:0048018","signaling molecule,signaling receptor ligand activity"),
("GO:0003887","DNA duplicase activity,DNA nucleotidyltransferase (DNA-directed) activity"),
("GO:0043183","Flt-1 binding, VEGF receptor 1 binding, VEGFR 1 binding"),
("GO:0038085","VEGF binding"),
("GO:1990063", "OMP complex"),
("GO:0031241",'["internal leaflet of cell outer membrane" ,"internal side of cell outer membrane"]'),
("GO:0005737","None"),
("GO:1990724","galectin-1 complex, galectin-2 complex" ),
("GO:0005615","intercellular space"),
("GO:0005886","cell membrane,cellular membrane"),
("GO:0042774","None"),
("GO:0009986", "cell associated, cell bound"),
("GO:0005829","None"),
("GO:1990150","vascular endothelial growth factor A complex"),
("GO:0043293","None"),
("GO:0001774","None"),
("GO:0038177","death receptor activator activity")
;
----------------------------------------------------
SELECT * FROM go_terms_synonyms;
UPDATE go_terms_synonyms
SET GO_terms="GO:0031241",Synonym="internal leaflet of cell outer membrane, internal side of cell outer membrane"
WHERE GO_terms="GO:0031241" and Synonym='["internal leaflet of cell outer membrane" ,"internal side of cell outer membrane"]';

-----------------------------------------------------

INSERT INTO go_terms_aspect(GO_terms,Aspect)
VALUES
("GO:0051205","BIOLOGICAL_PROCESS"),
("GO:0006950","BIOLOGICAL_PROCESS"),
("GO:0042413","BIOLOGICAL_PROCESS"),
("GO:0008735","BIOLOGICAL_PROCESS"),
("GO:0006259","BIOLOGICAL_PROCESS"),
("GO:0035900","BIOLOGICAL_PROCESS"),
("GO:0030730","BIOLOGICAL_PROCESS"),
("GO:0071230","BIOLOGICAL_PROCESS"),
("GO:1901701","BIOLOGICAL_PROCESS"),
("GO:0070887","BIOLOGICAL_PROCESS"),
("GO:0050901","BIOLOGICAL_PROCESS"),
("GO:0045123","BIOLOGICAL_PROCESS"),
("GO:0006915", "BIOLOGICAL_PROCESS"),
("GO:0012501", "BIOLOGICAL_PROCESS"),
("GO:0043065","BIOLOGICAL_PROCESS"),
("GO:0006260","BIOLOGICAL_PROCESS"),
("GO:0038190","BIOLOGICAL_PROCESS"),
("GO:1902378","BIOLOGICAL_PROCESS"),
("GO:1901612","MOLECULAR_FUNCTION"),
("GO:0034061","MOLECULAR_FUNCTION"),
("GO:0003824","MOLECULAR_FUNCTION"),
("GO:0033691","MOLECULAR_FUNCTION"),
("GO:0030246","MOLECULAR_FUNCTION"),
("GO:0005509","MOLECULAR_FUNCTION"),
("GO:0005125","MOLECULAR_FUNCTION"),
("GO:0042802","MOLECULAR_FUNCTION"),
("GO:0048018","MOLECULAR_FUNCTION"),
("GO:0003887","MOLECULAR_FUNCTION"),
("GO:0043183","MOLECULAR_FUNCTION"),
("GO:0038085","MOLECULAR_FUNCTION"),
("GO:1990063","CELLULAR_COMPONENT"),
("GO:0031241","CELLULAR_COMPONENT"),
("GO:0005737","CELLULAR_COMPONENT"),
("GO:1990724","CELLULAR_COMPONENT" ),
("GO:0005615","CELLULAR_COMPONENT"),
("GO:0005886","CELLULAR_COMPONENT"),
("GO:0042774","CELLULAR_COMPONENT"),
("GO:0009986","CELLULAR_COMPONENT"),
("GO:0005829","CELLULAR_COMPONENT"),
("GO:1990150","CELLULAR_COMPONENT"),
("GO:0043293","CELLULAR_COMPONENT"),
("GO:0001774","BIOLOGICAL_PROCESS"),
("GO:0038177","MOLECULAR_FUNCTION");


DESCRIBE go_terms_aspect;

#Find duplicates:
SELECT GO_terms, COUNT(*) AS count
FROM go_terms_aspect
GROUP BY GO_terms
HAVING COUNT(*)>1;

#By default, the starting value for AUTO_INCREMENT is 1, and it will increment by 1 for each new record.
ALTER TABLE GO_Annotations
MODIFY COLUMN Title varchar(255);

INSERT INTO GO_Annotations(GO_terms,GeneProduct_Symbol,Source,Title,PMID)
VALUES
("GO:0051205","BamE",NULL,"Phylogenetic-based propagation of functional annotations within the Gene Ontology consortium","PMID:21873635"),
("GO:1901612","BamE",NULL,"Structure and function of BamE within the outer membrane and the β-barrel assembly machine.","PMID:21212804"),
("GO:0031241","BamE",NULL,"Phylogenetic-based propagation of functional annotations within the Gene Ontology consortium","PMID:21873635"),
("GO:0006259","polA",NULL,"Phylogenetic-based propagation of functional annotations within the Gene Ontology consortium","PMID:21873635"),
("GO:0034061","polA",NULL,NULL,"GO_REF:0000002"),
("GO:0005737","polA",NULL,"Protein abundance profiling of the Escherichia coli cytosol","PMID:18304323"),
("GO:0005737","caiB",NULL,NULL,"GO_REF:0000104"),
("GO:0008735","caiB",NULL,"Molecular characterization of the cai operon necessary for carnitine metabolism in Escherichia coli.","PMID:7815937"),
("GO:0042413","caiB",NULL,"Cloning, nucleotide sequence, and expression of the Escherichia coli gene encoding carnitine dehydratase.","PMID:8188598"),
("GO:0005829","POLH",NULL,NULL,"GO_REF:0000052"),
("GO:0006260","POLH",NULL,NULL,"GO_REF:0000043"),
("GO:0003887","POLH",NULL,"Phylogenetic-based propagation of functional annotations within the Gene Ontology consortium.","PMID:21873635"),
("GO:0005509","SELL",NULL,"Glycan Bound to the Selectin Low Affinity State Engages Glu-88 to Stabilize the High Affinity State under Force.","PMID:28011641"),
("GO:0033691","SELL",NULL,"Phylogenetic-based propagation of functional annotations within the Gene Ontology consortium","PMID:21873635"),
("GO:0005886","SELL",NULL,"Characterization of a human homologue of the murine peripheral lymph node homing receptor.","PMID:2663882"),
("GO:0030246","SELL",NULL,"An activated L-selectin mutant with conserved equilibrium binding properties but enhanced ligand recognition under shear flow.","PMID:10747985"),
("GO:0050901","SELL",NULL,"Glycan Bound to the Selectin Low Affinity State Engages Glu-88 to Stabilize the High Affinity State under Force.","PMID:28011641"),
("GO:0042802","TNF",NULL,"Structure of tumour necrosis factor.","PMID:2922050"),
("GO:0071230","TNF",NULL,NULL,"GO_REF:000010"),
("GO:0035900","TNF",NULL,NULL,"GO_REF:0000107"),
("GO:0009986","TNF",NULL,"Ectodomain shedding of TNF-alpha is enhanced by nardilysin via activation of ADAM proteases.","PMID:18355445"),
("GO:0030730","TNF",NULL,"Interleukin-1beta and tumour necrosis factor-alpha impede neutral lipid turnover in macrophage-derived foam cells.","PMID:19032770"),
("GO:0001774","Tnf",NULL,"The microRNA miR-181c controls microglia-mediated neuronal apoptosis by suppressing tumor necrosis factor.","PMID:22950459"),
("GO:0038177","Tnf",NULL,NULL,"GO_REF:0000096"),
("GO:0005125","Tnf",NULL,NULL,"MGI:MGI:4834177"),
("GO:0005615","Tnf",NULL,"TRat to Mouse ISO GO annotation transfer.","GO_REF:0000096"),
("GO:1990150","Vegfa",NULL,"Structure and function of VEGF receptors","PMID:19658168"),
("GO:0043183","Vegfa",NULL,"Human to Mouse ISO GO annotation transfer","J:164563"),
("GO:0038190","Vegfa",NULL,"Human to Mouse ISO GO annotation transfer","J:164563"),
("GO:0038085","Trp53",NULL,"Phylogenetic-based propagation of functional annotations within the Gene Ontology consortium.","PMID:21873635"),
("GO:0043293","Trp53",NULL,"Caspase activation involves the formation of the apoptosome, a large (approximately 700 kDa) caspase-activating complex","PMID:10428850"),
("GO:1902378","Trp53",NULL,"Rat to Mouse ISO GO annotation transfer","J:155856"),
("GO:0050901","TNF",NULL,"Differential ability of exogenous chemotactic agents to disrupt transendothelial migration of flowing neutrophils.","PMID:10820279"),
("GO:0005615", "TNF",NULL,"Lipoteichoic acid (LTA) of Streptococcus pneumoniae and Staphylococcus aureus activates immune cells via Toll-like receptor (TLR)-2, lipopolysaccharide-binding protein (LBP), and CD14, whereas TLR-4 and MD-2 are not involved.","PMID:12594207"),
("GO:0005125", "TNF", NULL,"A phosphatidylinositol 3-kinase/Akt pathway, activated by tumor necrosis factor or interleukin-1, inhibits apoptosis but does not activate NFkappaB in human endothelial cells.","PMID:10748004" );


###############
#INSERT INTO GO_Annotations(GO_terms,GeneProduct_Symbol,Source,Title,PMID)
#VALUES ("GO:0005615", "TNF",NULL,"Lipoteichoic acid (LTA) of Streptococcus pneumoniae and Staphylococcus aureus activates immune cells via Toll-like receptor (TLR)-2, lipopolysaccharide-binding protein (LBP), and CD14, whereas TLR-4 and MD-2 are not involved.","PMID:12594207"),
#("GO:0005125", "TNF", NULL,"A phosphatidylinositol 3-kinase/Akt pathway, activated by tumor necrosis factor or interleukin-1, inhibits apoptosis but does not activate NFkappaB in human endothelial cells.","PMID:10748004" );

 
SHOW FULL COLUMNS FROM GOAnnotations_EvidenceReliability;

INSERT INTO GOAnnotations_EvidenceReliability(Annotation_ID,Reliability)
VALUES
(DEFAULT,'PANTHER:PTN002444745,UniProtKB:P0A937'),
(default,"UniProtKB:P0AC02"),
(default,'PANTHER:PTN002444745,UniProtKB:P0A937'),
(default,'InterPro:IPR002562'),
(default,'PANTHER:PTN000015249'),
(default,"None"),
(default,"UniProtKB-KW:KW-0963"),
(default,"None"),
(default,"None"),
(default,"None"),
(default,"UniProtKB-KW:KW-0235"),
(default,"PANTHER:PTN000117879"),
(default,"None"),
(default,'PANTHER:PTN001456007,UniProtKB:P16581'),
(default,"None"),
(default,"None"),
(default,"None"),
(default,"UniProtKB:P01375"),
(default,"UniProtKB:P06804"),
(default,"UniProtKB:P16599"),
(default,"None"),
(default,"None"),
(default,"None"),
(default,"UniProtKB:P01375"),
(default,"UniProtKB:P01375"),
(default,"RGD:3876"),
(default,"UniProtKB:P15692"),
(default,"UniProtKB:P49765"),
(default,"UniProtKB:O14786"),
(default,"RGD:69056"),
(default,"UniProtKB:O14727"),
(default,"RGD:69329"),
(default,"None");

SELECT * 
FROM GOAnnotations_EvidenceReliability
WHERE Reliability LIKE '%UniProtKB:P0A937%';

INSERT INTO GOAnnotations_EvidenceType(Annotation_ID,Type)
VALUES
(default,"IBA"),
(default,"IPI"),
(default,"IBA"),
(default,"IEA"),
(default,"IBA"),
(default,"IDA"),
(default,"IEA"),
(default,"IEA"),
(default,"EXP"),
(default,"IDA"),
(default,"IEA"),
(default,"IBA"),
(default,"IDA"),
(default,"IBA"),
(default,"IDA"),
(default,"TAS"),
(default,"IMP"),
(default,"IPI"),
(default,"IEA"),
(default,"IEA"),
(default,"IDA"),
(default,"IDA"),
(default,"IDA"),
(default,"ISO"),
(default,"ISO"),
(default,"ISO"),
(default,"ISO"),
(default,"ISO"),
(default,"ISO"),
(default,"ISO"),
(default,"ISO"),
(default,"ISO"),
(default,"IDA");

USE go;
SHOW TABLES;

#ayto ti kanei edw?
USE go;
SHOW TABLES;
DROP TABLE go_terms;

SELECT * FROM go_annotations;
SELECT * FROM go_terms;
SELECT * FROM GOAnnotations_EvidenceType;

USE go;
SHOW TABLES;
#DROP TABLE go_terms;



UPDATE go_terms
SET RelationType="is_a" ,Related_GO_ID= "GO:0006259"
WHERE GO_ID="GO:0006260";

UPDATE go_terms
SET RelationType="is_a", Related_GO_ID="GO:0034061"
WHERE GO_ID="GO:0003887";

UPDATE go_terms
SET RelationType="is_a", Related_GO_ID="GO:0003824"
WHERE GO_ID="GO:0008735";

UPDATE go_terms
SET RelationType="part_of", Related_GO_ID="GO:0005737"
WHERE GO_ID="GO:0005829";


UPDATE go_terms
SET Definition = "Transient adhesive interactions between leukocytes and endothelial cells lining blood vessels. Carbohydrates on circulating leukocytes bind selectins on the vessel wall causing the leukocytes to slow down and roll along the inner surface of the vessel wall. During this rolling motion, transitory bonds are formed and broken between selectins and their ligands. Typically the first step in cellular extravasation (the movement of leukocytes out of the circulatory system, towards the site of tissue damage or infection)"
WHERE GO_ID="GO:0050901";

SELECT Definition
FROM go_terms WHERE GO_ID ="GO:0050901";


SELECT GeneProduct_Symbol,Name,GO_ID
FROM go_terms
INNER JOIN go_annotations ON go_terms.GO_ID = go_annotations.GO_terms
WHERE Definition like '%infection%';


SELECT A.GeneProduct_Symbol as GeneA, B.GeneProduct_Symbol as GeneB, A.GO_terms
FROM go_annotations A, go_annotations B
WHERE A.Annotation_ID < B.Annotation_ID AND A.GO_terms = B.GO_terms;


CREATE TABLE Quality_res as 
SELECT rel.Reliability,
       annot.GO_terms,
       CASE 
         WHEN rel.Reliability="None" THEN 'Not Reliable'
         ELSE 'Reliable'
       END AS Quality
FROM GOAnnotations_EvidenceReliability AS rel
INNER JOIN GO_Annotations AS annot ON rel.Annotation_ID = annot.Annotation_ID;
SELECT * FROM Quality_res limit 5;

SELECT COUNT(Quality) as Count, Quality
FROM Quality_res
GROUP BY Quality ;
