# -*- coding: utf-8 -*-
"""
Created on Wed Nov 30 23:55:24 2016

@author: Martin
"""

from auxiliar import getWordsFromFile,getTaggedWordsFromFile,getTagsFromTaggedWords,countNgrams
from math import log

# --------------------------------------------------------
# unigram
def unigramEntropy(unicount, bicount, tricount, totalWordCount):
    uniProbs = {}
    unigramOrder = 0.0
    for word in unicount.keys():
        prob = unicount[word]/float(totalWordCount)
        uniProbs[word] = prob
        unigramOrder += prob * log(prob)
    unigramOrder *= -1.0
    return unigramOrder

# -------------------------------------------------------
# bigram
def bigramEntropy(unicount, bicount, tricount, totalWordCount):
    biProbs = {}
    # ('word': [p(x), sum of p(y|x)* log(p(y|x))]
    for word, value in unicount.items():
        biProbs[word] = [value/float(totalWordCount), 0.0]

    for wordTuple in bicount.keys():
        # antal förekomster av specifik tuple / antal förekomster av första ordet i tuplen (samma sak som antalet förekomster av tuplar med som börjar på ett specifikt ord)
        conditionalProb = bicount[wordTuple] / float(unicount[wordTuple[0]])
        biProbs[wordTuple[0]][1] += conditionalProb * log(conditionalProb)
    bigramOrder = 0

    # the sum of [xProb, sum of yProbs] for each word
    for wordProbs in biProbs.values():
        bigramOrder += wordProbs[0]*wordProbs[1]
    bigramOrder *= -1
    return bigramOrder

# --------------------------------------------------------
# trigram
def trigramEntropy(unicount, bicount, tricount, totalWordCount):
    # word : [p(x),sum of p(y|x),sum of p(z|xy)]
    trigramProbs = {}

    # Compute the sum of p(z|xy)
    for tword, tcount in tricount.items():
        #['the','long','story'] => condiion tuple: ['the', 'long']
        bword = (tword[0], tword[1])
        bcount = bicount[bword]
        #trigram count/bigram count of first two words
        condProbZXY = tcount/float(bcount)

        # if word already exist in dict, add value to existing probability sum
        if bword in trigramProbs:
            trigramProbs[bword] += condProbZXY * log(condProbZXY)
        # if word does not exist in dict, add new element
        else:
            trigramProbs[bword] = condProbZXY * log(condProbZXY)

    # Compute the sum of p(y|x)
    biProbs = {}
    for bword, bcount in bicount.items():
        uword = tword[0]
        ucount = float(unicount[uword])
        condProbYX = bicount[bword]/ucount
        if uword in biProbs:
            biProbs[uword] += condProbYX * trigramProbs.get(bword, 0)
        else:
            biProbs[uword] = condProbYX * trigramProbs.get(bword, 0)
    # compute p(x)
    trigramOrder = 0.0
    for word, value in unicount.items():
        trigramOrder += value/float(totalWordCount) * biProbs.get(word, 0)
    trigramOrder *= -1
    return(trigramOrder)

# --------------------------------------------------------
# smoothing
def smoothing(taggedWordList,numTags):
    # numTags is either 1 for <x',y,z> or 2 for <x',y',z>
    smoothList={}
    for word,count in taggedWordList.items():
        if numTags==1:
            smoothList[(word[0][1],word[1][0],word[2][0])] = count
        elif numTags==2:
            smoothList[(word[0][1],word[1][1],word[2][0])] = count
    return smoothList



