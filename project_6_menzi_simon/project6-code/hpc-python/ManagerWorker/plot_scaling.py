import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


def plot_for_runtimes(file: str, out_file_addon: str):
    plt.clf()  # Clear plot

    df = pd.read_csv(file)

    # Strong scaling plot
    avg_runtimes = df.iloc[:, 2:].mean(axis=1)
    workers = pd.unique(df["workers"])
    sizes = pd.unique(df["tasks"])

    df["avg_runtime"] = avg_runtimes

    # Plot strong scaling #########################################

    plt.title(f"Strong Scaling")

    global_max_speedup = 0

    for n in sizes:
        avg_runtimes = df[df["tasks"] == n]["avg_runtime"]
        speedup = avg_runtimes.iloc[0] / avg_runtimes
        all_runtimes = df[df["tasks"] == n].iloc[:, 2:]
        min_speedup = all_runtimes.iloc[0, :].min() / all_runtimes.max(axis=1)
        max_speedup = all_runtimes.iloc[0, :].max() / all_runtimes.min(axis=1)

        plt.plot(workers, speedup, label=n)
        # plt.fill_between(workers, min_speedup, max_speedup, alpha=.3)

        if global_max_speedup < max_speedup.max():
            global_max_speedup = max_speedup.max()

    plt.xlabel("Number of workers")
    plt.ylabel("Speedup")
    plt.legend()

    plt.plot(np.array([1, 32]), np.array([1, 32]), "r--")

    plt.savefig("strong_scaling_" + out_file_addon)

    # Plot weak scaling ##############################################

    plt.clf()  # Clear plot

    plt.title(f"Weak Scaling")

    efficiencies = np.array([])
    weak_scaling_processes = np.array([])
    thread_number = 1
    for i, n in enumerate(sizes[-3:]):
        if thread_number > workers.max():
            break

        print(thread_number)
        print(n)

        serial_runtime = df[df["tasks"] == n]["avg_runtime"].iloc[0]
        parallel_runtime = df[(df["tasks"] == n) & (df["workers"] == thread_number)][
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
    # annotate the plot points with the tasks n
    for i, txt in enumerate(sizes[-3:]):
        plt.annotate(f"{txt}x{txt}", (weak_scaling_processes[i], efficiencies[i]))

    plt.ylim(0, np.max([1.05, efficiencies.max() + 0.05]))
    plt.xlabel("Number of workers")
    plt.ylabel("Efficiency")

    plt.savefig("weak_scaling_" + out_file_addon)


if __name__ == "__main__":
    plot_for_runtimes("runtimes.csv", "mandelbrot.png")
