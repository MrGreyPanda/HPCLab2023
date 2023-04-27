import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

df = pd.read_csv("bench.csv", index_col=False)

# Calculate the average of the runtimes for each row
df['times'] = df.iloc[:,0]
df['procs'] = df.iloc[:,2]

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


plt.clf()  # Clear plot

plt.title("Weak Scaling")


efficiencies = np.array([1])
weak_scaling_threads = np.array([1])
thread_number = 1
for i, n in enumerate(sizes[-13:]):
    if thread_number > threads.max():
        break

    serial_runtime = df[df["size"] == n]["runtime_avg"].iloc[0]
    parallel_runtime = df[(df["size"] == n) & (
        df["threads"] == thread_number)]["runtime_avg"].iloc[0]
    speedup = serial_runtime / parallel_runtime
    efficiencies = np.append(efficiencies, speedup / thread_number)
    weak_scaling_threads = np.append(weak_scaling_threads, thread_number)
    thread_number *= 4

plt.plot(weak_scaling_threads, efficiencies)
plt.plot(np.array([weak_scaling_threads.min(),
         weak_scaling_threads.max()]), np.array([1, 1]), 'r--')

plt.ylim(0, np.max([1.05, efficiencies.max() + 0.05]))
plt.xlabel('Number of Threads')
plt.ylabel('Efficiency')

plt.savefig('weak_scaling.png')
