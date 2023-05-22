import pandas as pd
import matplotlib.pyplot as plt

# Read the CSV file
df = pd.read_csv('filename.csv')

# Create two dataframes, one for strong scaling and one for weak scaling
df_strong = df[df['tasks'] == 50]
df_weak = df[df['tasks'] == 100]

# Sort both dataframes by the number of workers
df_strong = df_strong.sort_values(by=['workers'])
df_weak = df_weak.sort_values(by=['workers'])

# Calculate the reference time for each dataframe
ref_time_strong = df_strong[df_strong['workers'] == 1]['time'].iloc[0]
ref_time_weak = df_weak[df_weak['workers'] == 1]['time'].iloc[0]

# Calculate the speedup for each dataframe
df_strong['speedup'] = ref_time_strong / df_strong['time']
df_weak['speedup'] = ref_time_weak / df_weak['time']

# Create separate plots for strong and weak scaling with speedup on y-axis
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 5))

ax1.plot(df_strong['workers'], df_strong['speedup'], label='Strong Scaling')
ax1.set_xlabel('Number of Workers')
ax1.set_ylabel('Speedup')
ax1.set_title('Strong Scaling Plot')

ax2.plot(df_weak['workers'], df_weak['speedup'], label='Weak Scaling')
ax2.set_xlabel('Number of Workers')
ax2.set_ylabel('Speedup')
ax2.set_title('Weak Scaling Plot')

plt.savefig("strong_and_weak_scaling.png")
