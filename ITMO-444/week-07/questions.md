# Exercises - Chapter 05 Application Architecture

# 1. What is scaling?
A system’s ability to scale is its ability to process a growing workload, usually measured in transactions per second, amount of data, or number of users.
# 2. What are the options for scaling a service that is CPU bound?
Moving the service to a machine that has faster or more CPUs
# 3. What are the options for scaling a service whose storage requirements are growing?
Exponentially increase your storage options to prepare for higher demand. Buying up storage servers and other machines dedicated to storing data.
# 4. The data in Figure 1.10 is outdated because hardware tends to get less expensive every year. Update the chart for the current year. Which items changed the least? Which changed the most?
L1 cache reference = 1ns

Brand mispredict = 3ns

L2 cache reference = 4ns

Mutex lock/unlock = 17ns

Main memory reference = 100ns

Compress 1kb with Zippy = 2000ns

Send 2k bytes over 1Gbps network = 44ns

Read 1mb sequentially from memory = 3000ns

Round trip in same datacenter = 500,000ns

Read 1mb from SSD = 49,000ns

Disk seek = 2ms

Read 1mb sequentially from a disk = 825,000ns

Packet roundtrip CA to Netherlands = 150ms
# 5. Rewrite the data in Figure 1.10 in terms of proportion. If reading from main memory took 1 second, how long would the other operations take? For extra credit, draw your answer to resemble a calendar or the solar system.
Packet roundtrip CA to Netherlands = 150ms

Disk seek = 2ms

Read 1mb sequentially from a disk = 825,000ns

Round trip in same datacenter = 500,000ns

Read 1mb from SSD = 49,000ns

Read 1mb sequentially from memory = 3000ns

Compress 1kb with Zippy = 2000ns

Main memory reference = 100ns

Mutex lock/unlock = 17ns

L2 cache reference = 4ns

Brand mispredict = 3ns

L1 cache reference = 1ns
# 6. Take the data table in Figure 1.10 and add a column that identifies the cost of each item. Scale the costs to the same unit—for example, the cost of 1 terabyte of RAM, 1 terabyte of disk, and 1 terabyte of L1 cache. Add another column that shows the ratio of performance to cost.
1TB RAM = $4300

1TB L1 Cache = $9500

1TB L2 cache = $12500

1TB SSD = $150

1TB HDD = $50

# 7. What is the theoretical model that describes the different kinds of scaling techniques?
AKF Scaling Cube
# 8. How do you know when scaling is needed?
Scaling is needed when a service is running slowly due to computational or storage limitations. Both can be increased via scaling which allows the service to access more hardware and storage resources to run more smoothly.
# 9. What are the most common scaling techniques and how do they work? When are they most appropriate to use?
X-axis scaling: The x-axis (horizontal scaling) is a power multiplier, cloning systems or increasing their capacities to achieve greater performance. 

Y-axis scaling: The y-axis (vertical scaling) scales by isolating transactions by their type or scope, such as using read-only database replicas for read queries and sequestering writes to the master database only.

Z-axis scaling: the z-axis (lookup-based scaling) is about splitting data across servers so that the workload is distributed according to data usage or physical geography.

# 10. Which scaling techniques also improve resiliency?
Y-axis scaling
# 11. Research Amdahl’s Law and explain how it relates to the AKF Scaling Cube.
Amdahl’s Law is about calculating the speedup in latency of a computational task being executed. This relates to the AFK scaling cube because it can help calculate how much computational power is necessary to run a program in a certain amount of time. This can help make scaling more accurate and effective. 
