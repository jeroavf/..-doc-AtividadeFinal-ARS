#An�lise de redes aplicada a artigos cient�ficos
library(bibliometrix)
library(easyPubMed)
library(igraph)

#Search on PubMed

#Termos de busca comuns
#Affiliation	  [AD]	  First listed author's institutional affiliation and address
#Author	  [AU]	  Author name #Corporate Name as Author	  [CN]	  Corporate names as authors
#Full Author Name	  [FAU]	  Full author name (2002 onward, if available)
#Issue	  [IP]	  Journal issue number #Journal Title	  [TA]	  Title of journal, journal title abbreviation, ISSN
#Language	  [LA]	  Language of the article (not the abstract) #Last Author Name	  [LASTAU]  	  Last personal author in a citation
#MeSH Major Topic	  [MAJR]	  Main topic of an article #MeSH Subheading	  [SH]	  MeSH Subheading
#MeSH Terms	  [MH]	  MeSH Term #Pagination	  [PG]	  First page number of a journal article
#Personal Name as Subject	  [PS]	  Person as the subject of an article, not as an author
#Publication Date	  [PD]	  Date an article was published #Publication Type	  [PT]	  Format of an article (letter, clinical trial, etc) rather than content
#Substance Name	  [NM]	  Chemical and substance names discussed in an article
#Text Word	  [TW]	  Textual fields of PubMed records #Title	  [TI]	  Article title
#Title or Abstract	  [TIAB]	  Words in an article title or an abstract #Volume	  [VI]	  Volume number of a particular journal
#Year	  [DP]	  The year when a journal article was published. #Search a date range, type in   2000:2009[DP]

############################## Dados Site PubMed Web #######################
#Busca no Site PubMed Web
query_string <- "INFORMATION [TIAB]" #fazer o ajuste da busca conforme necessidade
on_pubmed <- get_pubmed_ids(query_string)
print(on_pubmed$Count)
print(unlist(on_pubmed$IdList))
papers <- fetch_pubmed_data(on_pubmed, format = "xml")
papers_list <- articles_to_list(papers)
#Transformar Lista em Data Frame
my_papers_df<-c()
if (length(papers_list) >=1){
  for (i in 1:length(papers_list)-1){
    my_papers_df<-rbind(my_papers_df, article_to_df(papers_list[[i]], autofill = TRUE, max_chars = 500))
  }
}
#Transforma Data Frame em Rede
edge_list<-cbind(my_papers_df$pmid, paste(my_papers_df$lastname, my_papers_df$firstname, sep = ", "))
colnames(edge_list)<-c("pmid", "AU")
gPub<-graph_from_data_frame(edge_list, directed = FALSE)
#Checando se � um grafo de dois modos e classificadno em tipo 1 e 2
bipartite_mapping(gPub)$res
V(gPub)$type<-as.logical((1:vcount(gPub)<=vcount(gPub)-length(unique(edge_list[,2]))))
#verificar o tamanho das redes transformadas antes de realizar a transforma??o
bipartite_projection_size(gPub)
#Criar as redes de um modo com base na rede de dois modos
gPubAU<-bipartite_projection(gPub)[[1]]
gPubID<-bipartite_projection(gPub)[[2]]
plot (gPub)

############################## Dados da rede VOS/Gephi no formato Graphml#######################
 library(igraph)
 # Retorna o diret�rio corrente
 getwd() 
 # Seta o diret�rio
 setwd("NetworkAnalysis") 
 # Lista os arquivos do diret�rio
 dir()
 # clear all variables
 rm(list = ls(all.names = TRUE))
 # L� o grafo salvo do Gephi no formato graphml. O arquivo deve estar no diret�rio setado ant
 my_graph <-read.graph("UserStudy&Experience_Co-CitationAuthorOnlyFirst_418_Gephi.graphml", format("graphml"))
  # Mostra a descri��o do grafo
 str(my_graph)

############################## Dados Web of Science ou Scopus#######################
library(bibliometrix)
library(igraph)
 
## Retorna o diret�rio corrente
getwd() 

##Seta o diret�rio
setwd("NetworkAnalysis")

# clear all variables
rm(list = ls(all.names = TRUE))
#
# VARI�VEIS GLOBAIS
#
my_papers_df = data.frame()          # VARI�VEL QUE ARMAZENA O DATAFRAME PRINCIPAL CONSTRU�DO PELO BIBLIOMETRIX
my_graph =""                         # VARI�VEL QUE ARMAZENA O GRAFO GERADO 
my_results = ""                      # VARIAVEL QUE ARMAZENA ANALISE FEITA PELO BIBLIOMETRIX
my_NetMatrix = ""

