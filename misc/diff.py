import matplotlib.pyplot as plt
import pandas as pd

# TODO: instead of line use bars and they should be displayed side by side (x axis should display the endpoint and ideally the RL, basically the headers of the CSV)

csv_paths=["/home/ipelu/Desktop/uni/tfm/NEW_RESULTS/4slas_2apikeys/npm_test_full_pinned.csv",
           "/home/ipelu/Desktop/uni/tfm/NEW_RESULTS/6slas_2apikeys/npm_test_full_pinned.csv",
           "/home/ipelu/Desktop/uni/tfm/NEW_RESULTS/8slas_2apikeys/npm_test_full_pinned.csv",
           "/home/ipelu/Desktop/uni/tfm/NEW_RESULTS/8slas_4apikeys/npm_test_full_pinned.csv"]

plotpos = [141, 142, 143, 144]

for csv_path in csv_paths:
    bmk1_results_pd = pd.read_csv(csv_path, index_col=False)  

    plt.figure(figsize=(20,11))

    count = 0

    for proxy in ["envoy", "haproxy", "traefik", "nginx"]:

        results = bmk1_results_pd.loc[bmk1_results_pd['Proxy'] == proxy].values.tolist()[0]
        
        #header = bmk1_results_pd.columns.tolist()[1:]
        header = [elem.split(" - ")[-1] for elem in bmk1_results_pd.columns.tolist()[1:]]

        expected = [] 
        obtained = []
        
        for result in results[1:]:
            #print(result)
            try: 
                result = result.replace("Got ","").replace(" instead of ",",").split(",") 
            except:
                # TODO: when it's 0 is because the result matched the expected, otherwise simply don't show anything
                result = [0,0]
            expected.append(int(result[1]))
            obtained.append(int(result[0]))

        #counter = 221+count
        #plt.subplot(counter)
        plt.subplot(plotpos[count])
        plot_name = csv_path.split('/')[-2]
        plot_name_mod = plot_name.replace("slas_"," SLAs, ").replace("apikeys", " apikeys each")
        plt.suptitle(plot_name_mod, fontsize=25)
        #plt.title("title here")

        plt.title(proxy)

        # Width of a bar 
        width = 0.4

        # Bars
        plt.bar(range(1,len(expected)+1), expected, color ='green', width = width)
        plt.bar([elem + width for elem in range(1,len(obtained)+1)], obtained, color ='red', width = width)

        # Lines
        #plt.plot(range(1,len(expected)+1), expected, "-o")
        #plt.plot(range(1,len(obtained)+1), obtained, "-o")

        plt.ylabel("Requests")
        plt.xlabel("Endpoint Rate Limiting")
        plt.yticks(range(0, 27000, 2000), rotation=90, fontsize = 10)
        plt.xticks([elem + width / 2 for elem in range(1,len(obtained)+1)], labels = header, rotation=90, fontsize = 10)
        
        count = count + 1

    plt.savefig('diff_plot_%s.png' % plot_name)