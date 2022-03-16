# DepFunc
This is a system to build contextualized word vectors by using compositional distributional semantics and syntactic dependencies. This version works with subject-verb-object trigrams (transitive constructions) for three languages: English, Galician, Portuguese, and Spanish. Three annotated datasets, one per language, are also provided in the `./test` directory.

## REQUIREMENTS

* Perl and bash interpreters, and java just for evaluation. 

## HOW TO INSTALL

```
sh install.sh
```

## HOW TO USE

If you wish to run the system and evaluate the results on the four datasets for the four languages: 
```
sh RUN.sh en
sh RUN.sh gl
sh RUN.sh pt
sh RUN.sh es
```

Each run generates three types of files:

* Compositional models stored in directory `./models`
* Similarity scores, stored in `./simil`
* Final evaluation scores (spearman) in  `./eval/results` 

The evaluation score were computed using the three datasets stored in `tests`.

### References
* Gamallo, Pablo (2019) "A dependency-based approach to word contextualization using compositional distributional semantics", Journal of Language Modelling, 7(1), pp. 53-92. DOI: 10.15398/jlm.v7i1.201.

* Gamallo, Pablo, Manuel de Prada Corral, Marcos, Garcia (2021), “Comparing Dependency-based Compositional Models with Contextualized Word Embeddings”. Proceedings of the 13th International Conference on Agents and Artificial Intelligence - ICAART 2021, Volume 2, pp. 1258-1265.
