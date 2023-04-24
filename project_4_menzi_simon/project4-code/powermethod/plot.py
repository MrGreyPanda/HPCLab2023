import matplotlib.pyplot as plt
import numpy as np

# Load data from bench.csv
data = np.genfromtxt('bench.csv', delimiter=',', usecols=(0,2))

# Extract the timings and number of processors from the data
timings = data[:,0]
procs = data[:,1]

# Calculate the speedup and efficiency
speedup = timings[0]/timings
efficiency = speedup/procs

# Create the plot
fig, ax = plt.subplots()
ax.plot(procs, efficiency, '-o')
ax.set_xlabel('Number of Processors')
ax.set_ylabel('Efficiency')
ax.set_title('Strong Scaling Plot')
ax.grid()

# Show the plot
plt.show()