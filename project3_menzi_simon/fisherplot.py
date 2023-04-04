import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


df = pd.read_csv("strong_output.csv", index_col=False)
# Strong scaling plot
threads = pd.unique(df["threads"])
sizes = pd.unique(df["size"])
runtimes = df[:,2:].mean(axis=1)

# print(runtimes, threads, sizes)

plt.title('Strong Scaling')

max_speedup = 0

for n in sizes:
    runtimes = df[df['size'] == n]["runtime"]
    speedup = runtimes.iloc[0] / runtimes
    print(speedup)
    plt.plot(threads, speedup, label=n)

    if max_speedup < speedup.max():
        max_speedup = speedup.max()

plt.xlabel('Number of Threads')
plt.ylabel('Speedup')
plt.legend()

plt.plot(np.array([1, max_speedup]), np.array([1, max_speedup]), 'r--')

plt.savefig('strong_scaling.png')
