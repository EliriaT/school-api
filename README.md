# PAD Lab1
A microservices based API for a school management app, an LMS (Learning Management Systems)

### Build the project

You can build each image separately:

`docker build -t school-service .`

`docker build -t course-service .`

`docker build -t gateway .`

`docker build -t service-discovery .`

or:

`docker-compose build`

or pull the remote images:

`docker-compose pull`

Then just run:

`docker compose up`

### Steps for accessing endpoints
1. All the endpoints of the gateway are accesible at http://localhost:8080 .
2. Firstly a school has to be created at POST /schools
2. Then a user can be registered at POST /users. For now there is no restriction for role id, but in future it must exist
3. Once there exist a user and  a school, a class can be created at POST /class. headTeacher field must be ID of an existing user. Similarly for schoolId
4. To create a student, you must assign a user to a class at POST /student. In future only users with student role will be able to be assigned to a class
5. Once a class exists, multiple courses for that class can be created. The teacher who teaches the class is specified at teacherId field. In future only users with teacher role will be able to be assigned to a course.
6. To create several lesson at a specific day of week and with a start time and end time, access the POST /lesson endpoint
7. To create a mark for a course and assigned to a student, access the POST /mark endpoint
8. Other useful endpoints: GET course/:id , GET class/:id , GET users/:id , GET /health



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
* **Slower services in the monolith may cause delays for the rest of system**. For example, there might be a 
statistic feature, that would provide monthly and yearly statistics about attendance, marks, homeworks. This service
would be slower and may cause delays for the rest of the application. Separating may reduce load on the
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

Some similar LMS systems that employ microservices are: edX, canvas, Google Classroom.

## Define Service Boundaries

There will be 3 main microservices:
1. **Schools Administration Service** - responsible for creating users, students, creating schools, classes
2. **Lessons Service** - responsible for creating courses and lessons, marking attendance and registering marks, 
viewing the schedule

System architecture diagram: 

![Architecture Diagram PADLab2 drawio](https://github.com/EliriaT/school-api/assets/67596753/c666ef0a-c599-4cc2-9f22-2ecefe0176de)



## Choose Technology Stack and Communication Patterns

The chosen programming language for the services is Go. Go provides simplicity in writing network and concurrent applications. 
Network calls, data serialization, encoding are done with ease in Go with just the standard library.
The final application represents a simple native compiled binary, which makes it very easy to deploy.
Explicit error handling in Go ensures that services handle different failures in a right way.

The API gateway will be written in Elixir.

The external client (front-end app e.g.) will communicate with the API Gateway
through a RESTful API. The microservices will communicate through RPC calls between themselves and with the API Gateway.
The Gateway will serve as synchronous RPC Client, and thus the communication will be synchronous.

## Design Data Management

Each service will have each its own PostgreSQL database.

### **Schools Administration Service**

![Schools Administration Service](https://github.com/EliriaT/school-api/assets/67596753/7ceceb0f-5f31-4205-8fb9-f00f42a44f24)



### **Lessons Service**

![LessonsService](https://github.com/EliriaT/school-api/assets/67596753/bc6cafae-d094-41d1-a9fb-ce4adbecca4b)


### **External Endpoints**

The list of endpoints provided to the client by the API Gateway:

* **User Service**

`– POST /users` - Creates a users.

<details>
           <summary>Request Body</summary>
          
```
{
    "email" : "irinatiora7@gmail.com",
    "name" : "Tiora Irina",
    "password": "541236545",
    "school_id":1,
    "role_id":2,
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "status": "201"
}
```
</details>

`– POST /users/login` -  Login to the service. 

<details>
           <summary>Request Body</summary>

```
{
    "email":"irinaAdmin@gmail.com",
    "password" :"1234567"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "status": "200",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzA3NTA1NzIsImlzcyI6InNjaG9vbC1hb2kiLCJJZCI6MSwiRW1haWwiOiJpcmluYTdAZ21haWwuY29tIiwiU2Nob29sSWQiOjEsIkNsYXNzSWQiOjAsIlJvbGVJZCI6MTB9.LQFoZcMnpwdY77OHN0bYTmYPpZUV_1qVcwlqBRniY5g"
}
```
</details>

`– GEY /users/:id` - Get a user by id

<details>
           <summary>Response Body</summary>

```
{
    "data": {
        "email": "irina7@gmail.com",
        "id": "1",
        "name": "irina",
        "roleId": "10",
        "schoolId": "1"
    },
    "status": "200"
}
```
</details>

* **Schools Administration Service**

`– POST /schools` - Creates a school.

<details>
           <summary>Request Body</summary>

```
{
    "name" :  "I.P.L.T. Mihai Viteazu"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "status": "201"
}
```
</details>


`– POST /class ` -  Creates a class.

<details>
           <summary>Request Body</summary>

```
{
    "headTeacher": "1",
    "name": "clasa2",
    "schoolId": "2"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "status": "201"
}
```
</details>

`– GET /class/:id` -  Get a class by id

<details>
           <summary>Response Body</summary>

```
{
    "data": {
        "headTeacher": "1",
        "id": "1",
        "name": "clasa2",
        "schoolId": "2"
    },
    "status": "200"
}
```
</details>

`- POST -/student` - Create a student

<details>
           <summary>Request Body</summary>

```
{
    "userID": "1",
    "classID": "3"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "status": "201"
}
```
</details>

* **Lessons Service**

`– POST /course` - Creates a course.

<details>
           <summary>Request Body</summary>

```
{
    "classId": "3",
    "name": "laboris in ut",
    "teacherId": "1"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "status": "201"
}
```
</details>

`– GET /course/:id` - Get course`s marks

<details>
           <summary>Response Body</summary>

```
{
    "data": {
        "classId": "3",
        "id": "2",
        "marks": [
            {
                "courseId": "2",
                "id": "1",
                "mark": 8,
                "markDate": "17.11.2024",
                "studentId": "2"
            },
            {
                "courseId": "2",
                "id": "2",
                "mark": 8,
                "markDate": "17.11.2024",
                "studentId": "2"
            },
            {
                "courseId": "2",
                "id": "3",
                "mark": 8,
                "markDate": "17.11.2024",
                "studentId": "2"
            },
            {
                "courseId": "2",
                "id": "36",
                "mark": 8,
                "markDate": "17.11.2024",
                "studentId": "2"
            },
            {
                "courseId": "2",
                "id": "37",
                "mark": 8,
                "markDate": "17.11.2024",
                "studentId": "2"
            },
            {
                "courseId": "2",
                "id": "38",
                "mark": 8,
                "markDate": "17.11.2024",
                "studentId": "2"
            },
            {
                "courseId": "2",
                "id": "39",
                "mark": 8,
                "markDate": "17.11.2024",
                "studentId": "2"
            }
        ],
        "name": "laboris in ut",
        "teacherId": "1"
    },
    "status": "200"
}
```
</details>

`– POST /lesson` -  Creates a lesson for a course. Access limited to director and manager

<details>
           <summary>Request Body</summary>

```
{
    "classRoom": "Ut culpa mollit ad magna",
    "courseId": "4",
    "endHour": "10:45",
    "name": "sunt nostrud anim nulla non",
    "startHour": "10:00",
    "weekDay": "Monday"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "status": "201"
}
```
</details>

`– POST /mark` - Creates a mark or absence .

<details>
           <summary>Request Body</summary>

```
{
    "courseId": "2",
    "isAbsent": false,
    "mark": 8,
    "markDate": "17.11.2024",
    "studentId": "2"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "status": "201"
}
```
</details>

## Deployment and Scaling:
Microservices can be deployed using Docker container.