def countNgramsBackoff(l, inic, end = 0, xIsTag = 0, yIsTag = 0):
    """
    From a list l (of words or pos), an inic position and an end position
    a tuple(U,B,T) of dics corresponding to unigrams, bigrams and trigrams are built
    """
    if end == 0:
        end = len(l)
    U, B, T = {}, {}, {}

    U[(l[inic][xIsTag])] = 1
    if (l[inic+1][xIsTag]) not in U:
        U[(l[inic+1][xIsTag])] = 1
    else:
        U[(l[inic+1][xIsTag])] += 1
    B[(l[inic][xIsTag], l[inic+1][0])] = 1
    for i in range(inic+2, end):
        if (l[i][xIsTag]) not in U:
            U[(l[i][xIsTag])] = 1
        else:
            U[(l[i][xIsTag])] += 1

        if (l[i-1][xIsTag], l[i][yIsTag]) not in B:
            B[(l[i-1][xIsTag], l[i][yIsTag])] = 1
        else:
            B[(l[i-1][xIsTag], l[i][yIsTag])] += 1
        if (l[i-2][xIsTag], l[i-1][yIsTag], l[i][0]) not in T:
            T[(l[i-2][xIsTag], l[i-1][yIsTag], l[i][0])] = 1
        else:
            T[(l[i-2][xIsTag], l[i-1][yIsTag], l[i][0])] += 1
    return (U, B, T)

#------------------------------------MAIN-------------------------------

words = getWordsFromFile('en.txt')

(unicount,bicount,tricount) = countNgrams(words,0)

print("unigram")
print(unigramEntropy(unicount,bicount,tricount,len(words)))
print("perplexity unigram")
print(math.pow(2,unigramEntropy(unicount,bicount,tricount,len(words))))
print("bigram")
print(bigramEntropy(unicount, bicount, tricount, len(words)))
print("perplexity bigram")
print(math.pow(2,bigramEntropy(unicount,bicount,tricount,len(words))))
print("trigram")
print(trigramEntropy(unicount, bicount, tricount, len(words)))
print("perplexity trigram")
print(math.pow(2,trigramEntropy(unicount,bicount,tricount,len(words))))

print("(x,y,z), words, full")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(words))))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(words))))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(words))))

print("(x,y,z), words, half")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(words)/2)))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(words)/2)))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(words)/2)))

print("(x,y,z), words, quarter")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(words)/4)))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(words)/4)))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(words)/4)))


tagWords=getTaggedWordsFromFile('taggedBrown.txt')
(unicount,bicount,tricount) = countNgramsBackoff(tagWords,0,0,0,0)

print("(x',y',z'), pos tags, full")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(tagWords))))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(tagWords))))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(tagWords))))

half = int( len(tagWords)/2)
quarter = int( len(tagWords)/4)
(unicount,bicount,tricount) = countNgramsBackoff(tagWords,0,half,0,0)
print("(x',y',z'), pos tags, half")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(tagWords)/2)))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(tagWords)/2)))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(tagWords)/2)))


(unicount,bicount,tricount) = countNgramsBackoff(tagWords,0,quarter,0,0)
print("(x',y',z'), pos tags, quarter")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(tagWords)/4)))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(tagWords)/4)))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(tagWords)/4)))


(unicount,bicount,tricount) = countNgramsBackoff(tagWords,0,0,1,0)
print("(x',y,z), pos tags & words, full")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(tagWords))))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(tagWords))))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(tagWords))))

(unicount,bicount,tricount) = countNgramsBackoff(tagWords,0,half,1,0)
print("(x',y,z), pos tags & words, half")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(tagWords)/2)))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(tagWords)/2)))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(tagWords)/2)))

(unicount,bicount,tricount) = countNgramsBackoff(tagWords,0,quarter,1,0)
print("(x',y,z), pos tags & words, quarter")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(tagWords)/4)))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(tagWords)/4)))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(tagWords)/4)))

(unicount,bicount,tricount) = countNgramsBackoff(tagWords,0,0,1,1)
print("(x',y',z), pos tags & words, full")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(tagWords))))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(tagWords))))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(tagWords))))

(unicount,bicount,tricount) = countNgramsBackoff(tagWords,0,half,1,1)
print("(x',y',z), pos tags & words, half")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(tagWords)/2)))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(tagWords)/2)))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(tagWords)/2)))

(unicount,bicount,tricount) = countNgramsBackoff(tagWords,0,quarter,1,1)
print("(x',y',z), pos tags & words, quarter")
print("perplexity unigram", pow(2, unigramEntropy(unicount,bicount,tricount,len(tagWords)/4)))
print("perplexity bigram", pow(2, bigramEntropy(unicount, bicount, tricount,len(tagWords)/4)))
print("perplexity trigram", pow(2, trigramEntropy(unicount, bicount, tricount, len(tagWords)/4)))


