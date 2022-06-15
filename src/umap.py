import time
import numpy as np
import umap
import json

X = np.genfromtxt('path/to/Xw.csv', delimiter = ',', skip_header = 1)

low_memory = False

output = {}
wName = '/path/to/results/umap.json'

for nn in [64, 320, 639, 3197, 6393]:

	strt = time.time()
	Y = umap.UMAP(n_neighbors = nn, min_dist = .1, metric = 'euclidean', init = 'random', low_memory = low_memory).fit_transform(X)
	t = time.time() -strt

	ppx = round(nn /X.shape[0], 2)
	print('+++ done ppx %4.3f, nn %5.0f in %s secs.' % (ppx, nn, round(t, 2)))

	# save results up to here
	output[str(nn)] = {'Y': Y.tolist(), 't': t}
	with open(wName, 'w') as f:
		json.dump(output, f)

