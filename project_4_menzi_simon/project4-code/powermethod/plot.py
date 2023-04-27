import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# Read in raw data (col1: cores col2: time)
df = pd.read_csv("bench.csv", index_col=False)
df['times']=df[:,0]
times = df['times']
df['procs']=df[:,2]


procs = df['procs']
# Calculate the speedup; last time in the "times" array is the serial timing
speedup = times[0]/times 

# Plot
fig = plt.figure()
ax  = fig.add_subplot(111) 
ax.plot(procs, speedup, '-x')
ax.legend()
ax.set_xlabel("processors")
ax.set_ylabel("speedup")
ax.set_title("strong scaling")

# Save the figure
fig.savefig("strong_scaling_plot.png", dpi=300)