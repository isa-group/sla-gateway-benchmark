import matplotlib.pyplot as plt
import pandas as pd

bmk2_csv_path = "/tmp/npm_test_loops.csv"
bmk2_results_pd = pd.read_csv(bmk2_csv_path, index_col=False)  
plots_location = "/tmp"

for proxy in ["envoy", "haproxy", "traefik", "nginx"]:
    plt.figure(figsize=(12,11))

    count = 0
    for sleepPeriod in ["Sleep 0s","Sleep 0.25s","Sleep 0.5s","Sleep 1s"]:
        
        current_proxy_values = bmk2_results_pd.loc[bmk2_results_pd['Proxy'] == proxy]['Sleep 0s'].tolist()
        
        counter = 221+count
        plt.subplot(counter)
        plt.suptitle(proxy, fontsize=25)
        plt.title(sleepPeriod)
        
        plt.plot(range(1,len(current_proxy_values)+1), current_proxy_values, "-o")
        
        plt.ylabel("Accepted requests")
        plt.xlabel("Iteration number")
        plt.yticks(range(0, 700, 50))
        plt.xticks(range(1, len(current_proxy_values)+1))

        count = count + 1 

    plt.savefig('%s/bmk_%s_plot.png' % (plots_location, proxy))
