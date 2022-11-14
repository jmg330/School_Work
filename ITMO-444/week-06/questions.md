# Exercises - Chapter 04 Application Architecture

# 1. Describe the single-machine, three-tier, and four-tier web application architectures.

A single-machine web service pulls information from the internet to the webserver which stores static content, dynamic content, and database-driven dynamic content.

A three-tier web service pushes and pulls information to and from the internet. It also has 3 different web servers, a load balancer, and a data server.

A four-tier web service pushes and pulls information to and from the internet. It has a load balancer, four frontend web applications, two app servers, and a data server.

# 2. Describe how a singlemachine web server, which uses a database to generate content, might evolve to a three-tier web server. How would this be done with minimal downtime?

By adding a load balancer which would make it easier to deploy an additional two web servers, thus making it a three-tier web server. Once the load balancer is created, adding additional web servers wouldn’t require much downtime if any at all. 

# 3. Describe the common web service architectures, in order from smallest to largest.

1. Single-machine
2. Three-tier
3. Four-tier
4. Cloud-scale

# 4. Describe how different local load balancer types work and what their pros and cons are. You may choose to make a comparison chart.

Network Load Balancer – Pros: It can control millions of requests per second. Cons: It only uses TCP/SSL and it tried to open TCP connections by default

Application Load Balancer -Pros: Can route to multiple ports on a container. Cons: Uses HTTP/HTTPs on the application layer for its routing decisions

Classic Load Balancer – Pros: Can you both the transport layer and application layer for its port routing. Cons:  Classic Load Balancers now need a solid connection between the load balancer port and the container instance port.

# 5. What is “shared state” and how is it maintained between replicas?

A shared state stores information in the backend where any replica can access it. This is helpful because the user is not asked to log back in every time the backends are switched. 

# 6. What are the services that a four-tier architecture provides in the first tier?

Load balancer

# 7. What does a reverse proxy do? When is it needed?

A reverse proxy enables one web server to provide content from another web server transparently. It can be used when a website has many different pages that users can be taken to via clicking on them. 

# 8. Suppose you wanted to build a simple image-sharing web site. How would you design it if the site was intended to serve people in one region of the world? How would you then expand it to work globally?

I would start by creating a four-tier web service that allows me to have multiple web servers running on different machines. If I were to expand globally, I would then change to a Cloud-scale web service architecture that has Datacenters all over the world for faster connections.

# 9. What is a message bus architecture and how might one be used?

A message bus is a many-to-many communication mechanism between servers. It is a convenient way to distribute information among different services. It can be used if you have servers that you want to send messages over via publisher and subscriber channels.

# 10. What is an SOA?

SOA stands for service-oriented architecture. It is a combination of different services that are used to create a new application. 

# 11. Why are SOAs loosely coupled?

They are much more difficult to maintain when they are tightly coupled.

# 12. Who was Christopher Alexander and what was his contribution to architecture?

Christopher Alexander is a famous architect and design theorist. He is regarded as the father of the pattern language and created the first wiki, which was then used to create websites such as Wikipedia. 