# L� O ARQUIVO TEXTO DA WEB OF SCIENCE OU SCOPUS
LeArquivoTexto = function(my_file){
  my_lines_papers<<-readFiles(my_file)
}

# TRANSFORMA O TEXTO DO ARQUIVO EM DATAFRAME (WEB OF SCIENCE OU SCOPUS)
TransformaTextoEmDataframe = function(){
  my_dbsource = "isi" 
  my_format = "plaintext" 
  my_papers_df <<-convert2df(my_lines_papers, dbsource=my_dbsource, format=my_format) #definir formato e font
  my_papers_df <<- metaTagExtraction(my_papers_df, Field = "AU_CO", sep = ";")
  my_papers_df <<- metaTagExtraction(my_papers_df, Field = "CR_AU", sep = ";")
  my_papers_df <<- metaTagExtraction(my_papers_df, Field = "CR_SO", sep = ";")
  my_papers_df <<- metaTagExtraction(my_papers_df, Field = "AU_UN", sep = ";")
}

# CALCULA MEDIDAS CENTRALIDADE
CalculaMedidasCentralidade = function(){
  
  # Grau = grau de entrada + grau de sa�da
  my_graph.degree <<- degree(my_graph)
  my_graph.degree.summary <<-summary(my_graph.degree)
  my_graph.degree.sd <<-sd(my_graph.degree)
  my_graph.degree.var <<-var(my_graph.degree)
  
  # Grau de entrada
  my_graph.indegree <<- degree(my_graph, mode = c("in"))  #mode = c("all", "out", "in", "total")
  my_graph.indegree.summary <<-summary(my_graph.indegree)
  my_graph.indegree.sd <<-sd(my_graph.indegree)
  my_graph.indegree.var <<-var(my_graph.indegree)
  
  # Grau de saida 
  my_graph.outdegree <<- degree(my_graph, mode = c("out")) #mode = c("all", "out", "in", "total")
  my_graph.outdegree.summary <<-summary(my_graph.outdegree)
  my_graph.outdegree.sd <<-sd(my_graph.outdegree)
  my_graph.outdegree.var <<-var(my_graph.outdegree)
  
  # 4.2 For�a dos v�rtices
  # For�a = for�a de entrada + for�a de sa�da
  my_graph.strengh <<-graph.strength(my_graph)
  my_graph.strengh.summary <<-summary(my_graph.strengh)
  my_graph.strengh.sd <<-sd(my_graph.strengh)
  
  # For�a de entrada
  my_graph.instrengh <<- graph.strength(my_graph, mode =c("in"))
  my_graph.instrengh.summary <<-summary(my_graph.instrengh)
  my_graph.instrengh.sd <<-sd(my_graph.instrengh)
  
  # For�a de sa�da
  my_graph.outstrengh <<- graph.strength(my_graph, mode =c("out"))
  my_graph.outstrengh.summary <<-summary(my_graph.outstrengh)
  my_graph.outstrengh.sd <<-sd(my_graph.outstrengh)
  
  # 4.7 log log
  my_graph.degree.distribution <<- degree.distribution(my_graph)
  my_d <<- 1:max(my_graph.degree)-1
  my_ind <<- (my_graph.degree.distribution != 0) 
  
  #4.8 - knn Calculate the average nearest neighbor degree of the given vertices and the same quantity in the function of vertex degree
  #my_graph.a.nn.deg <<- graph.knn(my_graph,V(my_graph))$knn
  
  # Diameter - dist�ncia geodesica
  my_graph.diameter <<-diameter(my_graph, directed = TRUE, unconnected=TRUE, weights = NULL)
  
  ##Retorna os caminho com diametro atual
  my_graph.get_diameter <<-get_diameter(my_graph)
  
  ##Retorna os 2 v�rtices que s�o conectados pelo di�metro
  my_graph.farthest_vertices <<-farthest_vertices(my_graph)
  
  # 4.Proximidade - A centralidade de proximidade mede quantas etapas s�o necess�rias para acessar cada outro v�rtice de um determinado v�rtice.
  my_graph.closeness <<- closeness(my_graph)
  my_graph.closeness <<- centralization.closeness(my_graph)
  my_graph.closeness.res.sumary <<- summary (my_graph.closeness$res)
  my_graph.closeness.res.sd <<-sd(my_graph.closeness$res)
  
  # 4.Intermedia��o
  my_graph.betweenness <<- betweenness(my_graph)
  my_graph.betweenness <<- centralization.betweenness(my_graph)
  my_graph.betweenness.res.sumary <<-summary (my_graph.betweenness$res)
  my_graph.betweenness.res.sd <<-sd(my_graph.betweenness$res)
  
  # 4.Excentricidade
  my_graph.eccentricity <<-eccentricity(my_graph)
  my_graph.eccentricity.sumary <<- summary (my_graph.eccentricity)
  my_graph.eccentricity.sd <<-sd(my_graph.eccentricity)
  
  # 4.eigen_centrality
  my_graph.eigen <<-eigen_centrality(my_graph)
  
  # 4.Densidade
  my_graph.density <<-graph.density(my_graph)
  
  # Modularidade
  wtc <- cluster_walktrap(my_graph)
  #modularity(wtc)
  my_graph.modularity <<-modularity(my_graph, membership(wtc))
  my_graph.modularity.matrix <<-modularity_matrix(my_graph,membership(wtc))
  
  # Page Rank
  my_graph.pagerank <<-page.rank(my_graph)
  
  #Clusterring
  my_graph.clustering <<-clusters(my_graph)
  
}
#
# PROGRAMA PRINCIPAL

