#!/usr/bin/env python
# coding: utf-8

# In[128]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
t = np.linspace(0,239,240)
hour = np.linspace(0,23,24)


# ## 1. Traffic Data

# In[129]:


traffic = pd.read_csv('1_Traffic_Data.csv')
plt.plot(t,traffic)
plt.ylabel("Traffic (Mbps)")
plt.grid()
plt.xticks((12,36,60,84,108,132,156,180,204,228), ('Mon','Tue', 'Wed', 'Thu','Fri','Sat', 'Sun','Mon','Tue', 'Wed'), rotation = 45)


# ## 2. Traffic vs Centralization

# In[130]:


traffic_DU_Centralizaed = pd.read_csv('2_UT_vs_Centralization.csv')
traffic_all = traffic_DU_Centralizaed.iloc[:,0]
n_DU_centralized = traffic_DU_Centralizaed.iloc[:,1]
plt.subplot(211)
plt.plot(traffic_all)
plt.ylabel("Total Traffic (Mbps)")
plt.xlabel("time (Hours)")

plt.grid()

plt.subplot(212)
plt.step(range(len(n_DU_centralized)), n_DU_centralized)
plt.ylabel("Total DUs centralized")
plt.xlabel("t (Hours)")

plt.grid()


# ## 3. Percentange BW Used

# In[131]:


BW_used = pd.read_csv('3_Percentage_BW_Used.csv')
BW_used_adaptive_split = BW_used.iloc[:,0]
BW_used_Option_6 = BW_used.iloc[:,1]
BW_used_Option_2 = BW_used.iloc[:,2]
# plt.hold(True)
plt.plot(BW_used_adaptive_split, label = 'Adaptive Split')
plt.plot(BW_used_Option_6, label = 'Option-6')
plt.plot(BW_used_Option_2, label = 'Option-2')
plt.grid()
plt.legend()
plt.ylabel("BW used(%)")
plt.xlabel("t (Hours)")
plt.show()


# ## 4. Split Runtime of DUs

# In[132]:


Split_Run_Time_DU = pd.read_csv('4_Split_Run_Time_DU.csv')
Split_Run_Time_DU = Split_Run_Time_DU.iloc[:,1:]
# print(Split_Run_Time)
temp = Split_Run_Time_DU.iloc[:,0]
temp
ind = range(10)
# width = 0.35
p1 = plt.bar(ind,Split_Run_Time_DU.iloc[:,0])
p2 = plt.bar(ind,Split_Run_Time_DU.iloc[:,1])
p3 = plt.bar(ind,Split_Run_Time_DU.iloc[:,2])
p4 = plt.bar(ind,Split_Run_Time_DU.iloc[:,3])
p5 = plt.bar(ind,Split_Run_Time_DU.iloc[:,4])
p6 = plt.bar(ind,Split_Run_Time_DU.iloc[:,5])

plt.show()


# ## 5. Split Runtime

# In[133]:


Split_Run_Time = pd.read_csv('5_Split_Run_Time_Splits.csv')
# plt.grid()
# plt.xticks((12,36,60,84,108,132,156,180,204,228), ('Mon','Tue', 'Wed', 'Thu','Fri','Sat', 'Sun','Mon','Tue', 'Wed'), rotation = 45)

ind = range(6)
# width = 0.35
p1 = plt.bar(ind, Split_Run_Time.iloc[:,1])
plt.xticks(ind, ('Option-6 (100MHZ)', 'Option-7 (20MHZ)', 'Option-7 (40MHZ)', 'Option-7 (60MHZ)','Option-7 (80MHZ)','Option-7 (100MHZ)'), rotation = 45)
plt.ylabel("Run time of different split options (%)")


# ## 6. Hourly Analysis of Dynamic Split

# In[138]:


Split_Run_Time_DU_Hourly = pd.read_csv('6_Hourly_analysis_of_Dynamic_Split.csv')
ind = range(24)
# width = 0.35
p1 = plt.bar(ind,Split_Run_Time_DU_Hourly.iloc[:,0])
p2 = plt.bar(ind,Split_Run_Time_DU_Hourly.iloc[:,1])
p3 = plt.bar(ind,Split_Run_Time_DU_Hourly.iloc[:,2])
p4 = plt.bar(ind,Split_Run_Time_DU_Hourly.iloc[:,3])
p5 = plt.bar(ind,Split_Run_Time_DU_Hourly.iloc[:,4])
p6 = plt.bar(ind,Split_Run_Time_DU_Hourly.iloc[:,5])
# for i in range(24):
#     p = plt.bar(ind,Split_Run_Time_DU_Hourly.iloc[:,i])

plt.show()


# ## 7. Hourly Analysis (Total)

# In[134]:


DUs_centralized = pd.read_csv('7_Hourly_analysis_total.csv')
plt.plot(hour,DUs_centralized)
plt.grid()
plt.xlabel("t (Hours)")
plt.ylabel("DUs centralized (%)")

# plt.xticks((12,36,60,84,108,132,156,180,204,228), ('Mon','Tue', 'Wed', 'Thu','Fri','Sat', 'Sun','Mon','Tue', 'Wed'), rotation = 45)


# In[ ]:




