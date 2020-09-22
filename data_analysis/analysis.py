import pandas as pd
from matplotlib import pyplot as plt
import numpy as np

df = pd.read_csv('data.csv',index_col=0)
df = df.iloc[1:]
#df = df[['GPU_SIEVE','CPU_SIEVE']]
df['Ticks'] = range(0,len(df.index.values))
df.head()
one_tenth = df.sample(frac=.1, random_state = np.random.randint(10))
one_tenth = one_tenth.sort_values(by=['Ticks'],ascending=True)
one_tenth['Rolling_Mean_GPU'] = one_tenth['GPU_SIEVE'].rolling(window = 5).mean()
one_tenth['Rolling_Mean_CPU'] = one_tenth['CPU_SIEVE'].rolling(window = 5).mean()
one_tenth['Rolling_Mean_CPU_CLASSIC'] = one_tenth['CPU_CLASSIC'].rolling(window = 5).mean()
one_tenth = one_tenth.iloc[4:]
one_tenth = one_tenth.drop(['GPU_SIEVE','CPU_SIEVE','CPU_CLASSIC','Ticks'],axis=1)
one_tenth.rename(columns={"Rolling_Mean_GPU":"GPU Sieve","Rolling_Mean_CPU":"CPU Sieve","Rolling_Mean_CPU_CLASSIC":"CPU classic"},inplace=True)
print(one_tenth)

#slice
#one_tenth = one_tenth.iloc[:30]
#print(one_tenth)
#end slice
one_tenth[['GPU Sieve','CPU Sieve','CPU classic']].plot()

plt.savefig('all.png', dpi=150,bbox_inches='tight')
#one_tenth[['GPU_SIEVE','CPU_SIEVE','CPU_CLASSIC']].plot()
#plt.show()