#my_file = "UserStudy&Experience_Corrigido.txt"
my_file = "CI_User_Study_Experience_Emotion.txt"
LeArquivoTexto (my_file)
my_file.info = paste ("Arquivo:", c(my_file), "Num. linhas:",length(my_lines_papers))
my_file.info

TransformaTextoEmDataframe()

# ##### Collaboration Networks #####
# my_analysis = "collaboration"
# my_network = "authors"
# my_network = "universities"
# my_network = "countries"
# ##### Co-citation Networks #####
# my_analysis = "co-citation" 
# my_network = "authors"
# my_network = "references"
# my_network = "sources"
# ##### Coupling Networks #####
# my_analysis = "coupling"
# my_network = "references"
# my_network = "authors"
# my_network = "sources"
# my_network = "countries"
# ##### Co-occurrences Networks #####
# my_analysis = "co-occurrences"
# my_network = "authors"
# my_network = "sources"
# my_network = "keywords"
# my_network = "author_keywords"
# my_network = "titles"
# my_network = "abstracts"

 # TRASFORMA O DATAFRAME EM GRAFO. ESCOLHA O TIPO DE AN�LISE, TIPO DE REDE E O NETDEGREE.
 my_netDegree <- 40
 my_analysis = "co-citation"
 my_network = "authors"
 my_NetMatrix=""
 my_NetMatrix <- biblioNetwork(my_papers_df, analysis = my_analysis, network = my_network, sep = ";")
 diag <- Matrix::diag 
 my_NetMatrix <- my_NetMatrix[diag(my_NetMatrix) >= my_netDegree,diag(my_NetMatrix) >= my_netDegree]
 diag(my_NetMatrix) <- 0
 my_graph <<- graph.adjacency(my_NetMatrix,mode = "directed")
 #my_graph <<-graph_from_adjacency_matrix(papers_matrix, mode = "directed" )
 my_graph.description <- paste ("Network of",my_analysis,"of",my_network, 
                                "with threshold:", my_netDegree,"G=(", vcount(my_graph), ",", ecount(my_graph), ").")
 my_graph.description
 
 #str(my_graph)
 
 # CALCULA AS MEDIDAS DE CENTRALIDADE
 CalculaMedidasCentralidade ()
 
 #
 # PLOTANDO A REDE
 
 # Usando a fun��o do Igraph
 plot(my_graph,edge.arrow.size=.4, edge.curved=.1,layout = layout.sphere, #layout.sphere #layout.fruchterman.reingold,
      vertex.color="orange",vertex.frame.color = 'blue',
      vertex.label.dist = 0.5,
      vertex.label.color = 'black',
      vertex.label.font = 1, vertex.label = V(my_graph)$name, vertex.label.cex = 0.7)
 
 # usando a fun��o do Bibliometrix
 my_num_k <- vcount(my_graph)
 networkPlot(my_NetMatrix, n = my_num_k, Title = paste (c(my_analysis),c(my_network)), type = "circle", size=TRUE, remove.multiple=TRUE)
 
 # dev.off()
 
 #
 # IMPRIME AS MEDIDAS DE CENTRALIDADE
 #
 # GRAU DOS VERTICES
 hist(my_graph.degree,col="lightblue",xlim=c(0, max(my_graph.degree)),xlab="Grau dos v�rtices", ylab="Frequ�ncia", main="", axes="TRUE")
 legend("topright", c(paste("M�nimo =", round(my_graph.degree.summary[1],2)), 
                      paste("M�ximo=", round(my_graph.degree.summary[6],2)), 
                      paste("M�dia=", round(my_graph.degree.summary[4],2)),
                      paste("Mediana=", round(my_graph.degree.summary[3],2)),
                      paste("Desvio Padr�o=", round(my_graph.degree.sd[1],2))),
        pch = 1, title = "Grau")
 
 # GRAU DE ENTRADA
 hist(my_graph.indegree,col="lightblue", xlab="Grau de entrada", ylab="Frequ�ncia", main="", axes="TRUE")
 legend("topright", c(paste("M�nimo =", round(my_graph.indegree.summary[1],2)), 
                      paste("M�ximo=", round(my_graph.indegree.summary[6],2)), 
                      paste("M�dia=", round(my_graph.indegree.summary[4],2)),
                      paste("Mediana=", round(my_graph.indegree.summary[3],2)),
                      paste("Desvio Padr�o=", round(my_graph.indegree.sd[1],2))),
        pch = 1, title = "Grau entrada")
 
 # GRAU DE SA�DA
 hist(my_graph.outdegree,col="lightblue", xlab="Grau de sa�da", ylab="Frequ�ncia", main="", axes="TRUE")
 legend("topright", c(paste("M�nimo =", round(my_graph.outdegree.summary[1],2)), 
                      paste("M�ximo=", round(my_graph.outdegree.summary[6],2)), 
                      paste("M�dia=", round(my_graph.outdegree.summary[4],2)),
                      paste("Mediana=", round(my_graph.outdegree.summary[3],2)),
                      paste("Desvio Padr�o=", round(my_graph.outdegree.sd[1],2))),
        pch = 1, title = "Grau sa�da")
 
 # BOXPLOT: GRAU ENTRADA, GRAU SA�DA E GRAU TOTAL
 boxplot(my_graph.indegree, my_graph.outdegree, my_graph.degree, notch = FALSE, ylab = 'Grau', 
         names = c('Grau entrada', 'Grau sa�da', 'Grau total'), 
         main = 'Boxplot do grau dos v�rtices', col = c('blue', 'red', 'orange'),shrink=0.8, textcolor="red")
 
 # FOR�A
 hist(my_graph.strengh, col="pink",xlab="For�a dos v�rtices", ylab="Frequ�ncia", main="Frequ�ncia ponderada da for�a dos v�rtices")
 legend("topright", c(paste("M�nimo =", round(my_graph.strengh.summary[1],2)), 
                      paste("M�ximo=", round(my_graph.strengh.summary[6],2)), 
                      paste("M�dia=", round(my_graph.strengh.summary[4],2)),
                      paste("Mediana=", round(my_graph.strengh.summary[3],2)),
                      paste("Desvio Padr�o=", round(my_graph.strengh.sd[1],2))),
        pch = 1, title = "For�a")
 
 # FOR�A DE ENTRADA
 hist(my_graph.instrengh, col="pink",xlab="For�a de entrada dos v�rtices", ylab="Frequ�ncia", main="Frequ�ncia da for�a do grau de entrada dos v�rtices")
 legend("topright", c(paste("M�nimo =", round(my_graph.instrengh.summary[1],2)), 
                      paste("M�ximo=", round(my_graph.instrengh.summary[6],2)), 
                      paste("M�dia=", round(my_graph.instrengh.summary[4],2)),
                      paste("Mediana=", round(my_graph.instrengh.summary[3],2)),
                      paste("Desvio Padr�o=", round(my_graph.instrengh.sd[1],2))),
        pch = 1, title = "For�a entrada")
 
 # FOR�A DE SAIDA
 hist(my_graph.outstrengh, col="pink",xlab="For�a de sa�da dos v�rtices", ylab="Frequ�ncia", main="Frequ�ncia da for�a do grau de sa�da dos v�rtices")
 legend("topright", c(paste("M�nimo =", round(my_graph.outstrengh.summary[1],2)), 
                      paste("M�ximo=", round(my_graph.outstrengh.summary[6],2)), 
                      paste("M�dia=", round(my_graph.outstrengh.summary[4],2)),
                      paste("Mediana=", round(my_graph.outstrengh.summary[3],2)),
                      paste("Desvio Padr�o=", round(my_graph.outstrengh.sd[1],2))),
        pch = 1, title = "For�a sa�da")
 
 # BOXPLOT: FOR�A DE ENTRADA, FOR�A DE SA�DA E FOR�A TOTAL 
 boxplot(my_graph.instrengh, my_graph.outstrengh, my_graph.strengh, notch = FALSE, ylab = 'For�a', 
         names = c('For�a entrada', 'For�a sa�da', 'For�a total'), 
         main = 'Boxplot da for�a dos v�rtices', col = c('blue', 'red', 'orange'),shrink=0.8, textcolor="red")
 
 
 # 4.7 LOG LOG 
 plot(my_d[my_ind], my_graph.degree.distribution[my_ind], log="xy", col="blue",xlab=c("Log-Degree"), ylab=c("Log-Intensity"),main="Log-Log Degree Distribution")
 
 # 4.8 - knn Calculate the average nearest neighbor degree of the given vertices and the same quantity in the function of vertex degree
 # plot(my_graph.degree, my_graph.a.nn.deg, log="xy",col="goldenrod", xlab=c("Log Vertex Degree"),ylab=c("Log Average Neighbor Degree"))
 
 # DIAMETRO DA REDE - DISTANCIA GEODESICA
 my_graph.diameter
 
 # RETORNA UM CAMINHO COM DIAMETRO ATUAL
 my_graph.get_diameter
 
 # RETORNA 2 VERTICES QUE S�O CONECTADOS PELO DI�METRO
 my_graph.farthest_vertices
 
 # PROXIMIDADE - A centralidade de proximidade mede quantas etapas s�o necess�rias para acessar cada outro v�rtice de um determinado v�rtice.
 hist(my_graph.closeness$res, col="lightblue",xlab="Proximidade dos v�rtices", ylab="Frequ�ncia", main="Histograma da distribui��o da proximidade dos v�rtices")
 legend("topright", c(paste("M�nimo =", round(my_graph.closeness.res.sumary[1],2)), 
                      paste("M�ximo=", round(my_graph.closeness.res.sumary[6],2)), 
                      paste("M�dia=", round(my_graph.closeness.res.sumary[4],2)),
                      paste("Mediana=", round(my_graph.closeness.res.sumary[3],2)),
                      paste("Desvio Padr�o=", round(my_graph.closeness.res.sd[1],2))),
        pch = 1, title = "Proximidade")
 
 # INTERMEDIA��O
 hist(my_graph.betweenness$res, col="red",xlab="Proximidade dos v�rtices", ylab="Frequ�ncia", main="Histograma da distribui��o da intermedia��o dos v�rtices")
 legend("topright", c(paste("M�nimo =", round(my_graph.betweenness.res.sumary[1],2)), 
                      paste("M�ximo=", round(my_graph.betweenness.res.sumary[6],2)), 
                      paste("M�dia=", round(my_graph.betweenness.res.sumary[4],2)),
                      paste("Mediana=", round(my_graph.betweenness.res.sumary[3],2)),
                      paste("Desvio Padr�o=", round(my_graph.betweenness.res.sd[1],2))),
        pch = 1, title = "Intermedia��o")
 
 
 # EXCENTRICIDADE
 hist(my_graph.eccentricity, col="lightblue",xlab="Proximidade dos v�rtices", ylab="Frequ�ncia", main="Histograma da distribui��o da excentridade dos v�rtices")
 legend("topright", c(paste("M�nimo =", round(my_graph.eccentricity.sumary[1],2)), 
                      paste("M�ximo=", round(my_graph.eccentricity.sumary[6],2)), 
                      paste("M�dia=", round(my_graph.eccentricity.sumary[4],2)),
                      paste("Mediana=", round(my_graph.eccentricity.sumary[3],2)),
                      paste("Desvio Padr�o=", round(my_graph.eccentricity.sd[1],2))),
        pch = 1, title = "Excentricidade")
 
 # EIGEN_CENTRALITY
 hist(my_graph.eigen$vector, col="lightblue",xlab="Proximidade dos v�rtices", ylab="Frequ�ncia", main="Histograma da distribui��o da eigen_centrality dos v�rtices")
 
 # DENSIDADE
 
 # MODULARIDADE
 wtc <- cluster_walktrap(my_graph)
 modularity(wtc)
 my_graph.modularity<-modularity(my_graph, membership(wtc))
 my_graph.modularity.matrix <-modularity_matrix(my_graph,membership(wtc))
 
 # PAGE RANK
 hist(my_graph.pagerank$vector, col="lightblue",xlab="Page Rank", ylab="Frequ�ncia", main="Histograma da distribui��o da Page Rank dos v�rtices")
 
 # CLUSTERING - DESENVOLVER

 