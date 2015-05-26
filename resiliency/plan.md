# Resiliency

- Availability
  - Sum of hard dependencies availability
    - 99.99% -> 4m20s of downtime
    - If you depends on 10 99.99% services you are at best 99.9% -> 43m48s
    - That's the basis of aviation reliability
      - Isolate subsystems
      - Make them redundant until they are available enough
  - Even the most monolithic applications have external dependencies
    - Data stores
    - External APIs
    - Network providers
    - ...

- Classic approach 
  - The obvious answer is to improve the dependencies availability
  - It becomes increasingly more difficult and expensive
  - Even the most fault tolerant systems can be brought down by human error or nasty bugs
  
- The resiliency approach
  - Let's make hard dependencies less hard
  - Both approach are complementary

- Fallacies of distributed computing
  - The network is reliable.
  - Latency is zero.
  - Bandwidth is infinite.
  - The network is secure.
  - Topology doesn't change.
  - There is one administrator.
  - Transport cost is zero.
  - The network is homogeneous.

- Shits happen
  - List said shits
    - MySQL segfaults
    - Memcache packet drop
    - Memcache 100Mbit/s link
    - Redis KEYS / FLUSHDB
    - Wrong server unplugged for maintenance
    - ElasticSearch stop the world GC

- Fail gracefully or fail fast
  - Cascading failures have mostly 2 pattern
    - Functional dependencies
    - Capacity depletion

- Fail gracefully
  - Prevent interdependencies (failure matrix)
  - Deal with errors at the proper abstraction level
    - Too low you can't take decisions
    - Too high is unmaintainable
  - Test them (toxiproxy)

- Fail fast
  - https://en.wikipedia.org/wiki/Little%27s_law
  > The long-term average number of customers in a stable system L is equal to the long-term average effective arrival rate, λ, multiplied by the (Palm‑)average time a customer spends in the system, W; or expressed algebraically: L = λW.
  - Capacity = Throughput / Response Time
    - 60ms response time = 1kRPM per thread
    - 300kRPM = 300 thread

    - if 1% of the traffic timeout on a resource after 30 seconds
      - 30s response time = 2RPM
      - 3kRPM = 1500 threads (5 times more)
  - Keep your timeouts low
  - Changes are, some legit request are in the 20-30 seconds range. e.g exports etc.
  - semian
    - Circuit breakers
    - Semaphores

- You probably don't need to do all this
  - The 
  - A few advices on how never have to waste time on resiliency
    - Always keep your timeouts low, especially the web server one.
      - 5 seconds should be enough for every web request
    - Think twice before adding a new dependency
    - Put boundaries to everthing, e.g. cap tags to 50 per product
