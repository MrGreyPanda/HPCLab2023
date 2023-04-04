import matplotlib as plt
import numpy as np
import pandas as pd


df = pd.read_csv("runtimes.csv")

# Strong scaling plot
runtimes = df["runtime"]
threads = pd.unique(df["threads"])
sizes = pd.unique(df["size"])

plt.title('Strong Scaling')

max_speedup = 0

for n in sizes:
    runtimes = df[df['size'] == n]["runtime"]
    speedup = runtimes.iloc[0] / runtimes
    print(speedup)
    plt.plot(threads, speedup, label=n)

    if max_speedup < speedup.max(): 
        max_speedup = speedup.max()

pyplot.plt.xlabel('Number of Threads')
pyplot.plt.ylabel('Speedup')
pyplot.plt.legend()

pyplot.plt.plot(np.array([1, max_speedup]), np.array([1, max_speedup]), 'r--')

plt.savefig('strong_scaling.png')
