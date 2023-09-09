# PAD Lab1
A microservices based API for a school management app


### Assess Application Suitability. 

#### Why not a monolith?

* **The application can grow big and cause very slow deployments.** There are a lot of features that 
can be added further such as a chat service, a calendar integration service, statistics service,
legal documents service, student admission, online quizzes.
* **Inability to deploy a particular part of the application independently**. If only one small part of the
application required a change, such as fixing a bug with students list endpoint, this may cause the slow redeployment
of the entire application. Some parts of the system may remain unchanged, while other may require multiple deployments
often. In case of a slow deployment, this would cause a long downtime and system unavailability, but teachers and 
students will require to access the system during the lessons on demand, in order to put marks and to record
attendance, in order to submit homework. The schools can be situated across the glob, so deploying only at night 
is not a solution because of time differences in clients.
* **A bug in one function may cause the entire system to go down at once**. For example an administrator might try
to create a school, a critical bug may happen, and the entire system will go down. The teachers will not be able
to record attendance and puts marks.
* **Limited vertical scalability** The more logic the monolith encapsulates, the more computer resources are needed,
but there are certain limitations on CPUs and RAMs.
* **Slower services in the monolith may cause delays for the rest of system**. Separating may reduce load on the
entire system, increasing system availability and reducing latency.
* **Some security issues may cause unauthorised access to all components at once**

#### Why microservices?

* **Independent horizontal scaling**: Microservices are easier and often cheaper to scale horizontally. Monolithic
applications are usually resource-heavy and running them on numerous instances could be
quite expensive due to high hardware requirements. Microservices, however, can be scaled
independently. So, if a particular part of the system requires running on hundreds or thousands
of servers, other parts don't need to follow the same requirements. For example, the service responsible for
marking attendance, or passing quizzes may require more servers and thus can be scaled individually.
* **More independence in code development**
* **Technological freedom** Some services may require to be written in some specific technologies. For example the 
chat service.

## Define Service Boundaries

There will be 3 main microservices:
1. **User Service** - responsible for registering, authentication and authorization of users
2. **Schools Administration Service** - responsible for creating schools, new semesters, classes
3. **Lessons Service** - responsible for creating courses and lessons, marking attendance and registering marks, 
viewing the schedule

System architecture diagram: 
[to be completed]

## Choose Technology Stack and Communication Patterns

The chosen programming language for the services is Go. Go provides simplicity in writing network and concurrent applications. 
Network calls, data serialization, encoding are done with ease in Go with just the standard library.
The final application represents a simple native compiled binary, which makes it very easy to deploy.
Explicit error handling in Go ensures that services handle different failures in a right way.

The API gateway will be written in [to be completed]

The external client (front-end app e.g.) will communicate with the API Gateway
through a RESTful API. The microservices will communicate through RPC calls between themselves and with the API Gateway.
The Gateway will serve as synchronous RPC Client, and thus the communication will be synchronous.

## Design Data Management

Each service will have each own SQL database PostgreSQL.

### **User Service**



### **Schools Administration Service**

### **Lessons Service**
