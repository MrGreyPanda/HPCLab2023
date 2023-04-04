import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

df = pd.read_csv("strong_output.csv", index_col=False)

# Calculate the average of the runtimes for each row
df['runtime_avg'] = df.iloc[:, 2:].mean(axis=1)

# Store the result in a variable called runtimes
runtimes = df['runtime_avg']

plt.title('Strong Scaling')

max_speedup = 0

sizes = pd.unique(df["size"])
threads = pd.unique(df["threads"])

for n in sizes:
    runtimes = df[df['size'] == n]["runtime_avg"]
    speedup = runtimes.iloc[0] / runtimes
    plt.plot(threads, speedup, label=n)
    if max_speedup < speedup.max():
        max_speedup = speedup.max()

plt.xlabel('Number of Threads')
plt.ylabel('Speedup')
plt.legend()
plt.plot(np.array([1, max_speedup]), np.array([1, max_speedup]), 'r--')
plt.savefig('strong_scaling.png')
