# -*- coding: utf-8 -*-
"""
Created on Tue Oct 18 19:15:19 2016

@author: Martin
"""

import nltk
import numpy
from pylab import *
from nltk import FreqDist

def printZipfDistribution(freqdist, amount=50):
    '''
    Function that prints how often the most common elements of the FreqDist appear compared
    to the most common element of the FreqDist. Frequencies of most common element/ i:th elements frequencies
    :param freqdist: a FreqDist object containing the frequence distance to print zipf distribution
    :param amount: Optional argument to specify the amount of elements to be printed
    '''
    values = []
    for i in range(50):
        values.append(freqdist.most_common(amount)[i][1])
    
    all_freq = sorted(freqdist.values(),  reverse=True)
        
    rank=list(range(1,len(all_freq)+1))
    k_tmp = [i*j for i, j in zip(rank,all_freq)]  # This was the definition in the assignment
    # k = [p/max(values) for p in values]  # This should be [1,1/2,1/3,1/4,etc.] if zipf
    k_mean=numpy.mean(k_tmp)
    k_max=max(k_tmp)
    k_min=min(k_tmp)
    k_std=100*(numpy.std(k_tmp))/k_mean # Get std of K in percent
    print('k_mean = ',k_mean)
    print('k_max = ',k_max)
    print('k_min = ',k_min)
    print('k_std = ',k_std ,' %')

f = open('en.txt')
raw = f.read()
# wordpunct tokenizes according to \w+|[^\w\s]+.
# wordpunct tokenizes a text into a sequence of alphabetic and non-alphabetic characters
tokens = nltk.wordpunct_tokenize(raw)
text = nltk.Text(tokens)
fdistOfTokens = FreqDist([w.lower() for w in text])

# Without punctuation
words_tmp = [w.lower() for w in text if w.isalpha()]
fdistOfWords = FreqDist(words)

# For characters
fdistOfChars = nltk.FreqDist(ch.lower() for ch in raw if not ch.isspace())

# Prints
#print(fdistOfWords.most_common(50))
#print(fdistOfChars.most_common(50))
print('----------------k-value for the words----------------')
printZipfDistribution(fdistOfWords)
print('----------------k-value for the chars----------------')
printZipfDistribution(fdistOfChars)
print('----------------Number of unique words----------------')
print('Unique words: ',len(set(fdistOfWords)))

# Plots
matplotlib.pyplot.figure(figsize=(14, 8))
matplotlib.pyplot.subplot(222)
wordRanks = numpy.arange(1, len(fdistOfWords)+1)
wordFrequencies = sorted(fdistOfWords.values(), reverse=True)
loglog(wordRanks, wordFrequencies, marker=".")
goldenStandardWords = []
i = 0
maxFreqWord = max(wordFrequencies)
for x in range(len(wordRanks)):
    i += 1
    goldenStandardWords.append(1/i * maxFreqWord)
loglog(wordRanks, goldenStandardWords, marker=".")

#print(goldenStandardWords)
xlabel("rank")
ylabel("frequency")

matplotlib.pyplot.subplot(224)
charRanks = numpy.arange(1, len(fdistOfChars) + 1)
charFrequenies = sorted(fdistOfChars.values(), reverse=True)
loglog(charRanks, charFrequenies, marker=".")
goldenStandardChars = []
i = 0
maxFreqChars = max(charFrequenies)
for x in range(len(charRanks)):
    i += 1
    goldenStandardChars.append(1/i * maxFreqChars)
loglog(charRanks, goldenStandardChars, marker=".")
#print(goldenStandardChars)
xlabel("rank")
ylabel("frequency")

matplotlib.pyplot.subplot(221)
# plot() method in FreqDist is defined in a blocking way the plot is doe manually in this instance
# -----------------------------------------------------------
samples = [item for item, _ in fdistOfWords.most_common(30)]
freqs = [fdistOfWords[sample] for sample in samples]
plot(freqs, linewidth=2.0)
grid(True, color="silver")
xticks(range(len(samples)), [s for s in samples], rotation=90)
xlabel("Samples")
ylabel("Counts")
# -----------------------------------------------------------

matplotlib.pyplot.subplot(223)
fdistOfChars.plot(30)
