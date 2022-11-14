## Chapter 01 - Designing for a Distributed World

1. What is distributed computing?

Distributed computing describes an architecture where applications and services are provided using many machines rather than one.

2. Describe the three major composition patterns in distributed computing.

• Load balancer with multiple backend replicas
• Server with multiple backends
• Server tree

3. What are the three patterns discussed for storing state?

- Storing on one machine in a shard
- Storing multiple shards on multiple machines
- Storing shards on multiple machines with replicas

4. Sometimes a master server does not reply with an answer but instead replies with where the answer can be found. What are the benefits of this method?

When dealing with large files, it makes more sense to provide the location rather than the content because of the amount of time it would take to display the content. 

5. Section 1.4 describes a distributed file system, including an example of how reading terabytes of data would work. How would writing terabytes of data work? 

It’s broken down into smaller bytes of data that are more manageable to write in a decent amount of time. 

6. Explain the CAP Principle. (If you think the CAP Principle is awesome, read “The Part-Time Parliament” (Lamport & Marzullo 1998) and “Paxos Made Simple” (Lamport 2001).)

The CAP Principle states that it is not possible to build a distributed system that guarantees consistency, availability, and resistance to partitioning.

7. What does it mean when a system is loosely coupled? What is the advantage of these systems?

Loosely coupled systems are systems that are comprised of smaller sub-systems. It makes it easier to scale each sub-system independently. 

8. How do we estimate how fast a system will be able to process a request such as retrieving an email message?

The general unit of measurement used to measure the speed of a computer process is done in milliseconds or nanoseconds.

9. In Section 1.7 three design ideas are presented for how to process email deletion requests. Estimate how long the request will take for deleting an email message for each of the three.

The first being the slowest would take roughly 20-30ms
The second being the semi-fastest would take between 10-15ms
The third and fastest option would take roughly <10ms


