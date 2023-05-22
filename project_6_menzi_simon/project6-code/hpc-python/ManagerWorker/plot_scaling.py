import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


def plot_for_runtimes(file: str, title_addon: str, out_file_addon: str):
    plt.clf()  # Clear plot

    df = pd.read_csv(file)

    # Strong scaling plot
    times = pd.unique(df["time"])
    tasks = pd.unique(df["tasks"])
    workers = pd.unique(df["workers"])
    

    # Plot strong scaling #########################################

    plt.title(f"Strong Scaling ({title_addon})")


    for n in sizes:
 
        speedup = times.iloc[0] / times
        all_runtimes = df[df["tasks"] == n].iloc[:, 2:]
    

        plt.plot(processes, speedup, label=n)
        # plt.fill_between(processes, min_speedup, max_speedup, alpha=.3)

    plt.xlabel("Number of processes")
    plt.ylabel("Speedup")
    plt.legend()

    plt.plot(np.array([1, 32]), np.array([1, 32]), "r--")

    plt.savefig("strong_scaling_" + out_file_addon)

    # Plot weak scaling ##############################################

    plt.clf()  # Clear plot

    plt.title(f"Weak Scaling ({title_addon})")

    efficiencies = np.array([])
    weak_scaling_processes = np.array([])
    thread_number = 1
    for i, n in enumerate(sizes[-3:]):
        if thread_number > processes.max():
            break

        print(thread_number)
        print(n)

        serial_runtime = df[df["size"] == n]["avg_runtime"].iloc[0]
        parallel_runtime = df[(df["size"] == n) & (df["processes"] == thread_number)][
            "avg_runtime"
        ].iloc[0]
        speedup = serial_runtime / parallel_runtime
        efficiencies = np.append(efficiencies, speedup / thread_number)
        weak_scaling_processes = np.append(weak_scaling_processes, thread_number)
        thread_number *= 4

    print(efficiencies)

    plt.plot(weak_scaling_processes, efficiencies, marker="o")
    plt.plot(
        np.array([weak_scaling_processes.min(), weak_scaling_processes.max()]),
        np.array([1, 1]),
        "r--",
    )
    # annotate the plot points with the size n
    for i, txt in enumerate(sizes[-3:]):
        plt.annotate(f"{txt}x{txt}", (weak_scaling_processes[i], efficiencies[i]))

    plt.ylim(0, np.max([1.05, efficiencies.max() + 0.05]))
    plt.xlabel("Number of processes")
    plt.ylabel("Efficiency")

    plt.savefig("weak_scaling_" + out_file_addon)


if __name__ == "__main__":
    plot_for_runtimes("runtimes_one_node.csv", "1 node", "one_node.png")

    plot_for_runtimes(
        "runtimes_one_per_node.csv", "1 process per node", "one_per_node.png"
    )
